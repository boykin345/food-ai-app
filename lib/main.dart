import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_ai_app/LoginPages/index_page.dart';
import 'package:food_ai_app/LoginPages/home_page.dart';
import 'package:food_ai_app/Util/colours.dart';
import 'package:food_ai_app/Util/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Caviar Dreams',
            ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            size: 50,
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
      home: Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomePage();
              } else {
                return IndexPage();
              }
            }),
      ),
    );
  }
}
