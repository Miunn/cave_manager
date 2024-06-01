import 'dart:math';

import 'package:flutter/cupertino.dart';

class ArcPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double percentage;
  final double strokeWidth;
  final double startAngle;

  ArcPainter({ required this.color, required this.radius, required this.percentage, required this.strokeWidth, this.startAngle = -pi / 2 });

  @override
  void paint(Canvas canvas, Size size) {
    // Define the rect inside which the ring should be painted
    final rect = Rect.fromCircle(center: Offset(radius, radius), radius: radius);

    // Calculate the radian from the given percentage value to identify the arcs endpoint
    final double degree = (percentage * 360) / 100;
    final double radian = (degree / 180) * pi;

    // Define the painter with its stylings
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, radian, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}