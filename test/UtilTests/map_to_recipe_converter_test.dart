import 'package:food_ai_app/Util/map_to_recipe_converter.dart';
import 'package:test/test.dart';
import 'package:food_ai_app/Entities/recipe.dart';

void main() {
  group('mapToRecipe', () {
    test('Correctly converts a complete map to a Recipe object', () {
      var testMap = {
        'recipeName': 'Test Recipe',
        'calories': '100',
        'prepTime': '30 min',
        'difficulty': '2',
        'ingredients': ['Ingredient 1', 'Ingredient 2'],
        'instructions': 'Test instructions.',
        'category': 'Test category',
        'imageURL': 'http://example.com/image.jpg',
      };

      var result = MapToRecipeConverter.mapToRecipe(testMap);

      expect(result, isA<Recipe>());
      expect(result.recipeName, 'Test Recipe');
    });
  });
}
