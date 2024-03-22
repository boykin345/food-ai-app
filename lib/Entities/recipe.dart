class Recipe {
  String recipeName;
  int calories;
  String prepTime;
  int difficulty;
  List<String> ingredients;
  String instructions;
  // Category should be one of the following: Breakfast, Main, Desserts, Side-Dishes, Lunch
  String category;
  String imageURL;

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

  static List<Map<String, dynamic>> sortCategory(List<Map<String, dynamic>> recipes, String category) {
    List<Map<String, dynamic>> sortedRecipes = [];

    for (var recipe in recipes) {
      if (recipe['category'] == category) {
        sortedRecipes.add(recipe);
      }
    }

    return sortedRecipes;
  }
}