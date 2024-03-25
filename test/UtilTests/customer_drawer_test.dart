import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/Util/customer_drawer.dart';
import 'package:mockito/mockito.dart';

/// TO - DO
void main() {
  group('CustomDrawer Widget Tests', () {
    Widget makeTestableWidget({required Widget child}) {
      return MaterialApp(
        home: child,
      );
    }

    testWidgets('Drawer displays user email correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: CustomDrawer()));

      expect(find.text('Signed in as: example@example.com'), findsOneWidget);
    });
  });
}
