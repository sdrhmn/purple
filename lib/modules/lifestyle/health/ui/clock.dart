import 'dart:math';

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter({required this.dateTime});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw clock face
    canvas.drawCircle(center, radius, Paint()..color = Colors.black);

    // Draw ticks
    final tickPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90); // Subtract 90 degrees
      final radians = angle * (3.14 / 180);
      final tickLength = i % 3 == 0 ? 12.0 : 6.0; // Longer for hour ticks
      final tickStart = Offset(
        center.dx + (radius - tickLength) * cos(radians),
        center.dy + (radius - tickLength) * sin(radians),
      );
      final tickEnd = Offset(
        center.dx + radius * cos(radians),
        center.dy + radius * sin(radians),
      );
      canvas.drawLine(tickStart, tickEnd, tickPaint);
    }

    // Draw hour hand
    final hourAngle = (dateTime.hour % 12) * 30 - 90; // Subtract 90 degrees
    final hourHandLength = radius * 0.5;
    final hourHandPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;
    canvas.drawLine(
      center,
      Offset(center.dx + hourHandLength * cos(hourAngle * (3.14 / 180)),
          center.dy + hourHandLength * sin(hourAngle * (3.14 / 180))),
      hourHandPaint,
    );

    // Draw minute hand
    final minuteAngle = dateTime.minute * 6 - 90; // Subtract 90 degrees
    final minuteHandLength = radius * 0.75;
    final minuteHandPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawLine(
      center,
      Offset(center.dx + minuteHandLength * cos(minuteAngle * (3.14 / 180)),
          center.dy + minuteHandLength * sin(minuteAngle * (3.14 / 180))),
      minuteHandPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
