import 'package:flutter/material.dart';
import 'package:tetris/core/ui/identica.dart';

///the basic brick for game panel
class Brick extends StatelessWidget {
  const Brick._({required this.color, required this.size, super.key});

  const Brick.normal({required Size size, Key? key})
      : this._(
          color: Colors.white,
          size: size,
          key: key,
        );

  const Brick.empty({required Size size, Key? key})
      : this._(
          color: const Color(0xFF1B1B1C),
          size: size,
          key: key,
        );

  const Brick.highlight({required Size size, Key? key})
      : this._(color: Colors.red, size: size, key: key);

  final Color color;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final width = size.width;
    return SizedBox.fromSize(
      size: size,
      child: Container(
        margin: EdgeInsets.all(0.05 * width),
        padding: EdgeInsets.all(0.1 * width),
        decoration: BoxDecoration(
          border: Border.all(width: 0.10 * width, color: color),
        ),
        child: ColoredBox(color: color),
      ),
    );
  }
}

class TetrominoBrick extends StatelessWidget {
  const TetrominoBrick({
    required this.identica,
    required this.size,
    super.key,
  });

  final Identica identica;
  final Size size;

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
        size: size,
        child: Container(
          decoration: BoxDecoration(
            color: identica.iconBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          width: size.width,
          height: size.width,
          child: Center(
            child: Icon(
              identica.icon,
              color: identica.iconColor,
              size: 5,
              fill: identica.fill,
            ),
          ),
        ),
      );
}

class TetrominoBrickHighlight extends StatelessWidget {
  const TetrominoBrickHighlight({
    required this.identica,
    required this.size,
    super.key,
  });

  final Identica identica;
  final Size size;

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
        size: size,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: identica.iconBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              width: size.width,
              height: size.width,
              child: Center(
                child: Icon(
                  identica.icon,
                  color: identica.iconColor,
                  size: 5,
                  fill: identica.fill,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: size.width,
                  color: Colors.red.withValues(alpha: 0.2),
                ),
              ),
            ),
          ],
        ),
      );
}
