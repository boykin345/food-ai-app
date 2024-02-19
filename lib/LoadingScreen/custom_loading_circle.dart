import 'package:flutter/material.dart';
import 'package:food_ai_app/LoadingScreen/tile_circle_painter.dart';

/// Displays a circular loading indicator with animated segments
class CustomLoadingCircle extends StatefulWidget {
  @override
  CustomLoadingCircleState createState() => CustomLoadingCircleState();
}

/// Manages the animation for [CustomLoadingCircle], using an [AnimationController]
/// to cycle segments through disappearing and reappearing phases.
class CustomLoadingCircleState extends State<CustomLoadingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final int _segments = 8;
  List<double> scales = [];

  /// Initializes the animation controller and the scales for each segment.
  @override
  void initState() {
    super.initState();

    /// Initializes the animation controller and the scales for each segment.
    controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          final double animationValue = controller.value * 2;
          final int phase = animationValue ~/
              1; // Determine phase: 0 for disappearing, 1 for reappearing
          final double phaseProgress =
              animationValue % 1; // Progress within the current phase
          final double segmentProgress = phaseProgress * _segments;

          if (phase == 0) {
            // Disappearing phase
            for (int i = 0; i < _segments; i++) {
              if (i < segmentProgress) {
                scales[i] =
                    1 - (segmentProgress - i); // Scale down to disappear
                if (scales[i] < 0)
                  scales[i] = 0; // Ensure scale does not go negative
              } else {
                scales[i] = 1; // Segment has not started disappearing
              }
            }
          } else {
            // Reappearing phase
            for (int i = 0; i < _segments; i++) {
              if (i < segmentProgress) {
                scales[i] = segmentProgress - i; // Scale up to reappear
                if (scales[i] > 1)
                  scales[i] = 1; // Ensure scale does not exceed 1
              } else {
                scales[i] = 0; // Segment has not started reappearing
              }
            }
          }
        });
      })
      ..repeat();
    scales = List.generate(
        _segments, (index) => 1.0); // Initialize with all segments visible
  }

  /// Disposes of the animation controller to free up resources.
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Builds the widget tree, rendering the animated circular indicator.
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: CustomPaint(
        painter: TileCirclePainter(scales),
      ),
    );
  }
}
