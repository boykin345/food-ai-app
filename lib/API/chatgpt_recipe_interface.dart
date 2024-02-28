/// An abstract class defining the interface for fetching recipe descriptions.
abstract class ChatGPTRecipeInterface {
  /// Fetches a recipe description.
  /// Returns a [Future] that resolves to a [String] containing the recipe description.
  Future<String> fetchRecipe();
}
