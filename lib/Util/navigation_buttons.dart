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
            backgroundColor: Colours.backgroundOff,
          ),
          icon: Icon(Icons.arrow_back, color: Colours.primary),
          label: Text('Back',
              style: TextStyle(fontSize: 20, color: Colours.primary)),
        ),
        ElevatedButton.icon(
          onPressed: onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colours.backgroundOff,
          ),
          icon: Text('Continue',
              style: TextStyle(fontSize: 20, color: Colours.primary)),
          label: Icon(Icons.arrow_forward, color: Colours.primary),
        ),
      ],
    );
  }
}
