import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/Entities/recipe.dart';
import 'package:food_ai_app/Entities/recipe_display_template.dart';

void main() {
  group('RecipeTemplate Widget Tests', () {
    testWidgets('Displays correct recipe name', (WidgetTester tester) async {
      final sampleRecipe = Recipe(
        recipeName: 'Test Recipe',
        calories: 100,
        prepTime: '20 mins',
        difficulty: 2,
        ingredients: ['Ingredient 1', 'Ingredient 2'],
        instructions: 'Mix ingredients',
        category: 'Test Category',
        imageURL: 'http://example.com/image.jpg',
      );

      await tester.pumpWidget(MaterialApp(
        home: RecipeTemplate(recipe: sampleRecipe),
      ));

      // Verify the recipe name is displayed
      expect(find.text('Test Recipe'), findsOneWidget);
    });
  });
}
