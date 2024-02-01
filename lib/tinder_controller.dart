import 'package:food_ai_app/tinder_model.dart';
import 'package:food_ai_app/tinder_view.dart';
import 'package:food_ai_app/api_mock.dart';

class TinderController {
  TinderModel model;
  TinderView view;
  MockApiClient apiClient;
  final int THREAD_COUNT = 3;

  TinderController(this.model, this.view, this.apiClient) {
    fetchRecipes();
  }

  void fetchRecipes() {
    for (int i = 0; i < THREAD_COUNT; i++) {
      model.addRecipe(apiClient.fetchDescription(), apiClient.fetchImage());
      apiClient.incrementCounter();
    }
    model.resetIndex();
  }

  void changeRecipe() {
    if (model.getIndex() >= THREAD_COUNT - 1) {
      model.resetIndex();
      fetchRecipes();
      return;
    }
    //refresh-view
    model.incrementIndex();
  }
}
