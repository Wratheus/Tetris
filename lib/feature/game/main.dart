import 'package:flutter/material.dart';
import 'package:tetris/feature/game/widgets/controllers/game_controller.dart';
import 'package:tetris/feature/game/widgets/controllers/keyboard_controller.dart';
import 'package:tetris/feature/game/widgets/controllers/sensor_controller.dart';
import 'package:tetris/feature/game/widgets/screen.dart';

class GameMain extends StatelessWidget {
  const GameMain({super.key});

  @override
  Widget build(BuildContext context) => GameController(
        child: KeyboardGameController(
          child: LayoutBuilder(
            builder: (context, constraints) => SizedBox.expand(
              child: ColoredBox(
                color: Colors.green,
                child: Padding(
                  padding: MediaQuery.of(context).padding,
                  child: Column(
                    children: <Widget>[
                      GameScreen(width: constraints.maxWidth * 0.95),
                      // add controller if you do not have a keyboard.
                      const SensorGameController(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
