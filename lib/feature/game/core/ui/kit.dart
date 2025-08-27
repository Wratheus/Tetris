import 'dart:async';
import 'package:flutter/material.dart';

class Number extends StatelessWidget {
  const Number({
    required this.number,
    super.key,
    this.length = 5,
    this.padWithZero = false,
  });

  final int length;

  ///the number to show
  ///could be null
  final int number;
  final bool padWithZero;

  @override
  Widget build(BuildContext context) {
    String digitalStr = number.toString();
    if (digitalStr.length > length) {
      digitalStr = digitalStr.substring(digitalStr.length - length);
    }
    digitalStr = digitalStr.padLeft(length, padWithZero ? '0' : ' ');
    final List<Widget> children = [];
    for (int i = 0; i < length; i++) {
      children.add(Digital(int.tryParse(digitalStr[i]) ?? 0));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class WelcomeBadge extends StatefulWidget {
  const WelcomeBadge({
    super.key,
    this.animate = false,
  });

  final bool animate;

  @override
  State<WelcomeBadge> createState() => _WelcomeBadgeState();
}

class _WelcomeBadgeState extends State<WelcomeBadge> {
  Timer? _timer;
  bool _showFirstIcon = true;

  @override
  void didUpdateWidget(WelcomeBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initAnimation();
  }

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _timer?.cancel();
    _timer = null;
    if (!widget.animate) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 3), (t) {
      setState(() {
        _showFirstIcon = !_showFirstIcon;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        width: 80,
        height: 86,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _showFirstIcon
              ? Icons.flutter_dash_rounded
              : Icons.auto_awesome_rounded,
          color: Colors.white,
          size: 40,
        ),
      );
}

/// a single digital
class Digital extends StatelessWidget {
  const Digital(
    this.digital, {
    super.key,
    this.size = const Size(10, 17),
  });

  ///number 0 - 9
  ///or null indicate it is invalid
  final int digital;
  final Size size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size.width,
        height: size.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            child: Text(
              digital.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: size.height * 0.6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
}
