
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/Entities/recipe_display_template.dart';
import 'package:food_ai_app/Util/colours.dart';
import 'package:food_ai_app/Util/initial_recipes.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

/// A3 Tests for the recipe template
void main() {
  testWidgets('RecipeTemplate checking all data', (WidgetTester tester) async {
    final RecipeInitialiser recipeInitialiser = RecipeInitialiser();
    await mockNetworkImages(() async => tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: RecipeTemplate(recipe: recipeInitialiser.chickenSalad)))));

    expect(find.text('Avocado Chicken Salad'), findsOneWidget);
    expect(find.text('Calories: 500'), findsOneWidget);
    expect(find.text('Prep Time: 15 minutes'), findsOneWidget);
    expect(find.text('Difficulty: 2/5'), findsOneWidget);
    expect(
        find.text(
            'In a large bowl, combine all the ingredients and gently stir until the avocado is slightly mashed and all the ingredients are well mixed. Season with salt and pepper to taste. Serve chilled.'),
        findsOneWidget);
    expect(find.text('Category: Lunch'), findsOneWidget);

    for (final String ingredient
        in recipeInitialiser.chickenSalad.ingredients) {
      final matcher = find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text &&
            widget.data!.startsWith('• $ingredient') &&
            widget.style!.fontSize == 18 &&
            widget.style!.color == Colours.backgroundOff,
      );

      expect(matcher, findsOneWidget,
          reason:
              "Ingredient '$ingredient' not found or not styled correctly.");
    }
  });
}
