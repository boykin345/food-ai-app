import 'dart:convert';

import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:http/http.dart' as http;

/// A concrete implementation of [ImageFetcherInterface] that fetches images
/// from a specified API based on a text query.
class ImageFetcher extends ImageFetcherInterface {
  /// Fetches an image URL from an external API based on the provided [query].
  ///
  /// Returns a [Future<String>] that resolves to the URL of the fetched image.
  /// If the request is successful and the image data is found in the response, the image URL is returned.
  ///
  /// Throws an [Exception] if the request fails or if the image data is not found in the API response.
  @override
  Future<String> fetchImage(String query) async {
    final url = Uri.parse(
        'https://gpt-aus.openai.azure.com/openai/deployments/marco-dalle/images/generations?api-version=2024-02-01');

    const String apiKey = 'bfc9723eaa5443bcabf0fa450647baf3';

    http.Response response;
    do {
      response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'api-key': apiKey},
        body: jsonEncode({
          "model": "marco-dalle",
          "prompt": "<Generate me an image of a realistic looking $query>",
          "n": 1
        }),
      );
    } while (response.statusCode != 200);

    if (response.statusCode == 200) {
      final imageUrl = jsonDecode(response.body)['data'][0]['url'] as String;
      // Fetch the image data from the URL
      final imageResponse = await http.get(Uri.parse(imageUrl));
      if (imageResponse.statusCode == 200) {
        // Convert the image data to base64
        final base64Image = base64Encode(imageResponse.bodyBytes);
        return base64Image;
      } else {
        throw Exception('Failed to fetch image data');
      }
    } else {
      print(response.body);
      throw Exception('Failed to generate image');
    }
  }
}
