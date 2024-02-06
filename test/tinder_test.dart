import 'package:flutter_test/flutter_test.dart';

import 'package:food_ai_app/api_mock.dart';
import 'package:food_ai_app/tinder_controller.dart';
import 'package:food_ai_app/tinder_model.dart';
import 'package:food_ai_app/tinder_view.dart';

// I - Unit tests for the TinderModel, TinderView and TinderController classes
void main() {
  final String DESCRIPTION_0 = '''
Fish and Chips

  Ingredients:

  4 large potatoes, peeled and cut into strips
  4 fish fillets (cod, haddock, or pollock)
  1 cup flour, plus extra for dusting
  1 cup beer (or sparkling water)
  2 teaspoons baking powder
  Salt and pepper to taste
  Oil for frying
  Instructions:

  Heat oil in a deep fryer or large pot to 365°F (185°C).
  Pat the fish dry and season with salt and pepper. Dust lightly with flour.
  In a bowl, mix 1 cup flour, baking powder, salt, and pepper. Gradually mix in beer until a smooth batter is formed.
  Dip fish fillets into the batter, coating them completely.
  Fry the potatoes in batches until golden and crispy. Drain on paper towels.
  Fry the battered fish until golden brown and crispy, about 4-5 minutes. Drain on paper towels.
  Serve fish with chips and your choice of dipping sauce.''';

  final String DESCRIPTION_3 = '''
  Full English Breakfast

Ingredients:

2 sausages
2 slices of bacon
2 eggs
1 tomato, halved
1 cup mushrooms, sliced
1 can baked beans
2 slices of bread, toasted
Butter, for frying and spreading
Instructions:

Fry sausages and bacon until cooked through and golden brown.
Fry eggs to your liking in the same pan.
Sauté tomatoes and mushrooms in butter.
Heat baked beans in a pot.
Serve everything hot with toasted bread.
''';

  final String DESCRIPTION_4 = '''
  Sticky Toffee Pudding 

Ingredients:

1 cup dates, pitted and chopped
1 teaspoon baking soda
1 cup boiling water
1/4 cup butter
3/4 cup sugar
2 eggs
1 and 1/4 cups flour
1 teaspoon vanilla extract
For the sauce:
1 cup brown sugar
1/2 cup butter
1/2 cup cream
1 teaspoon vanilla extract
Instructions:

Preheat oven to 350°F (175°C). Grease a baking dish.
Pour boiling water over dates and baking soda. Let stand for 20 minutes.
Cream butter and sugar. Add eggs and vanilla, then fold in flour.
Stir in date mixture. Pour into baking dish.
Bake for 30-35 minutes, until set.
For the sauce, combine all ingredients in a pan. Bring to a boil, stirring, until thickened.
Pour sauce over warm pudding before serving.
''';

  final String DESCRIPTION_5 = '''
  Meat and Vegetable Pie

Ingredients:

1 lb ground beef or lamb
1 onion, finely chopped
2 carrots, diced
1 cup frozen peas
2 tablespoons tomato paste
1 cup beef or vegetable broth
1 teaspoon Worcestershire sauce
Salt and pepper to taste
1 package puff pastry or shortcrust pastry, thawed
1 egg, beaten (for egg wash)
Instructions:

Preheat your oven to 400°F (200°C).
Cook the meat: In a large skillet over medium heat, cook the ground beef or lamb until browned. Drain excess fat.
Add vegetables: Stir in the onion and carrots, cooking until they begin to soften, about 5 minutes. Add the frozen peas and cook for another couple of minutes.
Add flavor: Stir in the tomato paste, beef or vegetable broth, Worcestershire sauce, salt, and pepper. Bring to a simmer and cook until the sauce thickens, about 10 minutes.
Prepare the pastry: On a floured surface, roll out the pastry to fit the size of your pie dish, with extra for covering the top.
Assemble the pie: Spoon the meat and vegetable mixture into a pie dish. Cover with the rolled-out pastry, sealing the edges by crimping with a fork. Make a few slits in the top of the pastry to allow steam to escape. Brush the top with beaten egg to give it a golden color.
Bake: Place the pie in the preheated oven and bake for about 25-30 minutes, or until the pastry is golden brown and crisp.
Serve: Let the pie cool for a few minutes before serving. This dish is perfect with a side of mashed potatoes or a simple green salad.
''';

  MockApiClient? apiClient;
  TinderModel? tinderModel;
  TinderView? tinderView;
  TinderController? tinderController;

  // Add async to setUp method and flutter binding
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Initialize new instances before each test
    apiClient = MockApiClient();
    tinderModel = TinderModel();
    tinderController = TinderController(tinderModel!, tinderView!, apiClient!);
    await tinderController!.initialize();
  });

  group("Check index variable", () {
    test("Index initialised correctly", () async {
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
      expect(tinderModel?.getRecipeDescription(), DESCRIPTION_0);
    });

    test("getRecipeImage gets images correctly when initialised", () async {
      apiClient?.count = 0;
      final imageUrl = await apiClient?.fetchImage();
      expect(tinderModel?.getRecipeImage(), imageUrl);
    });

    test("addRecipe handles null values correctly", () {
      expect(() => tinderModel?.addRecipe("", ""), throwsFormatException);
    });
  });

  group("Check TinderController methods", () {
    test("TinderController fetchRecipes updates both lists correctly",
        () async {
      await tinderController?.changeRecipe();
      expect(tinderModel?.getIndex(), 1);
      await tinderController?.changeRecipe();
      expect(tinderModel?.getIndex(), 2);
      await tinderController?.changeRecipe();
      expect(tinderModel?.getIndex(), 0);

      apiClient?.count = 3;
      final imageUrl1 = await apiClient?.fetchImage();
      expect(tinderModel?.getRecipeDescription(), DESCRIPTION_3);
      expect(tinderModel?.getRecipeImage(), imageUrl1);
      tinderModel?.incrementIndex();

      apiClient?.count = 4;
      final imageUrl2 = await apiClient?.fetchImage();
      expect(tinderModel?.getRecipeDescription(), DESCRIPTION_4);
      expect(tinderModel?.getRecipeImage(), imageUrl2);
      tinderModel?.incrementIndex();

      apiClient?.count = 4;
      final imageUrl3 = await apiClient?.fetchImage();
      expect(tinderModel?.getRecipeDescription(), DESCRIPTION_5);
      expect(tinderModel?.getRecipeImage(), imageUrl3);
      tinderModel?.incrementIndex();
    });

    test(
        "TinderController changeRecipe adds items to relevant lists correctly after index crosses THREAD_COUNT",
        () async {
      await tinderController?.changeRecipe();
      await tinderController?.changeRecipe();
      await tinderController?.changeRecipe();

      apiClient?.count = 3;
      final imageUrl = await apiClient?.fetchImage();
      expect(tinderModel?.getRecipeDescription(), DESCRIPTION_3);
      expect(tinderModel?.getRecipeImage(), imageUrl);
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
