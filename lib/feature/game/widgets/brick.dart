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
          margin: EdgeInsets.all(size.width * 0.05),
          decoration: BoxDecoration(
            color: identica.iconBackgroundColor,
            borderRadius: BorderRadius.circular(size.width * 0.3),
            boxShadow: [
              BoxShadow(
                color: identica.iconBackgroundColor.withValues(alpha: 0.4),
                blurRadius: size.width * 0.2,
                spreadRadius: size.width * 0.05,
                offset: Offset(0, size.width * 0.05),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              identica.icon,
              color: identica.iconColor,
              size: size.width * 0.6,
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
              margin: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: identica.iconBackgroundColor,
                borderRadius: BorderRadius.circular(size.width * 0.3),
                boxShadow: [
                  BoxShadow(
                    color: identica.iconBackgroundColor.withValues(alpha: 0.4),
                    blurRadius: size.width * 0.2,
                    spreadRadius: size.width * 0.05,
                    offset: Offset(0, size.width * 0.05),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  identica.icon,
                  color: identica.iconColor,
                  size: size.width * 0.6,
                  fill: identica.fill,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * 0.3),
                border: Border.all(
                  width: size.width * 0.1,
                  color: Colors.red.withValues(alpha: 0.6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: size.width * 0.15,
                    spreadRadius: size.width * 0.05,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
