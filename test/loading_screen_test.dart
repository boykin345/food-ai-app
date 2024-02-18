import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:food_ai_app/LoadingScreen/custom_loading_circle.dart';
import 'package:food_ai_app/LoadingScreen/tile_circle_painter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Loading Screen Golden Tests', () {
    testWidgets('CustomLoadingCircle renders initial state correctly',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MaterialApp(home: Scaffold(body: CustomLoadingCircle())));
      await expectLater(find.byType(CustomLoadingCircle),
          matchesGoldenFile('golden_tests/initial_state.png'));
    });

    testWidgets('Circle Painter renders correctly with full scales',
        (WidgetTester tester) async {
      final painter = TileCirclePainter(List.filled(8, 1.0));
      await tester
          .pumpWidget(CustomPaint(painter: painter, size: Size(200, 200)));

      await expectLater(
          find.byType(CustomPaint),
          matchesGoldenFile(
              'golden_tests/tile_circle_painter_full_scales.png'));
    });

    testWidgets('Circle Painter renders correctly with varying scales',
        (WidgetTester tester) async {
      final painter = TileCirclePainter([1.0, 0.8, 0.6, 0.4, 0.2, 0, 0.2, 0.4]);
      await tester
          .pumpWidget(CustomPaint(painter: painter, size: Size(200, 200)));

      await expectLater(
          find.byType(CustomPaint),
          matchesGoldenFile(
              'golden_tests/tile_circle_painter_varying_scales.png'));
    });
  });
}
