import 'package:flutter/material.dart';
import 'package:food_ai_app/LoadingScreen/tile_circle_painter.dart';

class CustomLoadingCircle extends StatefulWidget {
  @override
  _CustomLoadingCircleState createState() => _CustomLoadingCircleState();
}

class _CustomLoadingCircleState extends State<CustomLoadingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _segments = 8;
  List<double> _scales = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          final double animationValue = _controller.value * 2;
          final int phase = animationValue ~/
              1; // Determine phase: 0 for disappearing, 1 for reappearing
          final double phaseProgress =
              animationValue % 1; // Progress within the current phase
          final double segmentProgress = phaseProgress * _segments;

          if (phase == 0) {
            // Disappearing phase
            for (int i = 0; i < _segments; i++) {
              if (i < segmentProgress) {
                _scales[i] =
                    1 - (segmentProgress - i); // Scale down to disappear
                if (_scales[i] < 0)
                  _scales[i] = 0; // Ensure scale does not go negative
              } else {
                _scales[i] = 1; // Segment has not started disappearing
              }
            }
          } else {
            // Reappearing phase
            for (int i = 0; i < _segments; i++) {
              if (i < segmentProgress) {
                _scales[i] = segmentProgress - i; // Scale up to reappear
                if (_scales[i] > 1)
                  _scales[i] = 1; // Ensure scale does not exceed 1
              } else {
                _scales[i] = 0; // Segment has not started reappearing
              }
            }
          }
        });
      })
      ..repeat();
    _scales = List.generate(
        _segments, (index) => 1.0); // Initialize with all segments visible
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
