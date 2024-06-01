import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'arc_painter.dart';

class AnimatedSemiRing extends StatelessWidget {
  final Color color;
  final double radius;
  final double fillPercentage;
  final double strokeWidth;

  const AnimatedSemiRing(
      {super.key,
      required this.color,
      required this.radius,
      required this.fillPercentage,
      required this.strokeWidth});

  double get widgetSize => radius * 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widgetSize + strokeWidth,
      height: widgetSize + strokeWidth,
      child: Center(
        child: SizedBox(
          width: widgetSize,
          height: widgetSize,
          child: Stack(
            children: <Widget>[
              CustomPaint(
                painter: ArcPainter(
                  color: color.withOpacity(0.2),
                  radius: radius,
                  percentage: 75,
                  strokeWidth: strokeWidth,
                  startAngle: -(pi + 45 * pi / 180), // Pi + half of the cut angle
                ),
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.1, end: fillPercentage),
                duration: const Duration(milliseconds: 700),
                builder: (context, value, child) => CustomPaint(
                  painter: ArcPainter(
                    color: color,
                    radius: radius,
                    percentage: value * 75 / 100,
                    strokeWidth: strokeWidth,
                    startAngle: -(pi + 45 * pi / 180), // Pi + half of the cut angle
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
