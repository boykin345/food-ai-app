import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:food_ai_app/TinderMVC/tinder_controller.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';

import '../API/chatgpt_recipe.dart';
import '../API/image_fetcher.dart';
import '../LoadingScreen/custom_loading_circle.dart';
import '../Util/colours.dart';

/// A widget that serves as the entry point for the Tinder-like recipe selection feature.
/// It initializes the model, controller, and mock API clients, then builds the UI based on the model's state.
class TinderPage extends StatefulWidget {
  final Map<String, String> ingredientsMapCons;

  const TinderPage({super.key, required this.ingredientsMapCons});

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

  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = fetchUserDataAndInitialize();
  }

  Future<void> fetchUserDataAndInitialize() async {
    Map<String, dynamic> userSettings = {}; // This will hold user settings.
    List<String> healthGoals = [];
    List<String> preferences = [];
    List<String> userAllergies = []; // Initialize the list for allergies.

    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (userSnapshot.exists) {
        userSettings = userSnapshot.data() as Map<String, dynamic>;

        // Fetch activeHealthGoals and activePreferences from Personalisation document as before.
        final personalisationSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('Personalisation')
            .doc('Personalisation')
            .get();
        if (personalisationSnapshot.exists) {
          var personalisationData =
              personalisationSnapshot.data() as Map<String, dynamic>;
          healthGoals = personalisationData['activeHealthGoals'] is List
              ? List<String>.from(
                  personalisationData['activeHealthGoals'] as List<dynamic>)
              : [];
          preferences = personalisationData['activePreferences'] is List
              ? List<String>.from(
                  personalisationData['activePreferences'] as List<dynamic>)
              : [];
        }

        // Directly fetch userAllergies from the user document.
        userAllergies = userSettings['allergies'] is List
            ? List<String>.from(userSettings['allergies'] as List<dynamic>)
            : [];
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }

    print(healthGoals);
    print(preferences);
    final String healthGoalsString = healthGoals.join(', ');
    final String preferencesString = preferences.join(', ');

    gptApiClient = ChatGPTRecipe(
      '0f91ba9b74344d7699144a8afbeeae2b',
      ingredientsMap: widget.ingredientsMapCons,
      userDifficulty:
          int.tryParse(userSettings['difficulty']?.toString() ?? '') ?? 1,
      userCookingTime: userSettings['cookingTime']?.toString() ?? '30 min',
      userPortionSize:
          int.tryParse(userSettings['portionSize']?.toString() ?? '') ?? 1,
      userAllergies: userAllergies,
      healthGoalsString: healthGoalsString,
      preferencesString: preferencesString,
    );

    imageFetcherClient = ImageFetcher(); // Change to ImageFetcher for real API
    model = TinderModel();
    controller = TinderController(model, gptApiClient, imageFetcherClient);
    controller.onModelUpdated = () {
      setState(() {
        // This will rebuild the TinderPage with the updated model
      });
    };
    await controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return controller.createView();
          } else {
            return Center(child: CustomLoadingCircle());
          }
        },
      ),
    );
  }
}
