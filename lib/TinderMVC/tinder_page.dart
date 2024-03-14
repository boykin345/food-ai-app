import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:food_ai_app/API/image_fetcher_mock.dart';
import 'package:food_ai_app/TinderMVC/tinder_controller.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/API/chatgpt_recipe_mock.dart';

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
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (userSnapshot.exists) {
        userSettings = userSnapshot.data() as Map<String, dynamic>;

        healthGoals = userSettings['activeHealthGoals'] is List
            ? List<String>.from(
                userSettings['activeHealthGoals'] as List<dynamic>)
            : [];

        preferences = (userSettings['activePreferences'] is List)
            ? List<String>.from(
                userSettings['activePreferences'] as List<dynamic>)
            : [];
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
    print(healthGoals);
    print(preferences);
    final String healthGoalsString = healthGoals.join(', ');
    final String preferencesString = preferences.join(', ');

    gptApiClient = ChatGPTRecipeMock(
      'bafe17e1da1e4a0a870426f8a7fd64d6',
      ingredientsMap: widget.ingredientsMapCons,
      userDifficulty:
          int.tryParse(userSettings['difficulty']?.toString() ?? '') ?? 1,
      userCookingTime: userSettings['cookingTime']?.toString() ?? '30 min',
      userPortionSize:
          int.tryParse(userSettings['portionSize']?.toString() ?? '') ?? 1,
      userAllergies:
          List<String>.from(userSettings['allergies'] as List<dynamic>? ?? []),
      healthGoalsString: healthGoalsString,
      preferencesString: preferencesString,
    );

    imageFetcherClient =
        ImageFetcherMock(); // Change to ImageFetcher for real API
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
