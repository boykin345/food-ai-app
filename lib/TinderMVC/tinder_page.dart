import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    Future<void> fetchUserDataAndInitialize() async {

      Map<String, dynamic> userSettings = {}; // This will hold user settings.
      try {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
        userSettings = userSnapshot.data() as Map<String, dynamic>;
      } catch (error) {
        print('Error fetching user data: $error');
      }

      gptApiClient = ChatGPTRecipe(
        '46ac92c47cd344e48007ac50e31d7771', // Use your actual API key here
        userDifficulty: userSettings['difficulty'] ?? 1, // Default values if user settings are not found
        userCookingTime: userSettings['cookingTime'] ?? '30 min',
        userPortionSize: userSettings['portionSize'] ?? 1,
        userAllergies: List<String>.from(userSettings['allergies'] ?? []),
      );

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
