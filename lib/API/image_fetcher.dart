import 'dart:convert';

import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:http/http.dart' as http;

/// A concrete implementation of [ImageFetcherInterface] that fetches images
/// from a specified API based on a text query.
class ImageFetcher extends ImageFetcherInterface {
  /// Static counter used to determine which API URL and key to use for a request.
  static int counter = 0;

  /// List of API URLs to cycle through for image fetching.
  final List<String> urls = [
    'https://gpt-aus.openai.azure.com/openai/deployments/marco-dalle/images/generations?api-version=2024-02-01',
    'https://gpt-eas.openai.azure.com/openai/deployments/marco-dalle/images/generations?api-version=2024-02-01',
    'https://gpt-swe.openai.azure.com/openai/deployments/marco-dalle/images/generations?api-version=2024-02-01',
  ];

  /// Corresponding API keys for each URL listed in [urls].
  final List<String> apiKeys = [
    'bfc9723eaa5443bcabf0fa450647baf3',
    '885651f0d3cd4eb3b87b3b093a57f596',
    'f464746024d54619971e6a7e1d3a91b6',
  ];

  /// Fetches an image URL from an external API based on the provided [query].
  /// This method cycles through different API endpoints and keys by using a static
  /// counter to select an index, which is used to choose the URL and key from the lists.
  ///
  /// Returns a [Future<String>] that resolves to the URL of the fetched image.
  /// If the request is successful and the image data is found in the response, the image URL is returned.
  ///
  /// Throws an [Exception] if the request fails or if the image data is not found in the API response.
  @override
  Future<String> fetchImage(String query) async {
    final int index = counter % urls.length;
    final url = Uri.parse(urls[index]);
    final apiKey = apiKeys[index];
    print(url);
    counter++;

    http.Response response;
    do {
      response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'api-key': apiKey},
        body: jsonEncode({
          "model": "marco-dalle",
          "prompt": "<Generate me a realistic looking image of a $query>",
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
