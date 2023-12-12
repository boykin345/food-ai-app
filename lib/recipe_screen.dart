import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chatgpt_recipe.dart';

class RecipeScreen extends StatefulWidget {
  final Map<String, String> ingredients;

  const RecipeScreen({Key? key, required this.ingredients}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String _recipeResponse = '';
  static final apiKey = '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';
  late final ChatGPTRecipe chatGPTRecipe;

  @override
  void initState() {
    super.initState();
    chatGPTRecipe = ChatGPTRecipe(apiKey);
    requestRecipe();
  }

  void requestRecipe() async {
    String ingredientList = widget.ingredients.keys.join(', ');
    String userMessage =
        'User: \nIngredients: $ingredientList \n\nPlease give me some recipes based on the ingredients above!\n';
    try {
      var response = await chatGPTRecipe.getChatResponse(userMessage);
      setState(() {
        _recipeResponse = extractContent(response);
      });
    } catch (e) {
      print('API Request Error: $e');
      setState(() {
        _recipeResponse =
            'Failed to fetch recipe: ${e.toString()}'; // More detailed error message
      });
    }
  }

  String extractContent(String jsonString) {
    try {
      var decoded = jsonDecode(jsonString);
      String content = decoded['choices'][0]['message']['content'];
      return content;
    } catch (e) {
      print('Extraction JSON function failed: $e');
      return 'Error extracting recipe';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Suggestions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _recipeResponse.isNotEmpty ? _recipeResponse : 'Loading...',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
