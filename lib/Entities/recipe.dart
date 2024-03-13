class Recipe {
  String recipeName;
  int calories;
  String prepTime;
  int difficulty;
  List<String> ingredients;
  String instructions;
  // Category should be one of the following: Breakfast, Main, Desserts, Side-Dishes, Lunch
  String category;

  Recipe({
    required this.recipeName,
    required this.calories,
    required this.prepTime,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
    required this.category,
  });
}