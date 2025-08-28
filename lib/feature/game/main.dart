import 'package:flutter/material.dart';
import 'package:tetris/feature/game/game_notifier.dart';
import 'package:tetris/feature/game/widgets/controllers/keyboard_controller.dart';
import 'package:tetris/feature/game/widgets/screen.dart';

class GameMain extends StatefulWidget {
  const GameMain({super.key});

  @override
  State<GameMain> createState() => _GameMainState();
}

class _GameMainState extends State<GameMain> {
  late final GameNotifier _gameController;

  @override
  void initState() {
    super.initState();
    _gameController = GameNotifier();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          minimum: const EdgeInsets.only(
            top: kToolbarHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: KeyboardGameController(
              gameController: _gameController,
              child: GameScreen(gameController: _gameController),
            ),
          ),
        ),
      );
}
