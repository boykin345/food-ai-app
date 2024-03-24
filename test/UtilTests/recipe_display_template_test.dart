import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/Entities/recipe.dart';
import 'package:food_ai_app/Entities/recipe_display_template.dart';

void main() {
  testWidgets('RecipeTemplate golden test', (WidgetTester tester) async {
    final testRecipe = Recipe(
      recipeName: "Test Recipe",
      imageURL: "https://example.com/test_image.jpg",
      category: "Test Category",
      calories: 100,
      prepTime: "10 mins",
      difficulty: 3,
      ingredients: ["Ingredient 1", "Ingredient 2"],
      instructions: "Test instructions.",
    );

    await tester.pumpWidget(MaterialApp(
      home: RecipeTemplate(recipe: testRecipe),
    ));

    await expectLater(
      find.byType(RecipeTemplate),
      matchesGoldenFile('golden_files/recipe_template.png'),
    );
  });
}
