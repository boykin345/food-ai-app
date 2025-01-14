import 'package:food_ai_app/Util/map_to_recipe_converter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/Entities/recipe.dart';

/// A4 Tests for the map to recipe function
void main() {
  group('mapToRecipe', () {
    test('Correctly converts a complete map to a Recipe object', () {
      final testMap = {
        'recipeName': 'Test Recipe',
        'calories': '100',
        'prepTime': '30 min',
        'difficulty': '2',
        'ingredients': ['Ingredient 1', 'Ingredient 2'],
        'instructions': 'Test instructions.',
        'category': 'Test category',
        'imageURL': 'http://example.com/image.jpg',
      };

      final result = MapToRecipeConverter.mapToRecipe(testMap);

      expect(result, isA<Recipe>());
      expect(result.recipeName, 'Test Recipe');
    });
  });
}
