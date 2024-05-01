import 'package:flutter/material.dart';
import 'package:food_ai_app/Entities/recipe.dart';
import 'package:food_ai_app/Util/colours.dart';
import 'package:food_ai_app/Util/custom_app_bar.dart';

/// A template widget that displays the data for favourited recipes or home screen recipes.
/// It works by injecting a [Recipe] object in it then rendering each part.
class RecipeTemplate extends StatelessWidget {
  /// The object containing recipe data.
  final Recipe recipe;

  /// Constructs a [RecipeTemplate] with required [recipe] object.
  RecipeTemplate({required this.recipe});

  /// Builds and returns the main content of the Recipe, including the recipe image, title, categories, calories, prep time, difficult, ingredients and instructions.
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth * 0.8;
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
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0, left: 15.0),
            ),
          ],
        ),
      ),
    );
  }
}
