import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris/core/ui/identica.dart';
import 'package:tetris/feature/game/domain/tetromino.dart';

enum GameStates {
  none,
  running,
  paused,
  reset,
  mixing,
  clear,
  drop,
}

class GameNotifier extends ChangeNotifier {
  GameNotifier() {
    for (int i = 0; i < gameFieldHeight; i++) {
      _data.add(List.filled(gameFieldWidth, 0));
      _mask.add(List.filled(gameFieldWidth, 0));
      _tetrominoTypes.add(List.filled(gameFieldWidth, null));
      _tetrominoIdenticas.add(List.filled(gameFieldWidth, null));
    }
  }

  ///duration for show a line when reset
  final Duration restLineDuration = const Duration(milliseconds: 50);

  final int levelMax = 6;

  final int levelMin = 1;

  final List<Duration> speed = [
    const Duration(milliseconds: 800),
    const Duration(milliseconds: 650),
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 370),
    const Duration(milliseconds: 250),
    const Duration(milliseconds: 160),
  ];

  final int gameFieldHeight = 20;

  final int gameFieldWidth = 10;

  ///the gamer data
  final List<List<int>> _data = [];

  final List<List<int>> _mask = [];

  /// Данные о типах tetromino для каждого блока
  final List<List<TetrominoShapes?>> _tetrominoTypes = [];

  /// Данные об идентике для каждого блока
  final List<List<Identica?>> _tetrominoIdenticas = [];

  List<List<Identica?>> get tetrominoIdenticas => _tetrominoIdenticas;

  ///from 1-6
  int _level = 1;

  int get level => _level;

  int _points = 0;

  int get points => _points;

  int _cleared = 0;

  int get cleared => _cleared;

  Tetromino? _current;

  Tetromino? get currentTetromino => _current;

  Tetromino? _cachedNextTetromino;
  Tetromino? get cachedNextTetromino => _cachedNextTetromino;

  /// Инициализирует первый следующий тетромино
  void _initializeNextTetromino() {
    _cachedNextTetromino ??= Tetromino.getRandom();
  }

  GameStates _states = GameStates.none;

  GameStates get states => _states;

  void _pause() {
    if (_states == GameStates.running) {
      _states = GameStates.paused;
    }
    notifyListeners();
  }

  void togglePause() {
    if (_states == GameStates.running) {
      _pause();
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      _startGame();
    }
  }

  void rotate() {
    if (_states == GameStates.running) {
      final Tetromino? next = _current?.rotate();
      if (next != null &&
          next.isValidInMatrix(
            _data,
            gameFieldHeight: gameFieldHeight,
            gameFieldWidth: gameFieldWidth,
          )) {
        _current = next;
      }
    }
    notifyListeners();
  }

  void right() {
    if (_states == GameStates.none && _level < levelMax) {
      _level++;
    } else if (_states == GameStates.running) {
      final Tetromino? next = _current?.right();
      if (next != null &&
          next.isValidInMatrix(
            _data,
            gameFieldHeight: gameFieldHeight,
            gameFieldWidth: gameFieldWidth,
          )) {
        _current = next;
      }
    }
    notifyListeners();
  }

  void left() {
    if (_states == GameStates.none && _level > levelMin) {
      _level--;
    } else if (_states == GameStates.running) {
      final Tetromino? next = _current?.left();
      if (next != null &&
          next.isValidInMatrix(
            _data,
            gameFieldHeight: gameFieldHeight,
            gameFieldWidth: gameFieldWidth,
          )) {
        _current = next;
      }
    }
    notifyListeners();
  }

  Future<void> drop() async {
    if (_states == GameStates.running) {
      for (int i = 0; i < gameFieldHeight; i++) {
        final Tetromino? fall = _current?.fall(step: i + 1);
        if (fall != null &&
            !fall.isValidInMatrix(
              _data,
              gameFieldHeight: gameFieldHeight,
              gameFieldWidth: gameFieldWidth,
            )) {
          _current = _current?.fall(step: i);
          _states = GameStates.drop;
          notifyListeners();
          await Future<void>.delayed(const Duration(milliseconds: 100));
          await _mixCurrentIntoData();
          break;
        }
      }
      notifyListeners();
    } else if (_states == GameStates.none || _states == GameStates.paused) {
      _initializeNextTetromino();
      _startGame();
    }
  }

  void down() {
    if (_states == GameStates.running) {
      final Tetromino? next = _current?.fall();
      if (next != null &&
          next.isValidInMatrix(
            _data,
            gameFieldHeight: gameFieldHeight,
            gameFieldWidth: gameFieldWidth,
          )) {
        _current = next;
      } else {
        _mixCurrentIntoData();
      }
    }
    notifyListeners();
  }

  Timer? _autoFallTimer;

  ///mix current into [_data]
  Future<void> _mixCurrentIntoData() async {
    if (_current == null) {
      return;
    }
    _autoFall(false);

    _forTable((i, j) {
      final tetrominoValue = _current?.get(j, i);
      if (tetrominoValue == 1) {
        _data[i][j] = 1;
        _tetrominoTypes[i][j] = _current!.type;
        _tetrominoIdenticas[i][j] = _current!.identica;
      }
    });

    final List<int> clearLines = <int>[];
    for (int i = 0; i < gameFieldHeight; i++) {
      if (_data[i].every((d) => d == 1)) {
        clearLines.add(i);
      }
    }

    if (clearLines.isNotEmpty) {
      _states = GameStates.clear;
      notifyListeners();

      for (int count = 0; count < 5; count++) {
        for (final int line in clearLines) {
          _mask[line].fillRange(0, gameFieldWidth, count.isEven ? -1 : 1);
        }
        notifyListeners();
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      for (final int line in clearLines) {
        _mask[line].fillRange(0, gameFieldWidth, 0);
      }

      for (final int line in clearLines) {
        _data.setRange(1, line + 1, _data);
        _tetrominoTypes.setRange(1, line + 1, _tetrominoTypes);
        _tetrominoIdenticas.setRange(1, line + 1, _tetrominoIdenticas);
        _data[0] = List.filled(gameFieldWidth, 0);
        _tetrominoTypes[0] = List.filled(gameFieldWidth, null);
        _tetrominoIdenticas[0] = List.filled(gameFieldWidth, null);
      }

      _cleared += clearLines.length;
      _points += clearLines.length * _level * 5;

      final int level = (_cleared ~/ 50) + levelMin;
      _level = level <= levelMax && level > _level ? level : _level;
    } else {
      _states = GameStates.mixing;
      _forTable((i, j) => _mask[i][j] = _current?.get(j, i) ?? _mask[i][j]);
      notifyListeners();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      _forTable((i, j) => _mask[i][j] = 0);
      notifyListeners();
    }

    _current = null;

    if (_data[0].contains(1)) {
      reset();
      return;
    } else {
      _startGame();
    }
  }

  void _forTable(dynamic Function(int row, int column) callback) {
    for (int i = 0; i < gameFieldHeight; i++) {
      for (int j = 0; j < gameFieldWidth; j++) {
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
      // Берем следующий тетромино как текущий
      if (_current == null && _cachedNextTetromino != null) {
        _current = _cachedNextTetromino;
        // Генерируем новый следующий тетромино
        _cachedNextTetromino = Tetromino.getRandom();
      }
      _autoFallTimer = Timer.periodic(speed[_level - 1], (t) {
        down();
      });
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
      int line = gameFieldHeight;
      await Future.doWhile(() async {
        line--;
        for (int i = 0; i < gameFieldWidth; i++) {
          _data[line][i] = 1;
          _tetrominoTypes[line][i] =
              TetrominoShapes.values[line % TetrominoShapes.values.length];
          _tetrominoIdenticas[line][i] =
              Identica.allIdenticas[line % Identica.allIdenticas.length];
        }
        notifyListeners();
        await Future<void>.delayed(restLineDuration);
        return line != 0;
      });
      _current = null;
      _cachedNextTetromino = Tetromino.getRandom();
      _points = 0;
      _cleared = 0;
      await Future.doWhile(() async {
        for (int i = 0; i < gameFieldWidth; i++) {
          _data[line][i] = 0;
          _tetrominoTypes[line][i] = null;
          _tetrominoIdenticas[line][i] = null;
        }
        notifyListeners();
        line++;
        await Future<void>.delayed(restLineDuration);
        return line != gameFieldHeight;
      });
      _states = GameStates.none;
      _initializeNextTetromino(); // Инициализируем следующий тетромино после сброса
      notifyListeners();
    }();
  }

  void _startGame() {
    if (_states == GameStates.running && _autoFallTimer?.isActive == false) {
      return;
    }
    _states = GameStates.running;
    _initializeNextTetromino(); // Инициализируем следующий тетромино при первом запуске
    _autoFall(true);
    notifyListeners();
  }

  /// game field including falling tetromino
  /// * 0 - empty block
  /// * 1 - block from tetromino
  /// * 2 - block from falling tetromino
  List<List<int>> calculateMixed() {
    final List<List<int>> mixed = [];
    for (int i = 0; i < gameFieldHeight; i++) {
      mixed.add(List.filled(gameFieldWidth, 0));
      for (int j = 0; j < gameFieldWidth; j++) {
        int value = _current?.get(j, i) ?? _data[i][j];
        if (_mask[i][j] == -1) {
          value = 0;
        } else if (_mask[i][j] == 1) {
          value = 2;
        }
        mixed[i][j] = value;
      }
    }
    return mixed;
  }
}
