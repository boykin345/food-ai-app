import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/TinderMVC/tinder_controller.dart';
import 'package:mockito/mockito.dart';
import 'package:food_ai_app/API/image_fetcher_mock.dart';
import 'package:food_ai_app/API/chatgpt_recipe_mock.dart';

class MockChatGPTRecipeInterface extends Mock implements ChatGPTRecipeInterface {}
class MockImageFetcherInterface extends Mock implements ImageFetcherInterface {}

void main() {
  group('TinderController Tests', () {
    late TinderModel tinderModel;
    late ChatGPTRecipeMock mockChatGPTRecipeInterface;
    late ImageFetcherMock mockImageFetcherInterface;
    late TinderController tinderController;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      tinderModel = TinderModel();
      mockChatGPTRecipeInterface = ChatGPTRecipeMock("");
      mockImageFetcherInterface = ImageFetcherMock();
      tinderController = TinderController(
          tinderModel, mockChatGPTRecipeInterface, mockImageFetcherInterface);
    });

    test('initialize() populates model with recipes and images', () async {

      await tinderController.fetchRecipes();


      expect(tinderModel.hasData(), isTrue);


      expect(tinderModel.getRecipeDescription(), equals(mockChatGPTRecipeInterface.DESCRIPTION_0));


      final imageBase64 = await tinderModel.getRecipeImage();
      expect(imageBase64, isNotEmpty);

    });

    test('changeRecipe() removes current recipe and fetches new one', () async {

      await tinderController.fetchRecipes();


      final initialRecipeDescription = tinderModel.getRecipeDescription();
      final initialRecipeImage = tinderModel.getRecipeImage();


      await tinderController.changeRecipe();


      final updatedRecipeDescription = tinderModel.getRecipeDescription();
      final updatedRecipeImage = tinderModel.getRecipeImage();


      expect(updatedRecipeDescription, isNot(equals(initialRecipeDescription)));
      expect(updatedRecipeImage, isNot(equals(initialRecipeImage)));
    });


    test('Model is empty before initialization', () {
      expect(tinderModel.hasData(), isFalse);
    });

    test('fetchRecipes adds new recipe and image to model', () async {
      await tinderController.fetchRecipes();


      expect(tinderModel.hasData(), isTrue);

      expect(tinderModel.getRecipeDescription(), contains("Ingredients"));

      expect(tinderModel.getRecipeImage(), isNotEmpty);
    });

    test('changeRecipe does not throw when there is no data', () async {
      expect(tinderModel.hasData(), isFalse);
      expect(() async => await tinderController.changeRecipe(), returnsNormally);
    });


    test('fetchRecipes adds new recipe and image to model', () async {

      await tinderController.fetchRecipes();

      expect(tinderModel.hasData(), isTrue);
      expect(tinderModel.getRecipeDescription(), isNotNull);
      expect(tinderModel.getRecipeImage(), isNotNull);
    });

    test('initialize() successfully initializes model with data', () async {

      expect(tinderModel.hasData(), isFalse);


      await tinderController.initialize();


      expect(tinderModel.hasData(), isTrue);
    });

    test('createView() returns a TinderView with correct model and callback', () {

      final view = tinderController.createView();


      expect(view.model, equals(tinderModel));


      expect(view.onChangeRecipe, isNotNull);
    });

    test('initRecipes() successfully fetches and adds recipes and images to model', () async {

      expect(tinderModel.hasData(), isFalse);

      await tinderController.initRecipes();

      expect(tinderModel.hasData(), isTrue);

      expect(tinderModel.getRecipeDescription(), isNotNull);
      expect(tinderModel.getRecipeImage(), isNotNull);
    });


  });
}