import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:mockito/mockito.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:convert';

class ImageFetcherMock extends ImageFetcherInterface {
  int count = 0;

  final String IMAGE_0 = "assets/A1.png";
  final String IMAGE_1 = "assets/A2.png";
  final String IMAGE_2 = "assets/A3.png";
  final String IMAGE_3 = "assets/A4.png";
  final String IMAGE_4 = "assets/A5.png";
  final String IMAGE_5 = "assets/A6.png";

  void incrementCounter() {
    if (count >= 6) {
      count = -1;
    }
    count++;
  }

  Future<String> imageToBase64(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final String base64String = base64Encode(bytes);

      return base64String;
    } catch (e) {
      print("Error converting image to Base64 string: $e");
      return '';
    }
  }

  Future<String> convertAndPrintBase64(String imageName) async {
    final String base64String = await imageToBase64(imageName);
    return base64String;
  }

  @override
  Future<String> fetchImage(String query) async {
    String assetPath;
    switch (count) {
      case 0:
        assetPath = IMAGE_0;
      case 1:
        assetPath = IMAGE_1;
      case 2:
        assetPath = IMAGE_2;
      case 3:
        assetPath = IMAGE_3;
      case 4:
        assetPath = IMAGE_4;
      case 5:
        assetPath = IMAGE_5;
      default:
        assetPath = "";
    }
    incrementCounter();
    return Future.delayed(
        Duration(seconds: 2), () => convertAndPrintBase64(assetPath));
  }
}
