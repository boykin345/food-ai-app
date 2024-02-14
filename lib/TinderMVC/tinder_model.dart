import 'dart:collection';

import 'package:flutter/cupertino.dart';

class TinderModel extends ChangeNotifier {
  final Queue<String> _imageUrls = Queue<String>();
  final Queue<String> _recipeDescriptions = Queue<String>();

  void addRecipe(String description, String imageUrl) {
    if (description.isEmpty || imageUrl.isEmpty)
      throw FormatException("Empty values");
    _recipeDescriptions.add(description);
    _imageUrls.add(imageUrl);
    notifyListeners();
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

  bool hasData() {
    return _recipeDescriptions.isNotEmpty && _imageUrls.isNotEmpty;
  }
}
