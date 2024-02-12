import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/TinderMVC/tinder_view.dart';
import 'package:food_ai_app/API/chatgpt_recipe_mock.dart';
import 'package:flutter/material.dart';

class TinderController {
  TinderModel model;
  ChatGPTRecipeInterface gptApiClient;
  ImageFetcherInterface imageFetcherClient;

  final int THREAD_COUNT = 3;

  VoidCallback? onModelUpdated;

  // Constructor
  TinderController(this.model, this.gptApiClient, this.imageFetcherClient);

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
      final String description = await gptApiClient.fetchRecipe();
      final String image =
          await imageFetcherClient.fetchImage(""); // placeholder
      model.addRecipe(description, image);
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
