import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/Pages/index_page.dart';

// L - Unit tests for the index page class.
void main() {
  testWidgets('Test to see when the application is open that it opens the index page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: IndexPage())));

    // Verify that we're on the index page.
    expect(find.text('Lets find the food you love'), findsOneWidget);
  });

  testWidgets('User clicks on the login button and is redirected to the login page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: IndexPage())));

    // Verify that we're on the index page.
    expect(find.text('Lets find the food you love'), findsOneWidget);

    // Tap the button to navigate to the login page.
    await tester.tap(find.byKey(ValueKey('loginButton')));
    await tester.pumpAndSettle();

    // Verify that we're on the login page.
    expect(find.byKey(ValueKey('emailTextField')), findsOneWidget);
    expect(find.byKey(ValueKey('passwordTextField')), findsOneWidget);
  });

  testWidgets('User clicks on the sign up button and is redirected to the sign up page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: IndexPage())));

    // Verify that we're on the index page.
    expect(find.text('Lets find the food you love'), findsOneWidget);

    // Tap the button to navigate to the sign up page.
    await tester.tap(find.byKey(ValueKey('signUpButton')));
    await tester.pumpAndSettle();

    // Verify that we're on the sign up page.
    expect(find.byKey(ValueKey('usernameTextField')), findsOneWidget);
    expect(find.byKey(ValueKey('emailTextField')), findsOneWidget);
    expect(find.byKey(ValueKey('passwordTextField')), findsOneWidget);
    expect(find.byKey(ValueKey('confirmPasswordTextField')), findsOneWidget);
  });
}