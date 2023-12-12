import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGPTRecipe {
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
        'max_tokens': 100,
        'model': 'gpt-4',
        'stream': false,
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch chat response');
    }
  }
}
