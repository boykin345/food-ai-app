import 'package:flutter/material.dart';
import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/TinderMVC/tinder_view.dart';

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
  final int threadCount = 5;

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
    // Start the stopwatch
    final stopwatch = Stopwatch()..start();

    List<Future<void>> tasks = List.generate(threadCount, (_) async {
      // Fetch recipe asynchronously
      String description = await gptApiClient.fetchRecipe();
      print("Recipe fetched");

      // Extract first line for image fetch
      String firstLine = extractFirstLineFromString(description);

      // Fetch image asynchronously
      String image = await imageFetcherClient.fetchImage(firstLine);
      print("Image fetched");

      // Combine recipe and image
      model.addRecipe(description, image);
    });

    // Wait for all tasks to complete
    await Future.wait(tasks);
    print("All recipes and images are fetched");

    // Stop the stopwatch and print the elapsed time
    stopwatch.stop();
    print('Finished in ${stopwatch.elapsedMilliseconds} milliseconds.');

    // Refresh the view once everything is done
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
