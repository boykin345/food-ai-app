import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

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
        'https://gpt-marco-west.openai.azure.com/openai/deployments/gpt-george-vision/chat/completions?api-version=2024-02-15-preview'); // API URL
    const String apiKey = 'bafe17e1da1e4a0a870426f8a7fd64d6';
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
}
