import 'package:flutter/material.dart';
import 'package:tetris/core/ui/identica.dart';
import 'package:tetris/feature/game/game_notifier.dart';
import 'package:tetris/feature/game/widgets/brick.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({
    required this.gameController,
    required this.size,
    super.key,
  });

  final GameNotifier gameController;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final currentTetromino = gameController.currentTetromino;

    return Column(
      children: List.generate(gameController.gameFieldHeight, (i) {
        final row = gameController.calculateMixed()[i];
        return Row(
          children: List.generate(row.length, (j) {
            final int value = row[j];

            if (value == 1 && currentTetromino != null) {
              final int? tetrominoValue = currentTetromino.get(j, i);
              if (tetrominoValue == 1) {
                return TetrominoBrick(
                  identica: currentTetromino.identica,
                  size: size,
                );
              }
            }

            if (value == 1) {
              final Identica? identica =
                  gameController.tetrominoIdenticas[i][j];
              if (identica != null) {
                return TetrominoBrick(
                  identica: identica,
                  size: size,
                );
              } else {
                return Brick.normal(size: size);
              }
            } else if (value == 2) {
              final Identica? identica =
                  gameController.tetrominoIdenticas[i][j];
              if (identica != null) {
                return TetrominoBrickHighlight(
                  identica: identica,
                  size: size,
                );
              } else {
                return Brick.highlight(size: size);
              }
            } else {
              return Brick.empty(size: size);
            }
          }),
        );
      }),
    );
  }
}
