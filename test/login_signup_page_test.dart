import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/Pages/login_signup_page.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:food_ai_app/Util/data_util.dart';

void main() {

  testWidgets('Test to check the user can switch between the login and sign up pages', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Confirm the user is on the sign up page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    final emailTextField = find.byKey(Key('emailTextField'));
    expect(emailTextField, findsOneWidget);

    final passwordTextField = find.byKey(Key('passwordTextField'));
    expect(passwordTextField, findsOneWidget);

    final confirmPasswordTextField = find.byKey(Key('confirmPasswordTextField'));
    expect(confirmPasswordTextField, findsOneWidget);

    // Clicks on the login button to switch page.
    final loginButton = find.byKey(Key('loginButton'));
    await tester.tap(loginButton);
    await tester.pump();

    // Confirm the user is on the login page.
    expect(usernameTextField, findsNothing);
    expect(emailTextField, findsOneWidget);
    expect(passwordTextField, findsOneWidget);
    expect(confirmPasswordTextField, findsNothing);
  });
  testWidgets('Test to check the password text field visibility on the login page displays correctly', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: false))));

    // Confirm the user is on the sign up page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(emailTextField, findsOneWidget);

    // Verify the visibility is obscured already.
    final passwordTextField = find.byKey(Key('passwordTextField'));
    expect(tester.widget<TextField>(passwordTextField).obscureText, true);

    // Find the password visibility button.
    final passwordVisibilityButton = find.byKey(Key('passwordVisibleButton'));
    expect(passwordVisibilityButton, findsOneWidget);

    // Tap on the visibility button.
    await tester.tap(passwordVisibilityButton);
    await tester.pump();

    // Verify the text is no longer obscured.
    expect(tester.widget<TextField>(passwordTextField).obscureText, false);
  });
  testWidgets('Test to check the password text field visibility on the sign up page displays correctly', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Confirm the user is on the sign up page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Verify the visibility is obscured already.
    final passwordTextField = find.byKey(Key('passwordTextField'));
    final confirmPasswordTextField = find.byKey(Key('confirmPasswordTextField'));

    expect(tester.widget<TextField>(passwordTextField).obscureText, true);
    expect(tester.widget<TextField>(confirmPasswordTextField).obscureText, true);

    // Find the password visibility buttons.
    final passwordVisibilityButton = find.byKey(Key('passwordVisibleButton'));
    final confirmPasswordVisibilityButton = find.byKey(Key('confirmPasswordVisibleButton'));

    expect(passwordVisibilityButton, findsOneWidget);
    expect(confirmPasswordVisibilityButton, findsOneWidget);

    // Tap on the visibility button.
    await tester.tap(passwordVisibilityButton);
    await tester.tap(confirmPasswordVisibilityButton);
    await tester.pump();

    // Verify the text is no longer obscured.
    expect(tester.widget<TextField>(passwordTextField).obscureText, false);
    expect(tester.widget<TextField>(confirmPasswordTextField).obscureText, false);
  });
  testWidgets('Test the hint text within the confirm password text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Confirm the user is on the sign up page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Find the confirm password text field.
    final confirmPasswordTextField = find.byKey(Key('confirmPasswordTextField'));
    expect(confirmPasswordTextField, findsOneWidget);

    // Verify the text field contains confirm password.
    expect(find.descendant(of: confirmPasswordTextField, matching: find.text('Confirm password')), findsOneWidget);
  });

  // Username test case.
  testWidgets('Test to check when the user doesnt enter any data into the username text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Username field is empty!'), findsOneWidget);
  });
  testWidgets('Test to check when the user enters less than the minimal amount of characters allowed in the username text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'te');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Minimum length is 3 characters!'), findsOneWidget);
  });
  testWidgets('Test to check when the user exceeds the maximum amount of characters required in the username text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'zzdfmpsdsyehbxnulzlqjhntbhqrukioo');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Maximum length is 32 characters!'), findsOneWidget);
  });
  testWidgets('Test to check when the user enters a valid username no errors are returned', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username1');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that no error massages are displayed.
    expect(find.text('Username field is empty!'), findsNothing);
    expect(find.text('Minimum length is 3 characters!'), findsNothing);
    expect(find.text('Maximum length is 32 characters!'), findsNothing);
  });

  // Email address test cases.
  testWidgets('Test to check when the user doesnt enter any data into the email text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Email address field is empty!'), findsOneWidget);
  });
  testWidgets('Test to check when the user exceeds the maximum amount of characters allowed in the email text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the email TextField.
    await tester.enterText(emailTextField, 'j7itP8flc3WzZEqbocvd28ODNtudNTwSIijHsv1xarScW38xsOVJjf8QmAJUVV9D3Fn3mqYcJGcuowsTT62JPjzmnkCyoYYsesbpON1dPxno9gwq6kJtgmCRU8LwlvNLn0tIDSOdbIkk59ntVi3uO5TDlqSsmr45WhUfZWjTUubU0rS0HHo1VLziTh6iwkdfX9e3n8eYXMvaPnzptJy0IMv3ZovRKQ9KbFeWI26fH2uZMlfoo4c91Bbkivx5vm33');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Maximum length is 255 characters!'), findsOneWidget);
  });
  testWidgets('Test to check if the user doesnt enter a valid email address in the email text field e.g. missing @', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the email TextField.
    await tester.enterText(emailTextField, 'useremail.com');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Not a valid email address!'), findsOneWidget);
  });
  testWidgets('Test to check when the user enters a valid email address no errors are returned', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the email TextField.
    await tester.enterText(emailTextField, 'user@gmail.com');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that no error massages are displayed.
    expect(find.text('Email address field is empty!'), findsNothing);
    expect(find.text('Maximum length is 255 characters!'), findsNothing);
    expect(find.text('Not a valid email address!'), findsNothing);
  });

  // Password test cases.
  testWidgets('Test to check when the user doesnt enter any data into the password text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the email TextField.
    await tester.enterText(emailTextField, 'user@gmail.com');

    // Find the password TextField on the signup page.
    final passwordTextField = find.byKey(Key('passwordTextField'));
    expect(passwordTextField, findsOneWidget);

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Password field is empty!'), findsOneWidget);
  });
  testWidgets('Test to check when the user enters less than the minimal of characters required in the password text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the email TextField.
    await tester.enterText(emailTextField, 'user@gmail.com');

    // Find the password TextField on the signup page.
    final passwordTextField = find.byKey(Key('passwordTextField'));
    expect(passwordTextField, findsOneWidget);

    // Trigger interaction with the password TextField.
    await tester.enterText(passwordTextField, 'pass');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Minimum length is 8 characters!'), findsOneWidget);
  });
  testWidgets('Test to check when the user exceeds the maximum amount of characters allowed in the password text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the email TextField.
    await tester.enterText(emailTextField, 'user@gmail.com');

    // Find the password TextField on the signup page.
    final passwordTextField = find.byKey(Key('passwordTextField'));
    expect(passwordTextField, findsOneWidget);

    // Trigger interaction with the password TextField.
    await tester.enterText(passwordTextField, 'KZwxVyNAwaba7GMd6oFVdnqVTfUWQf3ll');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Maximum length is 32 characters!'), findsOneWidget);
  });
  testWidgets('Test to check when the user enters a valid password no errors are returned', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the email TextField.
    await tester.enterText(emailTextField, 'user@gmail.com');

    // Find the password TextField on the signup page.
    final passwordTextField = find.byKey(Key('passwordTextField'));
    expect(passwordTextField, findsOneWidget);

    // Trigger interaction with the password TextField.
    await tester.enterText(passwordTextField, 'password1');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that no error massages are displayed.
    expect(find.text('Password field is empty!'), findsNothing);
    expect(find.text('Minimum length is 8 characters!'), findsNothing);
    expect(find.text('Maximum length is 32 characters!'), findsNothing);
  });

  // Confirm password test cases.
  testWidgets('Test to check when the user doesnt enter any data into the confirm password text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the email TextField.
    await tester.enterText(emailTextField, 'user@gmail.com');

    // Find the password TextField on the signup page.
    final passwordTextField = find.byKey(Key('passwordTextField'));
    expect(passwordTextField, findsOneWidget);

    // Trigger interaction with the password TextField.
    await tester.enterText(passwordTextField, 'password1');

    // Find the confirm password TextField on the signup page.
    final confirmPasswordTextField = find.byKey(Key('confirmPasswordTextField'));
    expect(confirmPasswordTextField, findsOneWidget);

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Confirm password field is empty!'), findsOneWidget);
  });
  testWidgets('Test to check when the user enters less than the minimal of characters required in the confirm password text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the email TextField.
    await tester.enterText(emailTextField, 'user@gmail.com');

    // Find the password TextField on the signup page.
    final passwordTextField = find.byKey(Key('passwordTextField'));
    expect(passwordTextField, findsOneWidget);

    // Trigger interaction with the password TextField.
    await tester.enterText(passwordTextField, 'password1');

    // Find the confirm password TextField on the signup page.
    final confirmPasswordTextField = find.byKey(Key('confirmPasswordTextField'));
    expect(confirmPasswordTextField, findsOneWidget);

    await tester.enterText(confirmPasswordTextField, 'pass');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Minimum length is 8 characters!'), findsOneWidget);
  });
  testWidgets('Test to check when the user exceeds the maximum amount of characters allowed in the confirm password text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the email TextField.
    await tester.enterText(emailTextField, 'user@gmail.com');

    // Find the password TextField on the signup page.
    final passwordTextField = find.byKey(Key('passwordTextField'));
    expect(passwordTextField, findsOneWidget);

    // Trigger interaction with the password TextField.
    await tester.enterText(passwordTextField, 'password1');

    // Find the confirm password TextField on the signup page.
    final confirmPasswordTextField = find.byKey(Key('confirmPasswordTextField'));
    expect(confirmPasswordTextField, findsOneWidget);

    // Trigger interaction with the password TextField.
    await tester.enterText(confirmPasswordTextField, 'KZwxVyNAwaba7GMd6oFVdnqVTfUWQf3ll');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Maximum length is 32 characters!'), findsOneWidget);
  });
  testWidgets('Test to check when the password text field doesnt match the confirm password text field', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find the username TextField on the signup page.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the username TextField.
    await tester.enterText(usernameTextField, 'username');

    // Find the email TextField on the signup page.
    final emailTextField = find.byKey(Key('emailTextField'));
    expect(usernameTextField, findsOneWidget);

    // Trigger interaction with the email TextField.
    await tester.enterText(emailTextField, 'user@gmail.com');

    // Find the password TextField on the signup page.
    final passwordTextField = find.byKey(Key('passwordTextField'));
    expect(passwordTextField, findsOneWidget);

    // Trigger interaction with the password TextField.
    await tester.enterText(passwordTextField, 'password1');

    // Find the confirm password TextField on the signup page.
    final confirmPasswordTextField = find.byKey(Key('confirmPasswordTextField'));
    expect(confirmPasswordTextField, findsOneWidget);

    // Trigger interaction with the password TextField.
    await tester.enterText(confirmPasswordTextField, 'password2');

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the error message is displayed.
    expect(find.text('Passwords do not match!'), findsOneWidget);
  });

  // TODO fix this test cases + others
  testWidgets('Test to check when the user enters in all correct and is allowed to sign up', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginSignupPage(screenType: true))));

    // Find all the text fields and fill them all with correct data.
    final usernameTextField = find.byKey(Key('usernameTextField'));
    await tester.enterText(usernameTextField, 'username');

    final emailTextField = find.byKey(Key('emailTextField'));
    await tester.enterText(emailTextField, 'hello@gmail.com');

    final passwordTextField = find.byKey(Key('passwordTextField'));
    await tester.enterText(passwordTextField, 'password1');

    final confirmPasswordTextField = find.byKey(Key('confirmPasswordTextField'));
    await tester.enterText(confirmPasswordTextField, 'password1');

    final firestore = FakeFirebaseFirestore();
    await firestore.collection('users').add({
      'email': 'hello@gmail.com'
    });

    // Clicks on the submit button.
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the user is signed up.
    //AuthUtil.signUp('user@gmail.com', 'password1');

    //AuthUtil.signUp('user@gmail.com', 'password1');

    //auth.createUserWithEmailAndPassword(email: 'user@gmail.com', password: 'password1');
    //auth.signInWithEmailAndPassword(email: 'user@gmail.com', password: 'password1');



    //final user = MockUser(isAnonymous: false, uid: 'someid', email: 'user@gmail.com');
    //final auth = MockFirebaseAuth(mockUser: user);


    //final result = await auth.createUserWithEmailAndPassword(email: 'user@gmail.com', password: 'password1');
    //print(result);


    //expect(find.text('Confirm password field is empty!'), findsNothing);
  });
}