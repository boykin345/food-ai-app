/// A class that simulates a database of mock ingredients.
///
/// This class contains a predefined list of ingredients with their respective quantities
/// typically used for demonstration or testing in a development environment.
class MockIngredients {
  /// A map representing a collection of ingredient names and their corresponding quantities.
  ///
  /// The map includes a variety of common kitchen ingredients such as vegetables, fruits, and dairy products
  /// with predefined quantities to simulate a realistic scenario.
  Map<String, String> items = {
    'Tomatoes': '10',
    'Eggs': '16',
    'Red Bell Pepper': '1',
    'Yellow Bell Pepper': '1',
    'Lettuce': '2',
    'Cabbage': '1',
    'Strawberries': '1 pack',
    'Grapes': '1 bunch',
    'Lemon': '2',
    'Lime': '3',
    'Orange': '1',
    'Carrots': '4',
    'Bananas': '5',
    'Bell Pepper': '1 pack',
    'Sauce bottles': '2',
    'Juice bottles': '2',
    'Milk containers': '2',
    'Sliced bread pack': '1',
    'Cheese slices pack': '1',
    'Yogurt or dessert pack': '1',
    'Delimeat pack': '1',
    'Sandwich spread or cheese tub': '1',
    'Pickles jar': '1',
  };

  /// Retrieves the map of mock ingredients.
  ///
  /// This method returns a copy of the current map of ingredients and their quantities.
  /// It can be used to initialize or reset the ingredient list in user interfaces or testing scenarios.
  Map<String, String> getMap() {
    return items;
  }
}
