class Recipe {
  String recipeName;
  int calories;
  String prepTime;
  int difficulty;
  List<String> ingredients;
  String instructions;

  Recipe({
    required this.recipeName,
    required this.calories,
    required this.prepTime,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
  });
}