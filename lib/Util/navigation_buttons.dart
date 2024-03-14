import 'package:flutter/material.dart';

import 'package:food_ai_app/Util/colours.dart';

class NavigationButtons extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const NavigationButtons({
    super.key,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton.icon(
          onPressed: onBack,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colours.primary,
          ),
          icon: Icon(Icons.arrow_back, color: Colors.white),
          label: Text('Back', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton.icon(
          onPressed: onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colours.primary,
          ),
          icon: Icon(Icons.arrow_forward, color: Colors.white),
          label: Text('Continue', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
