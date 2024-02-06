import 'package:food_ai_app/tinder_model.dart';
import 'package:food_ai_app/tinder_view.dart';
import 'package:food_ai_app/api_mock.dart';
import 'package:flutter/material.dart';

class TinderController {
  TinderModel model;
  MockApiClient apiClient;
  final int THREAD_COUNT = 3;

  VoidCallback? onModelUpdated;

  // Constructor
  TinderController(this.model, this.apiClient);

  // Moved initialization out of constructor to use async feature
  Future<void> initialize() async {
    await fetchRecipes();
  }

  void refreshView() {
    onModelUpdated?.call();
  }

  // Method to be called to create a new TinderView
  TinderView createView() {
    return TinderView(
      model: model,
      onChangeRecipe: () {
        changeRecipe(); // Wrap the async call with a function
      },
    );
  }

  // Add async to method
  Future<void> fetchRecipes() async {
    for (int i = 0; i < THREAD_COUNT; i++) {
      final String description = apiClient.fetchDescription();
      final String image = await apiClient.fetchImage();
      model.addRecipe(description, image);
      apiClient.incrementCounter();
    }
    model.resetIndex();
  }

  // Add async to method
  Future<void> changeRecipe() async {
    if (model.getIndex() >= THREAD_COUNT - 1) {
      model.resetIndex();
      await fetchRecipes();
    } else {
      model.incrementIndex();
    }
    refreshView();
  }
}
