import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris/feature/game/core/models/tetromino.dart';

///the height of game pad
const gamePadMatrixH = 20;

///the width of game pad
const gamePadMatrixW = 10;

///state of [GameControl]
enum GameStates {
  none,

  paused,

  running,

  reset,

  mixing,

  clear,

  drop,
}

class GameController extends StatefulWidget {
  const GameController({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  State<StatefulWidget> createState() => GameControl();

  static GameControl of(BuildContext context) {
    final state = context.findAncestorStateOfType<GameControl>();
    return state!;
  }
}

///duration for show a line when reset
const restLineDuration = Duration(milliseconds: 50);

const levelMax = 6;

const levelMin = 1;

const speed = [
  Duration(milliseconds: 800),
  Duration(milliseconds: 650),
  Duration(milliseconds: 500),
  Duration(milliseconds: 370),
  Duration(milliseconds: 250),
  Duration(milliseconds: 160),
];

class GameControl extends State<GameController> {
  GameControl() {
    //inflate game pad data
    for (int i = 0; i < gamePadMatrixH; i++) {
      _data.add(List.filled(gamePadMatrixW, 0));
      _mask.add(List.filled(gamePadMatrixW, 0));
    }
  }

  ///the gamer data
  final List<List<int>> _data = [];

  final List<List<int>> _mask = [];

  ///from 1-6
  int _level = 1;

  int _points = 0;

  int _cleared = 0;

  Tetromino? _current;

  Tetromino _next = Tetromino.getRandom();

  GameStates _states = GameStates.none;

  Tetromino _getNext() {
    final next = _next;
    _next = Tetromino.getRandom();
    return next;
  }

  void rotate() {
    if (_states == GameStates.running) {
      final next = _current?.rotate();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
      }
    }
    setState(() {});
  }

  void right() {
    if (_states == GameStates.none && _level < levelMax) {
      _level++;
    } else if (_states == GameStates.running) {
      final next = _current?.right();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
      }
    }
    setState(() {});
  }

