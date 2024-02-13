import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/main.dart';

void main() {

  testWidgets('Minimum Length Validation Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap on the signup button to navigate to the signup page
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    // Find the username TextField on the signup page
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    final passwordTextField = find.byKey(Key('passwordTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField
    await tester.enterText(usernameTextField, 'us');

    await tester.tap(passwordTextField);
    await tester.pumpAndSettle();

    // Verify that the username error message is displayed
    expect(find.text('Minimum length is 3 characters.'), findsOneWidget);

    // Rebuild the widget after interaction
    //await tester.pump();

    // Trigger interaction with the username TextField again
    //await tester.enterText(usernameTextField, 'username');

    // Find the password TextField on the signup page
    //final passwordTextField = find.byKey(Key('passwordTextField'));
    //expect(passwordTextField, findsOneWidget);

    // Trigger interaction with the password TextField
    //await tester.enterText(passwordTextField, 'pass');

    // Verify that the password error message is displayed
    //expect(find.text('Minimum length is 6 characters.'), findsOneWidget);

    // Trigger interaction with the password TextField again
    //await tester.enterText(passwordTextField, 'password');

    // Rebuild the widget after interaction
    //await tester.pump();

    // Verify that the username error message is not displayed
    //expect(find.text('Minimum length is 3 characters.'), findsNothing);

    // Verify that the password error message is not displayed
    //expect(find.text('Minimum length is 6 characters.'), findsNothing);
  });
}
