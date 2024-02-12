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
    await initRecipes();
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

  String extractFirstLineFromString(String text) {
    final List<String> lines = text.split('\n');
    if (lines.isNotEmpty) {
      return lines.first;
    } else {
      return '';
    }
  }

  Future<void> initRecipes() async {
    // Step 1: Fetch all recipes concurrently
    List<Future<String>> recipeFutures = List.generate(
      THREAD_COUNT,
      (_) => gptApiClient.fetchRecipe(),
    );

    List<String> descriptions = await Future.wait(recipeFutures);

    // Step 2: Extract information for image fetch
    List<Future<String>> imageFutures = descriptions.map((description) {
      String firstLine = extractFirstLineFromString(description);
      return imageFetcherClient.fetchImage(firstLine);
    }).toList();

    // Step 3: Fetch all images concurrently
    List<String> images = await Future.wait(imageFutures);

    // Step 4: Combine recipes and images
    for (int i = 0; i < descriptions.length; i++) {
      model.addRecipe(descriptions[i], images[i]);
    }
  }

  // Add async to method
  Future<void> fetchRecipes() async {
    final String description = await gptApiClient.fetchRecipe();
    final String image = await imageFetcherClient
        .fetchImage(extractFirstLineFromString(description));
    model.addRecipe(description, image);
  }

  // Add async to method
  Future<void> changeRecipe() async {
    model.removeCurrentRecipe();
    fetchRecipes();
    refreshView();
  }
}
