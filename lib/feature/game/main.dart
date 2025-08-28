import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tetris/feature/game/game_notifier.dart';
import 'package:tetris/feature/game/widgets/controllers/keyboard_controller.dart';
import 'package:tetris/feature/game/widgets/screen.dart';
import 'package:window_manager/window_manager.dart';

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

    // Устанавливаем фиксированный размер окна для десктопа
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _setFixedWindowSize();
    }
  }

  Future<void> _setFixedWindowSize() async {
    const Size minSize = Size(740, 800);
    try {
      await windowManager.ensureInitialized();

      await windowManager.setSize(minSize);

      await windowManager.setResizable(true);

      await windowManager.setMinimumSize(minSize);

      await windowManager.setMaximumSize(const Size(1110, 1200));

      // Центрируем окно
      await windowManager.center();

      // Устанавливаем заголовок окна
      await windowManager.setTitle('Tetris');
    } on Object catch (e) {
      debugPrint('Window manager not available: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          minimum: const EdgeInsets.only(
            top: kToolbarHeight,
          ),
          child: KeyboardGameController(
            gameController: _gameController,
            child: GameScreen(gameController: _gameController),
          ),
        ),
      );
}
