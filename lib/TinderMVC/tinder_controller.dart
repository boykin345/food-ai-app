import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/TinderMVC/tinder_view.dart';
import 'package:flutter/material.dart';

import '../FullRecipeGeneration/recipe_overview.dart';

/// Controls the interaction between the model and view in the recipe app.
class TinderController {
  /// The model representing the state and data of the app.
  TinderModel model;

  /// Client to interact with a recipe-fetching API.
  ChatGPTRecipeInterface gptApiClient;

  /// Client to fetch images based on recipe descriptions.
  ImageFetcherInterface imageFetcherClient;

  /// Number of recipes to fetch in parallel.
  final int threadCount = 10;

  /// Callback to update the view when the model changes.
  VoidCallback? onModelUpdated;

  /// Object which handles operations for full recipe generation
  RecipeOverview recipeOverview = RecipeOverview();

  /// Constructs a [TinderController] with dependencies for model, API, and image fetching.
  TinderController(this.model, this.gptApiClient, this.imageFetcherClient);

  /// Initializes the model by fetching initial set of recipes.
  Future<void> initialize() async {
    await initRecipes();
  }

  /// Triggers the view to refresh by calling [onModelUpdated].
  void refreshView() {
    recipeOverview.dishName =
        extractFirstLineFromString(model.getRecipeDescription());
    recipeOverview.imageLink = model.getRecipeImage();
    onModelUpdated?.call();
  }

  /// Creates and returns a new [TinderView] configured with callbacks for changing recipes.
  TinderView createView() {
    return TinderView(
      model: model,
      onChangeRecipe: () {
        changeRecipe(); // Wrap the async call with a function
      },
      recipeOverview: recipeOverview, // Inject a RecipeOverview object
    );
  }

  /// Extracts and returns the first line from a given string [text].
  String extractFirstLineFromString(String text) {
    final List<String> lines = text.split('\n');
    if (lines.isNotEmpty) {
      return lines.first;
    } else {
      return '';
    }
  }

  /// Initializes the app's recipes by fetching descriptions and images asynchronously.
  Future<void> initRecipes() async {
    // Step 1: Fetch all recipes concurrently

    final List<Future<String>> recipeFutures = List.generate(
      threadCount,
      (_) => gptApiClient.fetchRecipe(),
    );
    print("1");
    final List<String> descriptions = await Future.wait(recipeFutures);
    print("2");
    // Step 2: Extract information for image fetch
    final List<Future<String>> imageFutures = descriptions.map((description) {
      final String firstLine = extractFirstLineFromString(description);
      return imageFetcherClient.fetchImage(firstLine);
    }).toList();
    print("3");
    // Step 3: Fetch all images concurrently
    final List<String> images = await Future.wait(imageFutures);

    // Step 4: Combine recipes and images
    for (int i = 0; i < threadCount; i++) {
      model.addRecipe(descriptions[i], images[i]);
    }
    print("4");
    refreshView();
  }

  /// Fetches a new recipe and its corresponding image, then updates the model.
  Future<void> fetchRecipes() async {
    final String description = await gptApiClient.fetchRecipe();
    final String image = await imageFetcherClient
        .fetchImage(extractFirstLineFromString(description));
    model.addRecipe(description, image);
    refreshView();
  }

  /// Changes the current recipe to a new one by removing the current and fetching a new recipe.
  Future<void> changeRecipe() async {
    model.removeCurrentRecipe();
    fetchRecipes();
    refreshView();
  }
}
