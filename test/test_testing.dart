import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/main.dart'; // Import your main.dart file

void main() {
  testWidgets('MyApp builds', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp());

    // Verify that MaterialApp contains a title widget with the text 'Demo'
    expect(find.text('Demo'), findsOneWidget);
  });

  testWidgets('MyHomePage builds', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

    // Verify that the AppBar contains a title widget with the text 'Main Page'
    expect(find.text('Main Page'), findsOneWidget);

    // Verify that the DrawerHeader contains a text widget with the text 'Hi George'
    expect(find.text('Hi George'), findsOneWidget);

    // Verify that the DrawerHeader contains a text widget with the text 'Welcome'
    expect(find.text('Welcome'), findsOneWidget);

    // Verify that there are two ListTile widgets
    expect(find.byType(ListTile), findsNWidgets(2));

    // Verify that tapping on the first ListTile navigates to SettingsScreen
    await tester.tap(find.byType(TextButton).at(0));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    // Verify that tapping on the second ListTile navigates to AllergiesScreen
    await tester.tap(find.byType(TextButton).at(1));
    await tester.pumpAndSettle();
    expect(find.text('Allergies'), findsOneWidget);
  });
}
