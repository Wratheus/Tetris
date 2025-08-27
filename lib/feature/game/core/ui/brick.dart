import 'package:flutter/material.dart';

class BrickSizeProvider extends InheritedWidget {
  const BrickSizeProvider({
    required this.size,
    required super.child,
    super.key,
  });

  final Size size;

  static BrickSizeProvider of(BuildContext context) {
    final brickSize =
        context.dependOnInheritedWidgetOfExactType<BrickSizeProvider>();
    return brickSize!;
  }

  @override
  bool updateShouldNotify(BrickSizeProvider oldWidget) =>
      oldWidget.size != size;
}

///the basic brick for game panel
class Brick extends StatelessWidget {
  const Brick._({required this.color, super.key});

  const Brick.normal({Key? key}) : this._(color: Colors.black87, key: key);

  const Brick.empty({Key? key}) : this._(color: Colors.black12, key: key);

  const Brick.highlight({Key? key})
      : this._(color: const Color(0xFF560000), key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    final width = BrickSizeProvider.of(context).size.width;
    return SizedBox.fromSize(
      size: BrickSizeProvider.of(context).size,
      child: Container(
        margin: EdgeInsets.all(0.05 * width),
        padding: EdgeInsets.all(0.1 * width),
        decoration: BoxDecoration(
          border: Border.all(width: 0.10 * width, color: color),
        ),
        child: ColoredBox(
          color: color,
        ),
      ),
    );
  }
}
