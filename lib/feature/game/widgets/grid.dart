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

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _GridBackgroundPainter(
                  color: Colors.white.withValues(alpha: 0.1),
                  rows: gameController.gameFieldHeight,
                  cols: gameController.gameFieldWidth,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridBackgroundPainter extends CustomPainter {
  _GridBackgroundPainter({
    required this.color,
    required this.rows,
    required this.cols,
  });

  final Color color;
  final int rows;
  final int cols;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    // Вертикальные линии
    for (int i = 1; i < cols; i++) {
      final x = (size.width / cols) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Горизонтальные линии
    for (int i = 1; i < rows; i++) {
      final y = (size.height / rows) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
