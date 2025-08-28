import 'package:flutter/material.dart';

/// Компактная легенда для клавиатурного управления
class KeyboardLegend extends StatelessWidget {
  const KeyboardLegend({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
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
        child: const Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CompactLegendItem(
                  keyLabel: '↑',
                  description: 'Rotate',
                  color: Colors.blue,
                ),
                _CompactLegendItem(
                  keyLabel: '←→',
                  description: 'Move',
                  color: Colors.green,
                ),
                _CompactLegendItem(
                  keyLabel: '↓',
                  description: 'Down',
                  color: Colors.orange,
                ),
              ],
            ),
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CompactLegendItem(
                  keyLabel: 'Space',
                  description: 'Drop',
                  color: Colors.red,
                ),
                _CompactLegendItem(
                  keyLabel: 'P',
                  description: 'Pause',
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      );
}

/// Компактный элемент легенды
class _CompactLegendItem extends StatelessWidget {
  const _CompactLegendItem({
    required this.keyLabel,
    required this.description,
    required this.color,
  });

  final String keyLabel;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Клавиша
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: color.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                keyLabel,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Описание
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
}
