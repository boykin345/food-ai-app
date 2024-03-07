import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:food_ai_app/main.dart';

// Mock Firebase.initializeApp function
class MockFirebaseApp extends Mock implements FirebaseApp {}

void main() {
  group('MyApp', () {
    testWidgets('MyApp builds', (WidgetTester tester) async {
      // Mock Firebase.initializeApp
      final mockFirebaseApp = MockFirebaseApp();
      when(Firebase.initializeApp(
        options: anyNamed('options'),
      )).thenAnswer((_) async => mockFirebaseApp);

      // Run app
      await tester.pumpWidget(MyApp());

      // Verify that a MaterialApp is created
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('MyHomePage', () {
    testWidgets('MyHomePage builds', (WidgetTester tester) async {
      // Build MyHomePage
      await tester.pumpWidget(MaterialApp(home: MyHomePage()));

      // Verify that the title text widget is rendered
      expect(find.text('Main Page'), findsOneWidget);
    });

    testWidgets('Tapping Settings navigates to SettingsScreen',
        (WidgetTester tester) async {
      // Build MyHomePage
      await tester.pumpWidget(MaterialApp(home: MyHomePage()));

      // Tap the Settings button
      await tester.tap(find.text('Settings'));
      await tester.pump();

      // Verify that SettingsScreen is pushed
      expect(find.text('Settings Screen'), findsOneWidget);
    });

    testWidgets('Tapping Allergies navigates to AllergiesScreen',
        (WidgetTester tester) async {
      // Build MyHomePage
      await tester.pumpWidget(MaterialApp(home: MyHomePage()));

      // Tap the Allergies button
      await tester.tap(find.text('Allergies'));
      await tester.pump();

      // Verify that AllergiesScreen is pushed
      expect(find.text('Allergies Screen'), findsOneWidget);
    });
  });
}
