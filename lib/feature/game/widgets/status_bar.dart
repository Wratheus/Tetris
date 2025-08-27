import 'package:flutter/material.dart';
import 'package:tetris/feature/game/core/ui/kit.dart';
import 'package:tetris/feature/game/widgets/controllers/game_controller.dart';

class GameStatusBar extends StatelessWidget {
  const GameStatusBar({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                const Text(
                  'points',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Number(number: GameControllerState.of(context).points),
              ],
            ),
            Column(
              children: [
                const Text(
                  'cleans',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Number(number: GameControllerState.of(context).cleared),
              ],
            ),
            Column(
              children: [
                const Text(
                  'level',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Number(number: GameControllerState.of(context).level),
              ],
            ),
          ],
        ),
      );
}
