import 'package:food_ai_app/Entities/recipe.dart';

import 'package:food_ai_app/Util/data_util.dart';

class MapToRecipeConverter {
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

  static Future<List<Recipe>> getRecipesAsObjects(String userId) async {
    List<Map<String, dynamic>> recipeMaps =
        await DataUtil.getUserRecipes(userId);
    List<Recipe> recipes = recipeMaps.map((map) => mapToRecipe(map)).toList();
    return recipes;
  }
}
