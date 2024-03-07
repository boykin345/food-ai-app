import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:food_ai_app/home_page.dart';

void main() {
  group('HomeScreen', () {
    test('parseContent returns correct map', () {
      final HomeScreenState homeScreenState = HomeScreenState();
      final String content = 'Apple: 1\nBanana: 2\nOrange: 3';
      final Map<String, String> expectedMap = {
        'Apple': '1',
        'Banana': '2',
        'Orange': '3',
      };
      expect(homeScreenState.parseContent(content), expectedMap);
    });
    testWidgets('HomeScreen should display properly', (WidgetTester tester) async {
      // Build the widget tree and trigger frame rendering
      await tester.pumpWidget(MaterialApp(home: HomeScreen(body)));
      // Verify that HomeScreen is rendered
      expect(find.text('Your'), findsOneWidget);
      expect(find.text('Favourites'), findsOneWidget);
    });
  });
}