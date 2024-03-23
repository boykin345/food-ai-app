import 'package:flutter/material.dart';
import 'package:food_ai_app/SettingsPage/health_goals.dart';

import 'colours.dart';

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
