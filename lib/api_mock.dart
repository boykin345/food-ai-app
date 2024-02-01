import 'package:mockito/mockito.dart';

class MockApiClient extends Mock {
  int count = 0;

  void incrementCounter() {
    count++;
  }

  String fetchImage() {
    return "https://example.com/image$count.jpg";
  }

  String fetchDescription() {
    return "This is a description of the image $count";
  }
}
