import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

/// A class for making API calls related to image processing and communication with OpenAI/Azure.
class APICall {
  /// Uploads an image file to Firebase Storage and returns its download URL.
  ///
  /// Throws an exception if there is an error uploading the image.
  ///
  /// [file] The file to be uploaded.
  ///
  /// Returns the download URL of the uploaded image.
  static Future<String?> uploadImageAndGetDownloadUrl(File file) async {
    try {
      final String fileName = path.basename(file.path);
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/$fileName');
      await ref.putFile(file);
      final String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    }
  }

  /// Sends an image URL to OpenAI for processing and returns the response.
  ///
  /// [imageUrl] The URL of the image to be processed.
  ///
  /// Returns the response from OpenAI or an error message.
  static Future<String> sendToOpenAI(String imageUrl) async {
    final uri = Uri.parse(
        'https://gpt-marco-sweden.openai.azure.com/openai/deployments/marco-gpt-vision/chat/completions?api-version=2024-02-15-preview'); // API URL
    const String apiKey = '5e87e76b7c4543e2b69a707f773d4e8e';
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'api-key': apiKey},
      body: jsonEncode({
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text":
                    "What are ingredients inside of that fridge? Just give Name:quantity, nothing else. Example: 'Apple: 1' "
              },
              {
                "type": "image_url",
                "image_url": {"url": imageUrl}
              }
            ]
          }
        ],
        "temperature": 0.7,
        "top_p": 0.95,
        "max_tokens": 800
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error: ${response.statusCode}';
    }
  }

  /// Parse the content string to extract ingredients and their quantities.
  Map<String, String> parseContent(String content) {
    final Map<String, String> resultMap = {};
    final lines = content.split('\n');
    for (final line in lines) {
      final parts = line.split(':');
      if (parts.length == 2) {
        final ingredient = parts[0].trim();
        final quantity = parts[1].trim();
        resultMap[ingredient] = quantity;
      }
    }
    return resultMap;
  }
}
