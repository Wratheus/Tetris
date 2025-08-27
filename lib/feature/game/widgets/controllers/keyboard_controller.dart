import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/feature/game/widgets/controllers/game_controller.dart';

///keyboard controller to play game
class KeyboardGameController extends StatefulWidget {
  const KeyboardGameController({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<KeyboardGameController> createState() => _KeyboardGameControllerState();
}

class _KeyboardGameControllerState extends State<KeyboardGameController> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      final game = GameController.of(context);

      if (key == LogicalKeyboardKey.arrowUp) {
        game.rotate();
      } else if (key == LogicalKeyboardKey.arrowDown) {
        game.down();
      } else if (key == LogicalKeyboardKey.arrowLeft) {
        game.left();
      } else if (key == LogicalKeyboardKey.arrowRight) {
        game.right();
      } else if (key == LogicalKeyboardKey.space) {
        game.drop();
      } else {
        return false;
      }
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
