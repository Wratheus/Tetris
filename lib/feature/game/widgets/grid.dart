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
        color: Colors.black.withValues(alpha: 0.3),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Простой фоновый цвет
            Positioned.fill(
              child: Container(
                color: Colors.blue.withValues(alpha: 0.02),
              ),
            ),
            // Улучшенная сетка
            Positioned.fill(
              child: CustomPaint(
                painter: _GridBackgroundPainter(
                  rows: gameController.gameFieldHeight,
                  cols: gameController.gameFieldWidth,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
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
    required this.rows,
    required this.cols,
  });

  final int rows;
  final int cols;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;

    // Рисуем вертикальные линии
    for (int i = 1; i < cols; i++) {
      final x = cellWidth * i;

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Рисуем горизонтальные линии
    for (int i = 1; i < rows; i++) {
      final y = cellHeight * i;

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Добавляем тонкие угловые линии для стиля
    final cornerPaint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.15)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Верхний левый угол
    canvas..drawLine(
      Offset.zero,
      Offset(cellWidth * 0.4, 0),
      cornerPaint,
    )
    ..drawLine(
      Offset.zero,
      Offset(0, cellHeight * 0.4),
      cornerPaint,
    )

    // Верхний правый угол
    ..drawLine(
      Offset(size.width, 0),
      Offset(size.width - cellWidth * 0.4, 0),
      cornerPaint,
    )
    ..drawLine(
      Offset(size.width, 0),
      Offset(size.width, cellHeight * 0.4),
      cornerPaint,
    )

    // Нижний левый угол
    ..drawLine(
      Offset(0, size.height),
      Offset(cellWidth * 0.4, size.height),
      cornerPaint,
    )
    ..drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cellHeight * 0.4),
      cornerPaint,
    )

    // Нижний правый угол
    ..drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cellWidth * 0.4, size.height),
      cornerPaint,
    )
    ..drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cellHeight * 0.4),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
