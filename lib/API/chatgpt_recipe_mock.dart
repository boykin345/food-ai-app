import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';

/// A mock implementation of [ChatGPTRecipeInterface] for testing purposes.
/// Provides pre-defined recipe descriptions without making actual API calls.
class ChatGPTRecipeMock extends ChatGPTRecipeInterface {
  /// Counter to cycle through mock recipe descriptions.
  int count = 0;

  /// Mock recipe descriptions.
  final String description0 = '''
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

  final String description1 = '''
Shepherd's Pie

Ingredients:

1 lb ground lamb (or beef for Cottage Pie)
1 onion, chopped
2 carrots, diced
1 cup frozen peas
2 tablespoons tomato paste
1 cup beef broth
2 lbs potatoes, peeled and boiled
1/4 cup butter
1/2 cup milk
Salt and pepper to taste
Instructions:

Preheat oven to 400°F (200°C).
In a skillet, cook lamb, onion, and carrots until meat is browned. Drain fat.
Stir in peas, tomato paste, and beef broth. Simmer until thickened.
Mash the boiled potatoes with butter and milk until smooth. Season with salt and pepper.
Spread the meat mixture in a baking dish. Top with mashed potatoes.
Bake for 20-25 minutes, or until the top is golden brown.
''';

  final String description2 = '''
Beef Wellington

Ingredients:

2 lb beef tenderloin
2 tablespoons olive oil
1 lb mushrooms, finely chopped
2 tablespoons mustard (Dijon preferred)
1 package puff pastry, thawed
1 egg, beaten
Salt and pepper to taste
Instructions:

Preheat oven to 425°F (220°C).
Sear beef in hot oil until browned on all sides. Let cool, then brush with mustard.
Sauté mushrooms until their moisture evaporates.
Roll out puff pastry. Place beef in the center and top with mushrooms.
Wrap pastry around beef, sealing edges. Brush with beaten egg.
Bake for 25-30 minutes, or until pastry is golden. Let rest before slicing.
''';

  final String description3 = '''
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

  final String description4 = '''
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

  final String description5 = '''
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

  /// The API key for demonstration purposes; not used in the mock.
  final String apiKey;

  /// Constructs a [ChatGPTRecipeMock] instance with an optional [apiKey].
  ChatGPTRecipeMock(this.apiKey);

  /// Increments the counter to cycle through the mock descriptions.
  /// Resets to 0 if it exceeds the number of available descriptions.
  void incrementCounter() {
    if (count >= 6) {
      count = -1;
    }
    count++;
  }

  /// Returns a mock recipe description based on the current value of [count].
  /// Simulates a delay to mimic asynchronous network request behavior.
  @override
  Future<String> fetchRecipe() async {
    String description;
    switch (count) {
      case 0:
        description = description0;
      case 1:
        description = description1;
      case 2:
        description = description2;
      case 3:
        description = description3;
      case 4:
        description = description4;
      case 5:
        description = description5;
      default:
        description = "Description not found";
        break;
    }

    incrementCounter();
    return Future.delayed(Duration(seconds: 4), () => description);
  }
}
