import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        child: Column(
          children: [
            TextField(
              key: ValueKey('usernameField'),
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              key: ValueKey('emailField'),
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              key: ValueKey('passwordField'),
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            TextField(
              key: ValueKey('confirmPasswordField'),
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}