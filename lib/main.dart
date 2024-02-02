import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_ai_app/Util/firebase_options.dart';

import 'package:food_ai_app/Controllers/sign_up.dart';

import 'Util/data_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  AuthUtil authUtil = AuthUtil();
  DataUtil dataUtil = DataUtil();

  String email = 'user@example.com';
  String password = 'password123';
  String username = 'john_doe';

  // Sign up the user
  User? user = await authUtil.signUp(email, password);

  // If the user is signed up successfully, add user data to Firestore
  if (user != null) {
    dataUtil.addUserData(user.uid, username, email);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Index Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // Change made here: Convert 'key' to a super parameter for linter
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D3444),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Text('Food AI',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.white
                    ),
                  ),
              Padding(padding: const EdgeInsets.only(left: 150),
                child: Text('Lets find the',
                  style: TextStyle(
                    color: Color(0xFFC4CCD8),
                    fontSize: 28,
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.only(left: 170),
                child: Text('Food you love',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 200),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add the desired functionality when the button is pressed
                    print('Switching to login page!');
                  },
                  child: Text('Log In', style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                  // Add the desired functionality when the button is pressed
                  print('Switching to sign up page!');
                },
                child: Text('Sign Up', style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  print('Switching to help page!');
                },
                child: Text('Help', style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}