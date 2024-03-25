import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';

/// I1/I.2 Tests for the Model in the TinderMVC
void main() {
  group('TinderModel Normal Tests', () {
    late TinderModel tinderModel;

    setUp(() {
      tinderModel = TinderModel();
    });

    test('Adding a recipe and retrieving it', () {
      final String testDescription = "Test Description";
      final String testImageUrl = "Test URL";
      tinderModel.addRecipe(testDescription, testImageUrl);

      expect(tinderModel.getRecipeDescription(), testDescription);
      expect(tinderModel.getRecipeImage(), testImageUrl);
    });

    test('Removing a recipe updates data correctly', () {
      tinderModel.addRecipe("Description 1", "URL 1");
      tinderModel.addRecipe("Description 2", "URL 2");

      tinderModel.removeCurrentRecipe();

      expect(tinderModel.getRecipeDescription(), "Description 2");
      expect(tinderModel.getRecipeImage(), "URL 2");
      expect(tinderModel.hasData(), isTrue);

      tinderModel.removeCurrentRecipe();
      expect(tinderModel.hasData(), isFalse);
    });

    test('hasData returns correct boolean value', () {
      expect(tinderModel.hasData(), isFalse);
      tinderModel.addRecipe("Description", "URL");
      expect(tinderModel.hasData(), isTrue);
    });
  });

  group('TinderModel Error Handling Tests', () {
    late TinderModel tinderModel;

    setUp(() {
      tinderModel = TinderModel();
    });

    test('Adding a recipe with empty values throws FormatException', () {
      expect(() => tinderModel.addRecipe("", ""), throwsFormatException);
    });

    test('Adding a recipe with an empty description throws FormatException',
        () {
      expect(
          () => tinderModel.addRecipe("", "validUrl"), throwsFormatException);
    });

    test('Adding a recipe with an empty image URL throws FormatException', () {
      expect(() => tinderModel.addRecipe("validDescription", ""),
          throwsFormatException);
    });

    test('Removing a recipe when none exist does not throw', () {
      expect(tinderModel.removeCurrentRecipe, returnsNormally);
    });

    test('Getting a recipe description when none exist returns an empty string',
        () {
      expect(tinderModel.getRecipeDescription(), "");
    });

    test('Getting a recipe image when none exist returns an empty string', () {
      expect(tinderModel.getRecipeImage(), "");
    });

    test(
        'State remains consistent after attempting to add recipes with empty values',
        () {
      // Attempt to add recipes with empty values
      expect(() => tinderModel.addRecipe("", ""), throwsFormatException);
      expect(() => tinderModel.addRecipe("validDescription", ""),
          throwsFormatException);
      expect(
          () => tinderModel.addRecipe("", "validUrl"), throwsFormatException);

      // Check the state of the model
      expect(tinderModel.hasData(), isFalse);
      expect(tinderModel.getRecipeDescription(), "");
      expect(tinderModel.getRecipeImage(), "");
    });
  });
}
