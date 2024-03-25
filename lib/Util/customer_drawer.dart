import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ai_app/LoginPages/home_page.dart';
import 'package:food_ai_app/LoginPages/index_page.dart';
import 'package:food_ai_app/MenuPages/menu_preferences.dart';
import 'package:food_ai_app/MenuPages/menu_settings.dart';
import 'package:food_ai_app/SettingsPage/health_goals.dart';
import 'package:food_ai_app/Util/colours.dart';

/// Defines a custom navigation [Drawer] for the app.
///
/// Displays the user's email at the top and provides navigation options to
/// various pages like Home, Preferences, Health Goals, and Settings. Also
/// allows the user to log out.
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
                  onTap: () => _navigateTo(context, PreferencesScreen()),
                ),
                _buildDrawerItem(
                  icon: Icons.flag,
                  text: 'Health Goals',
                  onTap: () => _navigateTo(context, HealthGoalScreen()),
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () => _navigateTo(context, SettingsScreen()),
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

  /// Builds a single item for the drawer menu.
  ///
  /// Each item is represented by an icon, a text label, and an associated action
  /// defined by the [onTap] callback.
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

  /// Navigates to the specified [page] when a drawer item is tapped.
  ///
  /// The method uses the [Navigator] to push a new route to the stack,
  /// navigating to the [page] widget.
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
