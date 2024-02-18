import 'package:flutter/cupertino.dart';
import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:food_ai_app/API/image_fetcher_mock.dart';
import 'package:food_ai_app/TinderMVC/tinder_controller.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/API/chatgpt_recipe_mock.dart';

class TinderPage extends StatefulWidget {
  @override
  _TinderPageState createState() => _TinderPageState();
}

class _TinderPageState extends State<TinderPage> {
  late TinderController controller;
  late TinderModel model;
  late ChatGPTRecipeInterface gptApiClient;
  late ImageFetcherInterface imageFetcherClient;

  @override
  void initState() {
    super.initState();
    model = TinderModel();
    gptApiClient = ChatGPTRecipeMock(
        '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'); //Change to ChatGPTRecipe for real API
    imageFetcherClient =
        ImageFetcherMock(); //Change to ImageFetcher for real API
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
    return controller
        .createView(); // This will create the view with current model data
  }
}
