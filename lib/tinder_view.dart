import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:food_ai_app/tinder_model.dart';

class TinderView extends StatelessWidget {
  final TinderModel model;
  final VoidCallback onChangeRecipe;

  TinderView({Key? key, required this.model, required this.onChangeRecipe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Caviar Dreams',
          ),
    );

    return Scaffold(
      backgroundColor: Color(0xFF2D3444),
      appBar: AppBar(
        title: Text('Recipe Tinder', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2D3444),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (model.getRecipeImage().isNotEmpty)
              Image.memory(
                base64Decode(model.getRecipeImage()),
                fit: BoxFit.cover,
              )
            else
              Placeholder(fallbackHeight: 200, color: Color(0xFFF5F5F5)),
            Container(
              width: double.infinity,
              color: Color(0xFFFAF0F0),
              padding: EdgeInsets.all(16.0),
              child: Text(
                model.getRecipeDescription(),
                style: theme.textTheme.bodyText2
                    ?.copyWith(color: Color(0xFF2D3444)),
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // No Button
                  ElevatedButton(
                    onPressed: onChangeRecipe,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red, // Text color
                    ),
                    child: Text('No'),
                  ),
                  // Yes Button
                  ElevatedButton(
                    onPressed: () {
                      // Handle "Yes" action
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green, // Text color
                    ),
                    child: Text('Yes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
