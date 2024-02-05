import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_ai_app/Util/firebase_options.dart';

import 'Screens/LogInSignUpScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      home: const MyHomePage(title: 'Food AI - Index Page'),
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
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              children: <Widget> [
                Text(
                  'Food AI',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: Colors.white
                  ),
                ),
                Text(
                  'Lets find the food you love',
                  style: TextStyle(
                    color: Color(0xFFC4CCD8),
                    fontSize: 28,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginSignupScreen(screenType: false)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(125, 30.0)
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginSignupScreen(screenType: true,)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(125, 30.0)
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, top: 30),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(125, 30.0)
                    ),
                    child: Text(
                      'Help',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}