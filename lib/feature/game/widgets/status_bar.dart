import 'package:flutter/material.dart';
import 'package:tetris/feature/game/domain/tetromino.dart';
import 'package:tetris/feature/game/game_notifier.dart';

class GameStatusBar extends StatelessWidget {
  const GameStatusBar({
    required this.gameController,
    super.key,
  });

  final GameNotifier gameController;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1B1B1C),
              const Color(0xFF1B1B1C).withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          spacing: 20,
          children: <Widget>[
            _StatusItem(
              label: 'Points',
              value: gameController.points,
              icon: Icons.stars,
              color: Colors.amber,
            ),
            _StatusItem(
              label: 'Cleans',
              value: gameController.cleared,
              icon: Icons.cleaning_services,
              color: Colors.green,
            ),
            _StatusItem(
              label: 'Level',
              value: gameController.level,
              icon: Icons.trending_up,
              color: Colors.blue,
            ),
            if (gameController.cachedNextTetromino != null)
              SizedBox(
                width: 120,
                height: 120,
                child: Column(
                  spacing: 12,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.next_plan,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    _NextTetromino(
                      nextTetromino: gameController.cachedNextTetromino!,
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
        spacing: 6,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          _Number(number: value, color: color),
        ],
      );
}

/// Виджет для отображения следующего тетромино
class _NextTetromino extends StatelessWidget {
  const _NextTetromino({
    required this.nextTetromino,
  });

  final Tetromino nextTetromino;

  @override
  Widget build(BuildContext context) {
    // Создаем мини-сетку для отображения тетромино
    final List<List<int>> shape = nextTetromino.type.shape;
    final int rows = shape.length;
    final int cols = shape[0].length;

    // Размер для мини-блоков (меньше чем основные блоки игры)
    const double blockSize = 14;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            nextTetromino.identica.iconBackgroundColor.withValues(alpha: 0.1),
            nextTetromino.identica.iconBackgroundColor.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color:
              nextTetromino.identica.iconBackgroundColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: nextTetromino.identica.iconBackgroundColor
                .withValues(alpha: 0.2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Иконка идентики сверху
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: nextTetromino.identica.iconBackgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              nextTetromino.identica.icon,
              color: nextTetromino.identica.iconColor,
              size: 16,
              fill: nextTetromino.identica.fill,
            ),
          ),
          const SizedBox(height: 8),
          // Мини-сетка тетромино
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              rows,
              (i) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(cols, (j) {
                  final bool hasBlock = shape[i][j] == 1;
                  return SizedBox(
                    width: blockSize,
                    height: blockSize,
                    child: Container(
                      margin: const EdgeInsets.all(0.5),
                      decoration: BoxDecoration(
                        color: hasBlock
                            ? nextTetromino.identica.iconBackgroundColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                        border: hasBlock
                            ? Border.all(
                                color: nextTetromino
                                    .identica.iconBackgroundColor
                                    .withValues(alpha: 0.8),
                              )
                            : null,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Number extends StatelessWidget {
  const _Number({
    required this.number,
    this.color,
  });

  ///the number to show
  ///could be null
  final int number;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    const int length = 5;

    String digitalStr = number.toString();
    if (digitalStr.length > length) {
      digitalStr = digitalStr.substring(digitalStr.length - length);
    }
    digitalStr = digitalStr.padLeft(length);
    final List<Widget> children = [];
    for (int i = 0; i < length; i++) {
      children.add(_Digital(int.tryParse(digitalStr[i]) ?? 0, color: color));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// a single digital
class _Digital extends StatelessWidget {
  const _Digital(this.digital, {this.color});

  final int digital;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        width: 12,
        height: 20,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              (color ?? const Color(0xFF2F2F32)).withValues(alpha: 0.9),
              color ?? const Color(0xFF2F2F32),
            ],
          ),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: (color ?? Colors.white).withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            digital.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
