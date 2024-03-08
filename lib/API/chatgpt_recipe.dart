import 'dart:convert';
import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:http/http.dart' as http;

/// A concrete implementation of [ChatGPTRecipeInterface] that fetches recipe descriptions
/// from the OpenAI API using the GPT model.
class ChatGPTRecipe extends ChatGPTRecipeInterface {
  /// The API key used for authenticating requests to the OpenAI API.
  final String apiKey;

  // Add fields for user settings.
  final int userDifficulty;
  final String userCookingTime;
  final int userPortionSize;
  final List<String> userAllergies;

  /// The map is used as part of a prompt to gpt.
  final Map<String, String> ingredientsMap;




  // Modify the constructor to accept user settings.
  ChatGPTRecipe(
      this.apiKey, {
        required this.ingredientsMap,
        required this.userDifficulty,
        required this.userCookingTime,
        required this.userPortionSize,
        required this.userAllergies,
      });


  /// Sends a chat message to the OpenAI API and returns the API's response.
  /// Throws an exception if the request fails or the response is not 200 OK.
  Future<String> getChatResponse(String message) async {
    final url = Uri.parse(
        'https://marco-gpt-uk.openai.azure.com/openai/deployments/marco-gpt-4/chat/completions?api-version=2024-02-15-preview');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'api-key': apiKey},
      body: jsonEncode({
        "messages": [
          {"role": "user", "content": message}
        ],
        "temperature": 0.7,
        "top_p": 0.95,
        "frequency_penalty": 0,
        "presence_penalty": 0,
        "max_tokens": 800,
        "stop": null
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch chat response');
    }
  }

  /// Fetches a concise recipe description formatted according to specific criteria.
  ///
  /// This method formats the request to include detailed specifications for the recipe's
  /// description format, then parses the JSON response to extract the recipe text.
  ///
  /// Throws an exception if the response format is invalid or in case of an error.
  @override
  Future<String> fetchRecipe() async {
    final ingredientsString = ingredientsMap.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ');
    try {
      final message = 'Tell me a set of dishes based on ingredients: $ingredientsString, '
          'do not need to give me instructions, make your description concise and in this format: Calories:\n Prep Time:\nDifficult Rating:\nProtein:\n Carbohydrates:\nFats:\nCooking Times:\nUtensils:\nProtenial Allergens:\nIngredients: , and make sure your calories is only number, no other things, and make name of cuisine name on first line(only show  tomato soup),make difficult rating out of 10 '
          'And the condition of food should be close to these information: '
          'Difficulty: $userDifficulty, '
          'Cooking Time: $userCookingTime, '
          'Portion Size: $userPortionSize, '
          'Allergies: ${userAllergies.join(', ')}, '
          'make sure your description is concise and formatted properly.';

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
