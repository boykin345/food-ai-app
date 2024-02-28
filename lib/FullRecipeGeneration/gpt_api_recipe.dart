import 'dart:convert';
import 'package:http/http.dart' as http;

//class to handle GPT api requests to generate a recipe
class GPTRecipeApi {
  final String apiKey;

  //constructor method
  GPTRecipeApi(this.apiKey);

  //method for fetching responses from GPT
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
  Future<String> getRecipe(String dishName, bool isImage) async {
    try {
      String message = " ";
      if (!isImage) {
        //instruct the api to return a recipe with name, difficulty cooking time, ingredients and method
        message =
            'Tell me how to make $dishName, give me the name of the dish, a difficulty rating out of 10 and estimated cooking time, then give me a list of ingredients and a full method with step-by-step instructions';
      } else {
        //instruct the api to get an image of the dish
        message = "Give me the image address of an image of a $dishName";
      }

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
