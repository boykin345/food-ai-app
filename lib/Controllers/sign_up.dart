import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF0F0),
      body: Column(
        children: [
          SizedBox(height: 50),
          Text('Food AI',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 60,
                color: Colors.black
            ),
          ),
          SizedBox(height: 200),
          Center(
            child: Container(
              width: 300,
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 300,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: 300,
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: 300,
              child: TextField(
                controller: passwordCheckerController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String username = usernameController.text;
              String email = emailController.text;
              String password = passwordController.text;
              String passwordChecker = passwordCheckerController.text;
              print('Username: $username\n Email: $email\n Password: $password\n passwordChecker: $passwordChecker');
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(300, 40)),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
            ),
            child: Text('Sign Up', style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}