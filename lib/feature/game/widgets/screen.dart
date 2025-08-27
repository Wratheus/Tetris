import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/feature/game/core/ui/brick.dart';
import 'package:tetris/feature/game/widgets/controllers/game_controller.dart';
import 'package:tetris/feature/game/widgets/grid.dart';
import 'package:tetris/feature/game/widgets/status_bar.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    required this.width,
    super.key,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    final playerPanelWidth = width * 0.8;
    return _ScreenShaker(
      shake: GameControllerState.of(context).states == GameStates.drop,
      child: SizedBox(
        height: (playerPanelWidth - 6) * 2 + 6,
        width: width,
        child: ColoredBox(
          color: const Color(0xff9ead86),
          child: BrickSizeProvider(
            size: getBrikSizeForScreenWidth(playerPanelWidth),
            child: Row(
              children: <Widget>[
                GameGrid(width: playerPanelWidth),
                SizedBox(
                  width: width - playerPanelWidth,
                  child: const GameStatusBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScreenShaker extends StatefulWidget {
  const _ScreenShaker({
    required this.child,
    required this.shake,
  });
  final Widget child;

  final bool shake;

  @override
  State<_ScreenShaker> createState() => _ScreenShakerState();
}

class _ScreenShakerState extends State<_ScreenShaker>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void didUpdateWidget(_ScreenShaker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getOffset() {
    final double progress = _controller.value;
    return sin(progress * pi) * 1.5;
  }

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: Offset(0, _getOffset()),
        child: widget.child,
      );
}
