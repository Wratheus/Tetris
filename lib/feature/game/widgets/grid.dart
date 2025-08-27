import 'package:flutter/material.dart';
import 'package:tetris/feature/game/core/ui/brick.dart';
import 'package:tetris/feature/game/core/ui/kit.dart';
import 'package:tetris/feature/game/widgets/controllers/game_controller.dart';

const playerPanelPadding = 6;

Size getBrikSizeForScreenWidth(double width) =>
    Size.square((width - playerPanelPadding) / gamePadMatrixW);

///the matrix of player content
class GameGrid extends StatelessWidget {
  GameGrid({
    required double width,
    super.key,
  }) : size = Size(width, width * 2);
  //the size of player panel
  final Size size;

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
        size: size,
        child: Stack(
          children: <Widget>[
            _PlayerPad(),
            if (GameControllerState.of(context).states == GameStates.none)
              const Center(child: WelcomeBadge(animate: true)),
          ],
        ),
      );
}

class _PlayerPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        children: GameControllerState.of(context)
            .data
            .map(
              (list) => Row(
                children: list
                    .map(
                      (b) => b == 1
                          ? const Brick.normal()
                          : b == 2
                              ? const Brick.highlight()
                              : const Brick.empty(),
                    )
                    .toList(),
              ),
            )
            .toList(),
      );
}
