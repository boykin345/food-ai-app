import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


/// This is a place holder page until the home page is created!
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('sign in as: ${user.email!}')),
        ],
      ),
    );
  }
}