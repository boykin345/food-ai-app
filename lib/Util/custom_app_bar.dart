import 'package:flutter/material.dart';

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
            // Add functionality here
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
