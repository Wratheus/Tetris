import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tetris/feature/game/widgets/controllers/game_controller.dart';

/// should be used if you do not have a keyboard.
class SensorGameController extends StatelessWidget {
  const SensorGameController({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _Button(
                  enableLongPress: false,
                  size: const Size(85, 85),
                  onTap: () => GameController.of(context).drop(),
                ),
              ),
            ),
            const Expanded(child: DirectionButtons()),
          ],
        ),
      );
}

const Size directionButtonSize = Size(48, 48);

const Size systemButtonSize = Size(28, 28);

const double directionSpace = 16;

class DirectionButtons extends StatelessWidget {
  const DirectionButtons({super.key});

  @override
  Widget build(BuildContext context) => Transform.rotate(
        angle: math.pi / 4,
        child: Column(
          spacing: directionSpace,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              spacing: directionSpace,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Button(
                  enableLongPress: false,
                  size: directionButtonSize,
                  onTap: () => GameController.of(context).rotate(),
                ),
                _Button(
                  size: directionButtonSize,
                  onTap: () => GameController.of(context).right(),
                ),
              ],
            ),
            Row(
              spacing: directionSpace,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Button(
                  size: directionButtonSize,
                  onTap: () => GameController.of(context).left(),
                ),
                _Button(
                  size: directionButtonSize,
                  onTap: () => GameController.of(context).down(),
                ),
              ],
            ),
          ],
        ),
      );
}

class _Button extends StatefulWidget {
  const _Button({
    required this.size,
    required this.onTap,
    this.enableLongPress = true,
  });
  final Size size;

  final VoidCallback onTap;

  final bool enableLongPress;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  Timer? _timer;

  bool _tapEnded = false;

  late Color _color;

  @override
  void didUpdateWidget(_Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    _color = Colors.blue;
  }

  @override
  void initState() {
    super.initState();
    _color = Colors.blue;
  }

  @override
  Widget build(BuildContext context) => Material(
        color: _color,
        elevation: 2,
        shape: const CircleBorder(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) async {
            if (_timer != null) {
              return;
            }
            _tapEnded = false;
            widget.onTap();
            if (!widget.enableLongPress) {
              return;
            }
            await Future<void>.delayed(const Duration(milliseconds: 300));
            if (_tapEnded) {
              return;
            }
            _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
              if (!_tapEnded) {
                widget.onTap();
              } else {
                t.cancel();
                _timer = null;
              }
            });
          },
          onTapCancel: () {
            _tapEnded = true;
            _timer?.cancel();
            _timer = null;
            setState(() {
              _color = _color;
            });
          },
          onTapUp: (_) {
            _tapEnded = true;
            _timer?.cancel();
            _timer = null;
            setState(() {
              _color = _color;
            });
          },
          child: SizedBox.fromSize(
            size: widget.size,
          ),
        ),
      );
}
