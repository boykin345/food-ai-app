import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:food_ai_app/LoadingScreen/custom_loading_circle.dart';
import 'package:food_ai_app/TinderMVC/tinder_controller.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/TinderMVC/tinder_page.dart';
import 'package:food_ai_app/API/chatgpt_recipe_mock.dart';
import 'package:food_ai_app/API/image_fetcher_mock.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('TinderPage Tests', () {
    late TinderController controller;
    late TinderModel model;
    late ChatGPTRecipeInterface gptApiClient;
    late ImageFetcherInterface imageFetcherClient;

    setUp(() {});
  });
}
