import 'package:flutter_test/flutter_test.dart';

import 'package:food_ai_app/api_mock.dart';
import 'package:food_ai_app/tinder_controller.dart';
import 'package:food_ai_app/tinder_model.dart';
import 'package:food_ai_app/tinder_view.dart';

// I - Unit tests for the TinderModel, TinderView and TinderController classes
void main() {
  final String DESCRIPTION_1 = "This is a description of the image 0";
  final String DESCRIPTION_4 = "This is a description of the image 3";
  final String DESCRIPTION_5 = "This is a description of the image 4";
  final String DESCRIPTION_6 = "This is a description of the image 5";

  final String IMAGE_1 = "https://example.com/image0.jpg";
  final String IMAGE_4 = "https://example.com/image3.jpg";
  final String IMAGE_5 = "https://example.com/image4.jpg";
  final String IMAGE_6 = "https://example.com/image5.jpg";

  MockApiClient? apiClient;
  TinderModel? tinderModel;
  TinderView? tinderView;
  TinderController? tinderController;

  setUp(() {
    // Initialize new instances before each test
    apiClient = MockApiClient();
    tinderModel = TinderModel();
    tinderView = TinderView();
    tinderController = TinderController(tinderModel!, tinderView!, apiClient!);
  });

  group("Check index variable", () {
    test("Index initialised correctly", () {
      expect(tinderModel?.getIndex(), 0);
    });

    test("Index incremented correctly", () {
      tinderModel?.incrementIndex();
      expect(tinderModel?.getIndex(), 1);
    });
  });

  group("Check TinderModel methods", () {
    test("getRecipeDescription gets descriptions correctly when initialised",
        () {
      expect(tinderModel?.getRecipeDescription(), DESCRIPTION_1);
    });

    test("getRecipeImage gets images correctly when initialised", () {
      expect(tinderModel?.getRecipeImage(), IMAGE_1);
    });

    test("addRecipe handles null values correctly", () {
      expect(() => tinderModel?.addRecipe("", ""), throwsFormatException);
    });
  });

  group("Check TinderController methods", () {
    test("TinderController fetchRecipes updates both lists correctly", () {
      tinderController?.changeRecipe();
      expect(tinderModel?.getIndex(), 1);
      tinderController?.changeRecipe();
      expect(tinderModel?.getIndex(), 2);
      tinderController?.changeRecipe();
      expect(tinderModel?.getIndex(), 0);

      expect(tinderModel?.getRecipeDescription(), DESCRIPTION_4);
      expect(tinderModel?.getRecipeImage(), IMAGE_4);
      tinderModel?.incrementIndex();

      expect(tinderModel?.getRecipeDescription(), DESCRIPTION_5);
      expect(tinderModel?.getRecipeImage(), IMAGE_5);
      tinderModel?.incrementIndex();

      expect(tinderModel?.getRecipeDescription(), DESCRIPTION_6);
      expect(tinderModel?.getRecipeImage(), IMAGE_6);
      tinderModel?.incrementIndex();
    });

    test(
        "TinderController changeRecipe adds items to relevant lists correctly after index crosses THREAD_COUNT",
        () {
      tinderController?.changeRecipe();
      tinderController?.changeRecipe();
      tinderController?.changeRecipe();

      expect(tinderModel?.getRecipeDescription(), DESCRIPTION_4);
      expect(tinderModel?.getRecipeImage(), IMAGE_4);
    });

    test(
        "TinderController changeRecipe updates the pointer correctly if its less than THREAD_COUNT",
        () {
      tinderController?.changeRecipe();
      expect(tinderModel?.getIndex(), 1);
    });

    test(
        "TinderController changeRecipe resets the pointer correctly if its equal to THREAD_COUNT",
        () {
      tinderController?.changeRecipe();
      tinderController?.changeRecipe();
      tinderController?.changeRecipe();

      expect(tinderModel?.getIndex(), 0);
    });
  });
}
