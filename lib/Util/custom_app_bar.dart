import 'package:flutter/material.dart';
import 'package:food_ai_app/SettingsPage/health_goals.dart';

import 'package:food_ai_app/Util/colours.dart';

/// A custom [AppBar] widget for the app.
///
/// Features an action button that navigates to the [HealthGoalScreen] when tapped.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colours.primary,
      actions: [
        IconButton(
          icon: Icon(Icons.account_circle),
          iconSize: 50,
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HealthGoalScreen()),
            );
            // Add functionality here
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
