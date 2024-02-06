import 'package:food_ai_app/tinder_model.dart';
import 'package:food_ai_app/tinder_view.dart';
import 'package:food_ai_app/api_mock.dart';

class TinderController {
  TinderModel model;
  TinderView view;
  MockApiClient apiClient;
  final int THREAD_COUNT = 3;

  TinderController(this.model, this.view, this.apiClient);

  // Moved initialisation out of constructor to use async feature
  Future<void> initialize() async {
    await fetchRecipes();
  }

  // Add async to method
  Future<void> fetchRecipes() async {
    for (int i = 0; i < THREAD_COUNT; i++) {
      final String description = apiClient.fetchDescription();
      final String image = await apiClient.fetchImage();
      model.addRecipe(description, image);
      apiClient.incrementCounter();
    }
    model.resetIndex();
  }

  // Add async to method
  Future<void> changeRecipe() async {
    if (model.getIndex() >= THREAD_COUNT - 1) {
      model.resetIndex();
      await fetchRecipes();
      model.resetIndex();
      return;
    }
    //refresh-view
    model.incrementIndex();
  }
}
