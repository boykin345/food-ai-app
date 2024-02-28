import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final url = Uri.parse('https://api.edenai.run/v2/image/generation');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiODZjY2Y3MGUtMDE5YS00MTY3LTg2OWQtMjUyOTZkZDVmYzQ2IiwidHlwZSI6ImFwaV90b2tlbiJ9.cUa508ZkMKPXZxMpjB2kOgRpY1DSo75PLljcR98LtlY',
      },
      body: jsonEncode({
        "providers": "openai",
        "text": query,
        "resolution": "256x256",
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null &&
          data['openai'] != null &&
          data['openai']['items'] != null) {
        return data['openai']['items'][0]['image'] as String;
      } else {
        throw Exception('Image data not found in response');
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}
