import 'package:flutter/material.dart';
import 'package:food_ai_app/Entities/recipe.dart';
import 'package:food_ai_app/LoginPages/home_page.dart';

import '../Util/colours.dart';
import '../Util/custom_app_bar.dart';
import '../Util/customer_drawer.dart';

class RecipeTemplate extends StatelessWidget {
  final Recipe recipe;

  RecipeTemplate({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                recipe.recipeName,
                style: TextStyle(
                  fontSize: 30,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Container(
              width: 410,
              height: 336,
              child: Image.network(recipe.imageURL),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                recipe.category,
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                recipe.calories.toString(),
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                recipe.prepTime,
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                recipe.difficulty.toString(),
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.ingredients
                    .map((ingredient) => Text(
                          "• $ingredient",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colours.backgroundOff,
                          ),
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                recipe.instructions,
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
