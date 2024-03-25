import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/Util/initial_recipes.dart';

/// M2 Tests for the recipe initialisation class
void main() {
  group('RecipeInitialiser Tests', () {
    final RecipeInitialiser initialiser = RecipeInitialiser();

    test('frenchToast recipe is initialized correctly', () {
      expect(initialiser.frenchToast.recipeName, "Classic French Toast");
      expect(initialiser.frenchToast.calories, 350);
      expect(initialiser.frenchToast.prepTime, "20 minutes");
      expect(initialiser.frenchToast.difficulty, 2);
      expect(initialiser.frenchToast.ingredients.length, 7);
      expect(initialiser.frenchToast.instructions.isNotEmpty, true);
      expect(initialiser.frenchToast.category, "Breakfast");
      expect(initialiser.frenchToast.imageURL, isNotNull);
    });

    test('pestoChicken recipe is initialized correctly', () {
      expect(
          initialiser.pestoChicken.recipeName, "Grilled Chicken Pesto Pasta");
      expect(initialiser.pestoChicken.calories, 650);
      expect(initialiser.pestoChicken.prepTime, "45 minutes");
      expect(initialiser.pestoChicken.difficulty, 3);
      expect(initialiser.pestoChicken.ingredients.length, 6);
      expect(initialiser.pestoChicken.instructions.isNotEmpty, true);
      expect(initialiser.pestoChicken.category, "Main");
      expect(initialiser.pestoChicken.imageURL, isNotNull);
    });

    test('lavaCake recipe is initialized correctly', () {
      expect(initialiser.lavaCake.recipeName, "Chocolate Lava Cake");
      expect(initialiser.lavaCake.calories, 450);
      expect(initialiser.lavaCake.prepTime, "30 minutes");
      expect(initialiser.lavaCake.difficulty, 4);
      expect(initialiser.lavaCake.ingredients.length, 6);
      expect(initialiser.lavaCake.instructions.isNotEmpty, true);
      expect(initialiser.lavaCake.category, "Desserts");
      expect(initialiser.lavaCake.imageURL, isNotNull);
    });

    test('roastedBroccoli recipe is initialized correctly', () {
      expect(initialiser.roastedBroccoli.recipeName,
          "Garlic Parmesan Roasted Broccoli");
      expect(initialiser.roastedBroccoli.calories, 200);
      expect(initialiser.roastedBroccoli.prepTime, "25 minutes");
      expect(initialiser.roastedBroccoli.difficulty, 2);
      expect(initialiser.roastedBroccoli.ingredients.length, 5);
      expect(initialiser.roastedBroccoli.instructions.isNotEmpty, true);
      expect(initialiser.roastedBroccoli.category, "Side-Dishes");
      expect(initialiser.roastedBroccoli.imageURL, isNotNull);
    });

    test('chickenSalad recipe is initialized correctly', () {
      expect(initialiser.chickenSalad.recipeName, "Avocado Chicken Salad");
      expect(initialiser.chickenSalad.calories, 500);
      expect(initialiser.chickenSalad.prepTime, "15 minutes");
      expect(initialiser.chickenSalad.difficulty, 2);
      expect(initialiser.chickenSalad.ingredients.length, 6);
      expect(initialiser.chickenSalad.instructions.isNotEmpty, true);
      expect(initialiser.chickenSalad.category, "Lunch");
      expect(initialiser.chickenSalad.imageURL, isNotNull);
    });
  });
}
