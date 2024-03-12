import 'dart:convert';
import 'package:http/http.dart' as http;

//class to handle GPT api requests to generate a recipe
class GPTRecipeApi {
  final String apiKey;

  //constructor method
  GPTRecipeApi(this.apiKey);

  //method for fetching responses from GPT
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

    //return response if successful
    if (response.statusCode == 200) {
      return response.body;
    }
    //throw exception of not successful
    else {
      throw Exception('Failed to fetch chat response');
    }
  }

  //function to get a recipe from GPT
  Future<String> getRecipe(String dishName) async {
    try {
      String message = " ";

      //instruct the api to return a recipe with name, difficulty cooking time, ingredients and method
      message =
          'Tell me how to make $dishName, give me the name of the dish, a difficulty rating out of 10 and estimated cooking time, calories, a list of ingredients and a full method with step-by-step instructions in that order. Insert two newlines after each requested thing';

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