  void left() {
    if (_states == GameStates.none && _level > levelMin) {
      _level--;
    } else if (_states == GameStates.running) {
      final next = _current?.left();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
      }
    }
    setState(() {});
  }

  Future<void> drop() async {
    if (_states == GameStates.running) {
      for (int i = 0; i < gamePadMatrixH; i++) {
        final fall = _current?.fall(step: i + 1);
        if (fall != null && !fall.isValidInMatrix(_data)) {
          _current = _current?.fall(step: i);
          _states = GameStates.drop;
          setState(() {});
          await Future<void>.delayed(const Duration(milliseconds: 100));
          await _mixCurrentIntoData();
          break;
        }
      }
      setState(() {});
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      _startGame();
    }
  }

  void down() {
    if (_states == GameStates.running) {
      final next = _current?.fall();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
      } else {
        _mixCurrentIntoData();
      }
    }
    setState(() {});
  }

  Timer? _autoFallTimer;

  ///mix current into [_data]
  Future<void> _mixCurrentIntoData() async {
    if (_current == null) {
      return;
    }
    //cancel the auto falling task
    _autoFall(false);

    _forTable((i, j) => _data[i][j] = _current?.get(j, i) ?? _data[i][j]);

    final clearLines = <int>[];
    for (int i = 0; i < gamePadMatrixH; i++) {
      if (_data[i].every((d) => d == 1)) {
        clearLines.add(i);
      }
    }

    if (clearLines.isNotEmpty) {
      setState(() => _states = GameStates.clear);

      for (int count = 0; count < 5; count++) {
        for (final int line in clearLines) {
          _mask[line].fillRange(0, gamePadMatrixW, count.isEven ? -1 : 1);
        }
        setState(() {});
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      for (final int line in clearLines) {
        _mask[line].fillRange(0, gamePadMatrixW, 0);
      }

      for (final int line in clearLines) {
        _data.setRange(1, line + 1, _data);
        _data[0] = List.filled(gamePadMatrixW, 0);
      }
      debugPrint('clear lines : $clearLines');

      _cleared += clearLines.length;
      _points += clearLines.length * _level * 5;

      //up level possible when cleared
      final int level = (_cleared ~/ 50) + levelMin;
      _level = level <= levelMax && level > _level ? level : _level;
    } else {
      _states = GameStates.mixing;
      _forTable((i, j) => _mask[i][j] = _current?.get(j, i) ?? _mask[i][j]);
      setState(() {});
      await Future<void>.delayed(const Duration(milliseconds: 200));
      _forTable((i, j) => _mask[i][j] = 0);
      setState(() {});
    }

    _current = null;

    if (_data[0].contains(1)) {
      reset();
      return;
    } else {
      _startGame();
    }
  }

  static void _forTable(dynamic Function(int row, int column) callback) {
    for (int i = 0; i < gamePadMatrixH; i++) {
      for (int j = 0; j < gamePadMatrixW; j++) {
        final b = callback(i, j);
        if (b is bool && b) {
          break;
        }
      }
    }
  }

  void _autoFall(bool enable) {
    if (!enable) {
      _autoFallTimer?.cancel();
      _autoFallTimer = null;
    } else if (enable) {
      _autoFallTimer?.cancel();
      _current = _current ?? _getNext();
      _autoFallTimer = Timer.periodic(speed[_level - 1], (t) {
        down();
      });
    }
  }

  void pause() {
    if (_states == GameStates.running) {
      _states = GameStates.paused;
    }
    setState(() {});
  }

  void pauseOrResume() {
    if (_states == GameStates.running) {
      pause();
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      _startGame();
    }
  }

  void reset() {
    if (_states == GameStates.none) {
      _startGame();
      return;
    }
    if (_states == GameStates.reset) {
      return;
    }
    _states = GameStates.reset;
    () async {
      int line = gamePadMatrixH;
      await Future.doWhile(() async {
        line--;
        for (int i = 0; i < gamePadMatrixW; i++) {
          _data[line][i] = 1;
        }
        setState(() {});
        await Future<void>.delayed(restLineDuration);
        return line != 0;
      });
      _current = null;
      _getNext();
      _points = 0;
      _cleared = 0;
      await Future.doWhile(() async {
        for (int i = 0; i < gamePadMatrixW; i++) {
          _data[line][i] = 0;
        }
        setState(() {});
        line++;
        await Future<void>.delayed(restLineDuration);
        return line != gamePadMatrixH;
      });
      setState(() {
        _states = GameStates.none;
      });
    }();
  }

  void _startGame() {
    if (_states == GameStates.running && _autoFallTimer?.isActive == false) {
      return;
    }
    _states = GameStates.running;
    _autoFall(true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<List<int>> mixed = [];
    for (var i = 0; i < gamePadMatrixH; i++) {
      mixed.add(List.filled(gamePadMatrixW, 0));
      for (var j = 0; j < gamePadMatrixW; j++) {
        int value = _current?.get(j, i) ?? _data[i][j];
        if (_mask[i][j] == -1) {
          value = 0;
        } else if (_mask[i][j] == 1) {
          value = 2;
        }
        mixed[i][j] = value;
      }
    }
    debugPrint('game states : $_states');
    return GameControllerState(
      mixed,
      _states,
      _level,
      _points,
      _cleared,
      _next,
      child: widget.child,
    );
  }
}

class GameControllerState extends InheritedWidget {
  const GameControllerState(
    this.data,
    this.states,
    this.level,
    this.points,
    this.cleared,
    this.next, {
    required super.child,
    super.key,
  });

  /// Brick data
  ///0: empty
  ///1: normal
  ///2: highlight
  final List<List<int>> data;

  final GameStates states;

  final int level;

  final int points;

  final int cleared;

  final Tetromino next;

  static GameControllerState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GameControllerState>()!;

  @override
  bool updateShouldNotify(GameControllerState oldWidget) => true;
}
