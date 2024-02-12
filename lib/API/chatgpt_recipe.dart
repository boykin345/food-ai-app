import 'dart:convert';
import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:http/http.dart' as http;

class ChatGPTRecipe extends ChatGPTRecipeInterface {
  final String apiKey;

  ChatGPTRecipe(this.apiKey);

  Future<String> getChatResponse(String message) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': message}
        ],
        'max_tokens': 200,
        'model': 'gpt-4',
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch chat response');
    }
  }

  @override
  Future<String> fetchRecipe() async {
    try {
      final message =
          'Tell me how to make tomato soup, do not need to give me instructions, make your description concise and in this format: Calories:\n Prep Time:\nDifficult Rating:\nProtein:\n Carbohydrates:\nFats:\nCooking Times:\nUtensils:\nProtenial Allergens:\nIngredients: , and make sure your calories is only number, no other things, and make name of cuisine name on first line(only show  tomato soup),make difficult rating out of 10';
      final response = await getChatResponse(message);
      final decodedResponse = jsonDecode(response)
          as Map<String, dynamic>; // Safely cast to Map<String, dynamic>
      if (decodedResponse.containsKey('choices') &&
          decodedResponse['choices'] is List) {
        final choices = decodedResponse['choices'] as List;
        if (choices.isNotEmpty && choices[0] is Map<String, dynamic>) {
          final firstChoice = choices[0] as Map<String, dynamic>;
          if (firstChoice.containsKey('message') &&
              firstChoice['message'] is Map<String, dynamic>) {
            final messageContent =
                firstChoice['message'] as Map<String, dynamic>;
            if (messageContent.containsKey('content') &&
                messageContent['content'] is String) {
              final String recipe =
                  messageContent['content'] as String; // Safely cast to String
              return recipe;
            }
          }
        }
      }
      throw Exception('Invalid response structure');
    } catch (e) {
      throw Exception('Error fetching recipe: $e');
    }
  }
}
