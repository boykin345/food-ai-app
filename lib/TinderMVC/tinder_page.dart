import 'package:flutter/cupertino.dart';
import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:food_ai_app/API/image_fetcher_mock.dart';
import 'package:food_ai_app/TinderMVC/tinder_controller.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/API/chatgpt_recipe_mock.dart';

import '../API/chatgpt_recipe.dart';
import '../API/image_fetcher.dart';

/// A widget that serves as the entry point for the Tinder-like recipe selection feature.
/// It initializes the model, controller, and mock API clients, then builds the UI based on the model's state.
class TinderPage extends StatefulWidget {
  @override
  _TinderPageState createState() => _TinderPageState();
}

class _TinderPageState extends State<TinderPage> {
  /// Controller for the Tinder-like recipe feature.
  late TinderController controller;

  /// Model holding the recipe and image data.
  late TinderModel model;

  /// API client for fetching recipe descriptions.
  late ChatGPTRecipeInterface gptApiClient;

  /// API client for fetching recipe images.
  late ImageFetcherInterface imageFetcherClient;

  @override
  void initState() {
    super.initState();
    model = TinderModel();
    gptApiClient = ChatGPTRecipe(
        '46ac92c47cd344e48007ac50e31d7771'); //Change to ChatGPTRecipe for real API
    imageFetcherClient = ImageFetcher(); //Change to ImageFetcher for real API
    controller = TinderController(model, gptApiClient, imageFetcherClient);
    controller.onModelUpdated = () {
      setState(() {
        // This will rebuild the TinderPage with the updated model
      });
    };
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    /// Builds and returns the view managed by [controller], reflecting the current state of [model].
    return controller.createView();
  }
}
