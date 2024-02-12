class TinderModel {
  final int THREAD_COUNT = 3;

  List<String> _imageUrls = ["", "", ""]; // Stores URLs of images
  List<String> _recipeDescriptions = [
    "",
    "",
    ""
  ]; // Stores descriptions of recipes
  int _index = 0;

  void addRecipe(String description, String imageUrl) {
    if (description.isEmpty || imageUrl.isEmpty)
      throw FormatException("Empty values");
    _recipeDescriptions[_index] = description;
    _imageUrls[_index] = imageUrl;
    incrementIndex();
  }

  String getRecipeDescription() {
    return _recipeDescriptions[_index];
  }

  String getRecipeImage() {
    return _imageUrls[_index];
  }

  int getIndex() {
    return _index;
  }

  void resetIndex() {
    _index = 0;
  }

  void incrementIndex() {
    _index++;
  }
}
