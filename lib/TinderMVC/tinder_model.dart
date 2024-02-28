import 'dart:collection';

import 'package:flutter/cupertino.dart';

/// Manages the data for the recipe app, including recipe descriptions and image URLs.
/// Notifies listeners when changes occur to allow UI updates.
class TinderModel extends ChangeNotifier {
  /// Stores URLs of recipe images.
  final Queue<String> _imageUrls = Queue<String>();

  /// Stores descriptions of recipes.
  final Queue<String> _recipeDescriptions = Queue<String>();

  /// Adds a recipe's description and image URL to the model. Notifies listeners on change.
  /// Throws a [FormatException] if either the description or image URL is empty.
  void addRecipe(String description, String imageUrl) {
    if (description.isEmpty || imageUrl.isEmpty)
      throw FormatException("Empty values");
    _recipeDescriptions.add(description);
    _imageUrls.add(imageUrl);
    notifyListeners();
  }

  /// Returns the description of the first recipe in the queue.
  /// Returns an empty string if no descriptions are available.
  String getRecipeDescription() {
    if (_recipeDescriptions.isNotEmpty) {
      return _recipeDescriptions.first;
    } else {
      return "";
    }
  }

  /// Returns the image URL of the first recipe in the queue.
  /// Returns an empty string if no images are available.
  String getRecipeImage() {
    if (_imageUrls.isNotEmpty) {
      return _imageUrls.first;
    } else {
      return "";
    }
  }

  /// Removes the current (first) recipe from the model, both description and image URL.
  /// Does nothing if no recipes are available.
  void removeCurrentRecipe() {
    if (_recipeDescriptions.isNotEmpty) {
      _recipeDescriptions.removeFirst();
    }
    if (_imageUrls.isNotEmpty) {
      _imageUrls.removeFirst();
    }
  }

  /// Checks if there are any recipes (both descriptions and images) available in the model.
  /// Returns true if there is at least one recipe description and image URL.
  bool hasData() {
    return _recipeDescriptions.isNotEmpty && _imageUrls.isNotEmpty;
  }
}
