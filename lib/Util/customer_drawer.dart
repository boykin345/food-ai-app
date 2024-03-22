import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_ai_app/LoginPages/index_page.dart';
import 'package:food_ai_app/SettingsPage/Settings.dart';
import 'package:food_ai_app/main.dart';
import 'package:food_ai_app/LoginPages/home_page.dart';
import 'package:food_ai_app/Util/colours.dart';

class CustomDrawer extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Signed in as: ${user?.email ?? 'Not signed in'}',
              style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Colours.primary,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildDrawerItem(
                  icon: Icons.home,
                  text: 'Home',
                  onTap: () => _navigateTo(context, HomePage()),
                ),
                _buildDrawerItem(
                  icon: Icons.favorite_border,
                  text: 'Preferences',
                  onTap: () => _navigateTo(context, HomePage()),
                ),
                _buildDrawerItem(
                  icon: Icons.flag,
                  text: 'Health Goals',
                  onTap: () => _navigateTo(context, HomePage()),
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () => _navigateTo(
                      context, SettingsScreen(ingredientsMapCons: {})),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Log Out',
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => IndexPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colours.primary),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colours.primary,
        ),
      ),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
