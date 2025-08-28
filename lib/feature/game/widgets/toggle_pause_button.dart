import 'package:flutter/material.dart';
import 'package:tetris/feature/game/game_notifier.dart';

/// Кнопка паузы/возобновления игры
class TogglePauseButton extends StatelessWidget {
  const TogglePauseButton({
    required this.gameController,
    super.key,
  });

  final GameNotifier gameController;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: gameController,
        builder: (context, child) => GestureDetector(
          onTap: gameController.togglePause,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gameController.states == GameStates.paused
                    ? [
                        const Color(0xFF4CAF50),
                        const Color(0xFF388E3C),
                      ]
                    : [
                        const Color(0xFFFF9800),
                        const Color(0xFFF57C00),
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (gameController.states == GameStates.paused
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFFF9800))
                      .withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  gameController.states == GameStates.paused
                      ? Icons.play_arrow
                      : Icons.pause,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  gameController.states == GameStates.paused
                      ? 'Resume'
                      : 'Pause',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
