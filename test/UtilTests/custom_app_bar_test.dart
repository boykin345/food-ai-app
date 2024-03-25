import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/Util/custom_app_bar.dart';
import 'package:food_ai_app/Util/colours.dart';

/// N2 Tests for the app bar and accounts icon
void main() {
  group('CustomAppBar Tests', () {
    testWidgets('CustomAppBar renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(),
        ),
      ));

      // Verify the AppBar's background color
      expect(find.byType(AppBar), findsOneWidget);
      final AppBar appBar = tester.widget(find.byType(AppBar));
      expect(appBar.backgroundColor, Colours.primary);

      // Check for the presence of the IconButton with account_circle icon
      expect(find.widgetWithIcon(IconButton, Icons.account_circle),
          findsOneWidget);
    });
  });
}
