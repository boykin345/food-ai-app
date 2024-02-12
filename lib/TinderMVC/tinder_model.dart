import 'dart:collection';

class TinderModel {
  final Queue<String> _imageUrls = Queue<String>();
  final Queue<String> _recipeDescriptions = Queue<String>();

  void addRecipe(String description, String imageUrl) {
    if (description.isEmpty || imageUrl.isEmpty)
      throw FormatException("Empty values");
    _recipeDescriptions.add(description);
    _imageUrls.add(imageUrl);
  }

  String getRecipeDescription() {
    if (_recipeDescriptions.isNotEmpty) {
      return _recipeDescriptions.first;
    } else {
      return "";
    }
  }

  String getRecipeImage() {
    if (_imageUrls.isNotEmpty) {
      return _imageUrls.first;
    } else {
      return "";
    }
  }

  void removeCurrentRecipe() {
    if (_recipeDescriptions.isNotEmpty) {
      _recipeDescriptions.removeFirst();
    }
    if (_imageUrls.isNotEmpty) {
      _imageUrls.removeFirst();
    }
  }
}
