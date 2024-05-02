import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/MenuPages/menu_settings.dart';

void main() {
  testWidgets('Settings Screen UI Test', (WidgetTester tester) async {
    // Build the SettingsScreen widget
    await tester.pumpWidget(MaterialApp(home: SettingsScreen()));

    // Expect to find text widgets for Difficulty, Cooking Time, and Portion Size
    expect(find.text('Difficulty'), findsOneWidget);
    expect(find.text('Cooking Time'), findsOneWidget);
    expect(find.text('Portion Size'), findsOneWidget);

    // Tap on the 'Add a new Dietary need' text field
    await tester.tap(find.byType(TextField));
    await tester.pump();

    // Expect to find the 'Add' icon button
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Enter text into the 'Add a new Dietary need' text field and tap the 'Add' button
    await tester.enterText(find.byType(TextField), 'Peanuts');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Expect to find 'Peanuts' added to the list of allergies
    expect(find.text('Peanuts'), findsOneWidget);

    // Tap on the 'Peanuts' allergy to remove it
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    // Expect 'Peanuts' to be removed from the list of allergies
    expect(find.text('Peanuts'), findsNothing);
  });
}
