/// Represents a culinary recipe with specified characteristics.
class Recipe {
  /// The name of the recipe.
  String recipeName;

  /// The amount of calories in the recipe.
  int calories;

  /// The preparation time required for the recipe.
  String prepTime;

  /// The difficulty level of preparing the recipe, rated as an integer.
  int difficulty;

  /// The list of ingredients required for the recipe.
  List<String> ingredients;

  /// Detailed cooking instructions for the recipe.
  String instructions;

  /// The category of the recipe, which should be one of the following: Breakfast, Main, Desserts, Side-Dishes, Lunch.
  String category;

  /// A URL pointing to an image of the finished dish.
  String imageURL;

  /// Creates a new Recipe instance with the provided values for each field.
  Recipe({
    required this.recipeName,
    required this.calories,
    required this.prepTime,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.imageURL,
  });

  /// Sorts and returns recipes by the specified category.
  ///
  /// Accepts a list of recipes (as maps) and a specific category string. Returns a list
  /// of recipes that match the given category.
  ///
  /// [recipes] - List of recipes to sort.
  /// [category] - Category to filter the recipes by.
  ///
  /// Returns a list of maps, where each map represents a recipe that matches the specified category.
  static List<Map<String, dynamic>> sortCategory(
      List<Map<String, dynamic>> recipes, String category) {
    final List<Map<String, dynamic>> sortedRecipes = [];

    for (final recipe in recipes) {
      if (recipe['category'] == category) {
        sortedRecipes.add(recipe);
      }
    }

    return sortedRecipes;
  }
}
