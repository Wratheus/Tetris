import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/feature/game/game_notifier.dart';

///keyboard controller to play game
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

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool _onKey(BuildContext context, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;

      if (key == LogicalKeyboardKey.arrowUp ||
          key == LogicalKeyboardKey.digit2 ||
          key == LogicalKeyboardKey.numpad2) {
        widget.gameController.rotate();
      } else if (key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.digit8 ||
          key == LogicalKeyboardKey.numpad8) {
        widget.gameController.down();
      } else if (key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.digit4 ||
          key == LogicalKeyboardKey.numpad4) {
        widget.gameController.left();
      } else if (key == LogicalKeyboardKey.arrowRight ||
          key == LogicalKeyboardKey.digit6 ||
          key == LogicalKeyboardKey.numpad6) {
        widget.gameController.right();
      } else if (key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.numpadEnter) {
        widget.gameController.drop();
      } else {
        return false;
      }
      return true;
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
