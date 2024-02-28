import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:food_ai_app/Allergies.dart';
import 'package:food_ai_app/HealthGoals.dart';
import 'package:food_ai_app/Preferences.dart';
import 'package:food_ai_app/Settings.dart';
import 'package:food_ai_app/TinderMVC/tinder_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('George Cook', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Tinder Selection'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TinderPage()),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Allergies'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllergiesScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Preferences'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PreferencesScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Health Goals'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HealthGoalScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('sign in as: ${user.email!}')),
    );
  }
}