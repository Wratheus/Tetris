import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/feature/game/game_notifier.dart';
import 'package:tetris/feature/game/widgets/controllers/sensor_controller.dart';
import 'package:tetris/feature/game/widgets/grid.dart';
import 'package:tetris/feature/game/widgets/status_bar.dart';
import 'package:tetris/feature/game/widgets/toggle_pause_button.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    required this.gameController,
    super.key,
  });

  final GameNotifier gameController;

  double _getGridSizeMultiplier(MediaQueryData mediaQuery) {
    final isLandscape = mediaQuery.size.width > mediaQuery.size.height;
    final shortestSide = mediaQuery.size.shortestSide;

    // Определяем планшет по размеру экрана
    if (shortestSide >= 600) {
      // Планшеты: меньший размер для portrait, чтобы сетка вместилась
      return isLandscape ? 0.3 : 0.5;
    }

    // Телефоны: стандартные размеры
    return isLandscape ? 0.25 : 0.6;
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: gameController,
        builder: (context, child) => _ScreenShaker(
          shake: gameController.states == GameStates.drop,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final Size gridSize = Size.square(
                constraints.maxWidth *
                    _getGridSizeMultiplier(MediaQuery.of(context)) /
                    gameController.gameFieldWidth,
              );

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          GameGrid(
                            gameController: gameController,
                            size: gridSize,
                          ),
                          if (gameController.states == GameStates.none ||
                              gameController.states == GameStates.paused)
                            _PauseIndicationOverlay(
                              gameController: gameController,
                            ),
                        ],
                      ),
                      Column(
                        spacing: 20,
                        children: [
                          GameStatusBar(gameController: gameController),
                          TogglePauseButton(gameController: gameController),
                        ],
                      ),
                    ],
                  ),
                  // add controller if you do not have a keyboard.
                  if (Platform.isIOS || Platform.isAndroid)
                    SensorGameController(gameController: gameController),
                ],
              );
            },
          ),
        ),
      );
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
    )..addListener(() => setState(() {}));
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

class _PauseIndicationOverlay extends StatefulWidget {
  const _PauseIndicationOverlay({
    required this.gameController,
  });

  final GameNotifier gameController;

  @override
  State<_PauseIndicationOverlay> createState() =>
      _PauseIndicationOverlayState();
}

class _PauseIndicationOverlayState extends State<_PauseIndicationOverlay> {
  bool _hasBeenTapped = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (!_hasBeenTapped) {
            _hasBeenTapped = true;
            widget.gameController.drop();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF9800),
                Color(0xFFF57C00),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.pause_rounded,
            color: Colors.white,
            fill: 1,
            size: 40,
          ),
        ),
      );
}
