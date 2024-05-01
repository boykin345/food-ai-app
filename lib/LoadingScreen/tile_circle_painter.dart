import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A custom painter that draws a circle divided into multiple segments
/// with variable scales to create a dynamic, animated effect.
class TileCirclePainter extends CustomPainter {
  final List<double> scales;

  /// Constructs a [TileCirclePainter] with given scales for each segment.
  TileCirclePainter(this.scales);

  /// Paints the circle with segments on the given [canvas] using the [size] parameter.
  /// Each segment's color and scale are determined by [scales].
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

  /// Returns true to indicate that the painter should repaint whenever it is requested.
}
