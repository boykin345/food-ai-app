import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/TinderMVC/tinder_controller.dart';
import 'package:mockito/mockito.dart';

class MockChatGPTRecipeInterface extends Mock implements ChatGPTRecipeInterface {}
class MockImageFetcherInterface extends Mock implements ImageFetcherInterface {}

void main() {
  group('TinderController Tests', () {
    late TinderModel tinderModel;
    late MockChatGPTRecipeInterface mockChatGPTRecipeInterface;
    late MockImageFetcherInterface mockImageFetcherInterface;
    late TinderController tinderController;

    setUp(() {
      tinderModel = TinderModel();
      mockChatGPTRecipeInterface = MockChatGPTRecipeInterface();
      mockImageFetcherInterface = MockImageFetcherInterface();
      tinderController = TinderController(tinderModel, mockChatGPTRecipeInterface, mockImageFetcherInterface);
    });

    test('initialize() populates model with recipes and images', () async {
      when(mockChatGPTRecipeInterface.fetchRecipe()).thenAnswer((_) => Future.value("Test Recipe"));
      when(mockImageFetcherInterface.fetchImage('fake_url')).thenAnswer((_) async => "Test Image URL");

      await tinderController.initialize();

      expect(tinderModel.hasData(), isTrue);
      expect(tinderModel.getRecipeDescription(), contains("Test Recipe"));
      expect(tinderModel.getRecipeImage(), equals("Test Image URL"));
    });

    test('changeRecipe() removes current recipe and fetches new one', () async {
      tinderModel.addRecipe("Initial Recipe", "Initial URL");

      when(mockChatGPTRecipeInterface.fetchRecipe()).thenAnswer((_) => Future.value("New Recipe"));
      when(mockImageFetcherInterface.fetchImage('fake_url')).thenAnswer((_) async => "Test Image URL");

      await tinderController.changeRecipe();

      expect(tinderModel.getRecipeDescription(), equals("New Recipe"));
      expect(tinderModel.getRecipeImage(), equals("New Image URL"));
    });


    test('Model is empty before initialization', () {
      expect(tinderModel.hasData(), isFalse);
    });

    test('refreshView callback is called after initialization', () async {
      bool callbackCalled = false;
      tinderController.onModelUpdated = () {
        callbackCalled = true;
      };

      when(mockChatGPTRecipeInterface.fetchRecipe()).thenAnswer((_) => Future.value("Test Recipe"));
      when(mockImageFetcherInterface.fetchImage('fake_url')).thenAnswer((_) async => "Test Image URL");

      await tinderController.initialize();

      expect(callbackCalled, isTrue);
    });

    test('changeRecipe does not throw when there is no data', () async {
      expect(tinderModel.hasData(), isFalse);
      expect(() async => await tinderController.changeRecipe(), returnsNormally);
    });


    test('fetchRecipes adds new recipe and image to model', () async {

      when(mockChatGPTRecipeInterface.fetchRecipe()).thenAnswer((_) => Future.value("Fetched Recipe"));
      when(mockImageFetcherInterface.fetchImage('fake_url')).thenAnswer((_) async => "Test Image URL");
      await tinderController.fetchRecipes();


      expect(tinderModel.hasData(), isTrue);
      expect(tinderModel.getRecipeDescription(), equals("Fetched Recipe"));
      expect(tinderModel.getRecipeImage(), equals("Fetched Image URL"));
    });

  });
}