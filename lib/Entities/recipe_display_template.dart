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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth * 0.9;
    final double imageHeight = imageWidth;

    return Scaffold(
      backgroundColor: Colours.primary,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 35.0, left: 15.0),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                height: imageHeight,
                width: imageWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(recipe.imageURL, fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0, left: 15.0),
              child: Text(
                recipe.recipeName,
                style: TextStyle(
                  fontSize: 30,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                "Category: ${recipe.category}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                "Calories: ${recipe.calories}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                "Prep Time: ${recipe.prepTime}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                "Difficulty: ${recipe.difficulty}/5",
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                "Ingredients:",
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
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
              padding: const EdgeInsets.only(top: 15.0, left: 15.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                "Instructions:",
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
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
