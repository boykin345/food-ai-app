import 'package:flutter/material.dart';
import 'dart:math' as math;

class TileCirclePainter extends CustomPainter {
  final List<double> scales;
  TileCirclePainter(this.scales);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;
    final segmentCount = scales.length;
    final segmentArc = 2 * math.pi / segmentCount;
    final radius = size.width / 2;

    for (int i = 0; i < segmentCount; i++) {
      final startAngle = segmentArc * i;
      final scale = scales[i];
      paint.color =
          HSVColor.fromAHSV(1.0, (360 / segmentCount) * i, 1.0, 1.0).toColor();

      // Transform the canvas for scaling effect
      canvas.save();
      canvas.translate(size.width / 2, size.height / 2);
      canvas.scale(scale); // Apply scale to each segment
      canvas.translate(-size.width / 2, -size.height / 2);

      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        segmentArc * 0.8,
        false,
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
