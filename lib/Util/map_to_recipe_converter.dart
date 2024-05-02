import 'package:food_ai_app/Entities/recipe.dart';
import 'package:food_ai_app/Util/data_util.dart';

/// A utility class for converting map data to [Recipe] objects and fetching recipe objects.
class MapToRecipeConverter {
  /// Converts a map of recipe data into a [Recipe] object.
  /// - Parameters:
  ///   - [map]: A [Map<String, dynamic>] containing key-value pairs of recipe data.
  /// - Returns: A [Recipe] object populated with data from the input map.
  static Recipe mapToRecipe(Map<String, dynamic> map) {
    return Recipe(
      recipeName: map['recipeName'] as String,
      calories: int.tryParse(map['calories'].toString()) ?? 0,
      prepTime: map['prepTime'] as String,
      difficulty: int.tryParse(map['difficulty'].toString()) ?? 0,
      ingredients: List<String>.from(map['ingredients'] as List),
      instructions: map['instructions'] as String,
      category: map['category'] as String,
      imageURL: map['imageURL'] as String,
    );
  }

  /// Fetches and converts a list of recipes for a given user ID into [Recipe] objects.
  /// - Parameters:
  ///   - [userId]: A [String] representing the unique ID of the user for whom to fetch recipes.
  /// - Returns: A [Future] that resolves to a [List<Recipe>] containing all converted recipes.
  static Future<List<Recipe>> getRecipesAsObjects(String userId) async {
    final List<Map<String, dynamic>> recipeMaps =
        await DataUtil.getUserRecipes(userId);
    final List<Recipe> recipes = recipeMaps.map((map) => mapToRecipe(map)).toList();
    return recipes;
  }
}
