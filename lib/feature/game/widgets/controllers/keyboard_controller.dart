import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/feature/game/game_notifier.dart';

///keyboard controller to play game
class KeyboardGameController extends StatelessWidget {
  const KeyboardGameController({
    required this.gameController,
    required this.child,
    super.key,
  });

  final GameNotifier gameController;

  final Widget child;

  bool _onKey(BuildContext context, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;

      if (key == LogicalKeyboardKey.arrowUp ||
          key == LogicalKeyboardKey.digit2 ||
          key == LogicalKeyboardKey.numpad2) {
        gameController.rotate();
      } else if (key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.digit8 ||
          key == LogicalKeyboardKey.numpad8) {
        gameController.down();
      } else if (key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.digit4 ||
          key == LogicalKeyboardKey.numpad4) {
        gameController.left();
      } else if (key == LogicalKeyboardKey.arrowRight ||
          key == LogicalKeyboardKey.digit6 ||
          key == LogicalKeyboardKey.numpad6) {
        gameController.right();
      } else if (key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.numpadEnter) {
        gameController.drop();
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
        focusNode: FocusNode(),
        onKeyEvent: (event) => _onKey(context, event),
        child: child,
      );
}
