import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/feature/game/game_notifier.dart';

/// Адаптивный контроллер игры для устройств без клавиатуры.
/// Автоматически подстраивает размеры кнопок под тип устройства:
/// - Терминалы: стандартные размеры
/// - Планшеты: средние размеры с учетом ориентации
/// - Телефоны: увеличенные размеры для удобства
/// - Устройства с gesture navigation: еще большие размеры
class SensorGameController extends StatelessWidget {
  const SensorGameController({
    required this.gameController,
    super.key,
  });

  final GameNotifier gameController;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.size.width > mediaQuery.size.height;

    // Определяем тип устройства для адаптации размеров
    final deviceType = _getDeviceType(context, mediaQuery);

    // Адаптируем отступы в зависимости от типа устройства
    final topPadding = _getTopPadding(deviceType, mediaQuery);

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _Button(
                size: _getButtonSize(deviceType, mediaQuery, isLandscape),
                onTap: gameController.drop,
                icon: Icons.keyboard_arrow_down,
                color: Colors.red,
              ),
            ),
          ),
          Expanded(
            child: _DirectionButtons(
              gameController: gameController,
              deviceType: deviceType,
              mediaQuery: mediaQuery,
              isLandscape: isLandscape,
            ),
          ),
        ],
      ),
    );
  }

  /// Возвращает верхний отступ в зависимости от типа устройства
  double _getTopPadding(_DeviceType deviceType, MediaQueryData mediaQuery) {
    switch (deviceType) {
      case _DeviceType.terminal:
        return 20;
      case _DeviceType.tablet:
        return 20;
      case _DeviceType.phone:
        // На телефонах уменьшаем отступ для экономии места
        return 15;
    }
  }

  /// Определяет тип устройства для адаптации UI
  _DeviceType _getDeviceType(BuildContext context, MediaQueryData mediaQuery) {
    // Определяем планшет по размеру экрана
    final shortestSide = mediaQuery.size.shortestSide;
    if (shortestSide >= 600) {
      return _DeviceType.tablet;
    }

    // Определяем телефон по размеру экрана
    if (shortestSide < 600) {
      return _DeviceType.phone;
    }

    return _DeviceType.phone; // По умолчанию
  }

  /// Возвращает размер кнопки в зависимости от типа устройства
  Size _getButtonSize(
    _DeviceType deviceType,
    MediaQueryData mediaQuery,
    bool isLandscape,
  ) {
    final baseSize = mediaQuery.size.width;

    return switch (deviceType) {
      _DeviceType.terminal => Size.square(baseSize * 0.12),
      _DeviceType.tablet =>
        Size.square(isLandscape ? baseSize * 0.08 : baseSize * 0.1),
      _DeviceType.phone =>
        Size.square(isLandscape ? baseSize * 0.12 : baseSize * 0.18),
    };
  }
}

/// Типы устройств для адаптации UI
/// Используется для определения оптимальных размеров кнопок
enum _DeviceType {
  /// TSD терминал с встроенным сканером
  terminal,

  /// Планшет (экран >= 600dp по короткой стороне)
  tablet,

  /// Телефон (экран < 600dp по короткой стороне)
  phone,
}

class _DirectionButtons extends StatelessWidget {
  const _DirectionButtons({
    required this.gameController,
    required this.deviceType,
    required this.mediaQuery,
    required this.isLandscape,
  });

  final GameNotifier gameController;
  final _DeviceType deviceType;
  final MediaQueryData mediaQuery;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    final directionButtonSize = _getDirectionButtonSize();
    final double directionSpace = _getDirectionSpace();

    return Transform.rotate(
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
                size: directionButtonSize,
                onTap: gameController.rotate,
                icon: Icons.rotate_right,
                color: Colors.blue,
                iconRotation: -math.pi / 4,
              ),
              _Button(
                size: directionButtonSize,
                onTap: gameController.right,
                icon: Icons.keyboard_arrow_right,
                color: Colors.green,
                iconRotation: -math.pi / 4,
              ),
            ],
          ),
          Row(
            spacing: directionSpace,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _Button(
                size: directionButtonSize,
                onTap: gameController.left,
                icon: Icons.keyboard_arrow_left,
                color: Colors.orange,
                iconRotation: -math.pi / 4,
              ),
              _Button(
                size: directionButtonSize,
                onTap: gameController.down,
                icon: Icons.keyboard_arrow_down,
                color: Colors.purple,
                iconRotation: -math.pi / 4,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Возвращает размер кнопок направления в зависимости от типа устройства
  Size _getDirectionButtonSize() {
    final baseSize = mediaQuery.size.width;

    return switch (deviceType) {
      _DeviceType.terminal => Size.square(baseSize * 0.08),
      _DeviceType.tablet =>
        Size.square(isLandscape ? baseSize * 0.06 : baseSize * 0.08),
      _DeviceType.phone =>
        Size.square(isLandscape ? baseSize * 0.08 : baseSize * 0.15),
    };
  }

  /// Возвращает расстояние между кнопками в зависимости от типа устройства
  double _getDirectionSpace() {
    final baseSize = mediaQuery.size.width;

    return switch (deviceType) {
      _DeviceType.terminal => baseSize * 0.02,
      _DeviceType.tablet => baseSize * 0.015,
      _DeviceType.phone => baseSize * 0.025,
    };
  }
}

class _Button extends StatefulWidget {
  const _Button({
    required this.size,
    required this.onTap,
    this.icon,
    this.color,
    this.iconRotation = 0.0, // Добавляем параметр поворота иконки
  });

  final Size size;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;
  final double iconRotation; // Угол поворота иконки в радианах

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<_Button> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _elevationAnimation = Tween<double>(
      begin: 4,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (widget.color ?? Colors.white).withValues(alpha: 0.9),
                  (widget.color ?? Colors.white),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: (widget.color ?? Colors.white).withValues(alpha: 0.4),
                  blurRadius: _elevationAnimation.value * 2,
                  spreadRadius: _elevationAnimation.value * 0.5,
                  offset: Offset(0, _elevationAnimation.value * 0.5),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.size.width / 2),
                onTapDown: (_) {
                  _animationController.forward();
                  HapticFeedback.lightImpact();
                  widget.onTap();
                },
                onTapUp: (_) {
                  _animationController.reverse();
                },
                onTapCancel: () {
                  _animationController.reverse();
                },
                child: Container(
                  width: widget.size.width,
                  height: widget.size.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: widget.icon != null
                        ? Transform.rotate(
                            angle: widget.iconRotation,
                            child: Icon(
                              widget.icon,
                              color: Colors.white,
                              size: widget.size.width * 0.4,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
