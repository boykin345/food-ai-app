import 'package:flutter/material.dart';
import 'package:food_ai_app/Entities/recipe.dart';

class RecipeTemplate extends StatelessWidget {
  final Recipe recipe;

  RecipeTemplate({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.recipeName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Name: ${recipe.recipeName}"),
            Image.network(recipe.imageURL),
            Text("Category: ${recipe.category}"),
            Text("Calories: ${recipe.calories}"),
            Text("Prep Time: ${recipe.prepTime}"),
            Text("Difficulty: ${recipe.difficulty}"),
            Text("Instructions: ${recipe.instructions}"),
          ],
        ),
      ),
    );
  }
}
