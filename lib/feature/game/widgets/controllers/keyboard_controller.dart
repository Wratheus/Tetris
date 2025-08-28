import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:tetris/feature/game/game_notifier.dart';

///keyboard controller to play game with key hold support
class KeyboardGameController extends StatefulWidget {
  const KeyboardGameController({
    required this.gameController,
    required this.child,
    super.key,
  });

  final GameNotifier gameController;

  final Widget child;

  @override
  State<KeyboardGameController> createState() => _KeyboardGameControllerState();
}

class _KeyboardGameControllerState extends State<KeyboardGameController> {
  final FocusNode _focusNode = FocusNode();
  
  // Таймеры для зажатия клавиш
  Timer? _leftTimer;
  Timer? _rightTimer;
  Timer? _downTimer;
  
  // Флаги для отслеживания зажатых клавиш
  bool _isLeftPressed = false;
  bool _isRightPressed = false;
  bool _isDownPressed = false;
  
  // Задержка перед началом повторения
  static const Duration _initialDelay = Duration(milliseconds: 200);
  // Интервал повторения
  static const Duration _repeatInterval = Duration(milliseconds: 100);

  @override
  void dispose() {
    _cancelAllTimers();
    _focusNode.dispose();
    super.dispose();
  }

  void _cancelAllTimers() {
    _leftTimer?.cancel();
    _rightTimer?.cancel();
    _downTimer?.cancel();
    _leftTimer = null;
    _rightTimer = null;
    _downTimer = null;
  }

  void _startLeftRepeat() {
    if (_isLeftPressed && _leftTimer == null) {
      _leftTimer = Timer.periodic(_repeatInterval, (timer) {
        if (_isLeftPressed) {
          widget.gameController.left();
        } else {
          timer.cancel();
          _leftTimer = null;
        }
      });
    }
  }

  void _startRightRepeat() {
    if (_isRightPressed && _rightTimer == null) {
      _rightTimer = Timer.periodic(_repeatInterval, (timer) {
        if (_isRightPressed) {
          widget.gameController.right();
        } else {
          timer.cancel();
          _rightTimer = null;
        }
      });
    }
  }

  void _startDownRepeat() {
    if (_isDownPressed && _downTimer == null) {
      _downTimer = Timer.periodic(_repeatInterval, (timer) {
        if (_isDownPressed) {
          widget.gameController.down();
        } else {
          timer.cancel();
          _downTimer = null;
        }
      });
    }
  }

  bool _onKey(BuildContext context, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;

      if (key == LogicalKeyboardKey.arrowUp ||
          key == LogicalKeyboardKey.digit2 ||
          key == LogicalKeyboardKey.numpad2) {
        widget.gameController.rotate();
        return true;
      } else if (key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.digit8 ||
          key == LogicalKeyboardKey.numpad8) {
        if (!_isDownPressed) {
          _isDownPressed = true;
          widget.gameController.down();
          // Запускаем повторение с задержкой
          Timer(_initialDelay, () {
            if (_isDownPressed) {
              _startDownRepeat();
            }
          });
        }
        return true;
      } else if (key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.digit4 ||
          key == LogicalKeyboardKey.numpad4) {
        if (!_isLeftPressed) {
          _isLeftPressed = true;
          widget.gameController.left();
          // Запускаем повторение с задержкой
          Timer(_initialDelay, () {
            if (_isLeftPressed) {
              _startLeftRepeat();
            }
          });
        }
        return true;
      } else if (key == LogicalKeyboardKey.arrowRight ||
          key == LogicalKeyboardKey.digit6 ||
          key == LogicalKeyboardKey.numpad6) {
        if (!_isRightPressed) {
          _isRightPressed = true;
          widget.gameController.right();
          // Запускаем повторение с задержкой
          Timer(_initialDelay, () {
            if (_isRightPressed) {
              _startRightRepeat();
            }
          });
        }
        return true;
      } else if (key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.numpadEnter) {
        widget.gameController.drop();
        return true;
      }
      return false;
    } else if (event is KeyUpEvent) {
      final key = event.logicalKey;
      
      // Обрабатываем отпускание клавиш
      if (key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.digit8 ||
          key == LogicalKeyboardKey.numpad8) {
        _isDownPressed = false;
        _downTimer?.cancel();
        _downTimer = null;
        return true;
      } else if (key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.digit4 ||
          key == LogicalKeyboardKey.numpad4) {
        _isLeftPressed = false;
        _leftTimer?.cancel();
        _leftTimer = null;
        return true;
      } else if (key == LogicalKeyboardKey.arrowRight ||
          key == LogicalKeyboardKey.digit6 ||
          key == LogicalKeyboardKey.numpad6) {
        _isRightPressed = false;
        _rightTimer?.cancel();
        _rightTimer = null;
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => KeyboardListener(
        autofocus: true,
        focusNode: _focusNode,
        onKeyEvent: (event) => _onKey(context, event),
        child: widget.child,
      );
}
