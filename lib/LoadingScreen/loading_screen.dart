import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomLoadingCircle extends StatefulWidget {
  @override
  _CustomLoadingCircleState createState() => _CustomLoadingCircleState();
}

class _CustomLoadingCircleState extends State<CustomLoadingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _segments = 12;
  final List<double> _scales = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          final double segmentStep = 1 / _segments;
          final double currentStep = _controller.value * _segments;
          for (int i = 0; i < _segments; i++) {
            final double segmentPosition = currentStep - i;
            if (segmentPosition >= 0 && segmentPosition <= 1) {
              _scales[i] = 0.5 + (1 - (segmentPosition - 0.5).abs()) * 0.5;
            } else {
              _scales[i] = 0.5;
            }
          }
        });
      })
      ..repeat();
    _scales.addAll(List.generate(_segments, (index) => 0.5));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: CustomPaint(
        painter: TileCirclePainter(_scales),
      ),
    );
  }
}

class TileCirclePainter extends CustomPainter {
  final List<double> scales;
  TileCirclePainter(this.scales);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    final segmentCount = scales.length;
    final segmentArc = 2 * math.pi / segmentCount;
    final radius = size.width;

    for (int i = 0; i < segmentCount; i++) {
      final startAngle = segmentArc * i;
      final scale = scales[i];
      paint.color =
          HSVColor.fromAHSV(1.0, (360 / segmentCount) * i, 1.0, 1.0).toColor();

      // Transform the canvas
      canvas.save();
      // Move the canvas to the center of the circle
      canvas.translate(size.width / 2, size.height / 2);
      // Scale the segment individually
      canvas.scale(scale);
      // Move the canvas back
      canvas.translate(-size.width / 2, -size.height / 2);

      // Draw the segment
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        segmentArc * 0.8, // Adjust the multiplier to set the segment length
        false,
        paint,
      );

      // Restore the canvas to prevent scaling other segments
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
