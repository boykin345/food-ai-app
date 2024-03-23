import 'package:food_ai_app/Entities/recipe.dart';

class RecipeInitialiser {
  // Breakfast
  final Recipe frenchToast = Recipe(
    recipeName: "Classic French Toast",
    calories: 350,
    prepTime: "20 minutes",
    difficulty: 2,
    ingredients: [
      "4 slices of bread",
      "2 eggs",
      "1/2 cup of milk",
      "1 tsp vanilla extract",
      "1 tsp cinnamon",
      "2 tbsp butter",
      "Maple syrup"
    ],
    instructions:
        "In a large bowl, beat the eggs, milk, vanilla extract, and cinnamon. Dip each slice of bread into the egg mixture, allowing bread to soak up some of the mixture. Melt butter over a large skillet on medium heat. Add bread slices to skillet and cook until golden brown on each side. Serve with maple syrup.",
    category: "Breakfast",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT1.webp?alt=media&token=de984f18-5e99-4649-9fa7-76d04d86883f",
  );

  // Main
  final Recipe pestoChicken = Recipe(
    recipeName: "Grilled Chicken Pesto Pasta",
    calories: 650,
    prepTime: "45 minutes",
    difficulty: 3,
    ingredients: [
      "2 boneless chicken breasts",
      "2 cups of pasta",
      "1/4 cup pesto sauce",
      "1 tbsp olive oil",
      "Salt and pepper",
      "Grated Parmesan cheese"
    ],
    instructions:
        "Grill the chicken breasts seasoned with salt and pepper until fully cooked. Boil the pasta as per the instructions on the packet. In a bowl, mix the cooked pasta, grilled chicken (cut into slices), and pesto sauce. Serve with a sprinkle of Parmesan cheese.",
    category: "Main",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT2.webp?alt=media&token=6af3e8cf-ea82-4895-8d48-61ef02042f29",
  );

  // Desserts
  final Recipe lavaCake = Recipe(
    recipeName: "Chocolate Lava Cake",
    calories: 450,
    prepTime: "30 minutes",
    difficulty: 4,
    ingredients: [
      "100g dark chocolate",
      "100g butter",
      "150g powdered sugar",
      "2 eggs",
      "2 egg yolks",
      "100g flour"
    ],
    instructions:
        "Preheat the oven to 220°C. Melt the chocolate and butter in a microwave. Beat the eggs and egg yolks with sugar until light and thick. Fold in the melted chocolate and flour. Pour into greased molds. Bake for 10-12 minutes. Serve immediately.",
    category: "Desserts",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT3.webp?alt=media&token=8c1e1efd-98cf-42a6-891c-1c28af97174a",
  );

  // Side-Dishes
  final Recipe roastedBroccoli = Recipe(
    recipeName: "Garlic Parmesan Roasted Broccoli",
    calories: 200,
    prepTime: "25 minutes",
    difficulty: 2,
    ingredients: [
      "2 heads of broccoli",
      "4 cloves of garlic, minced",
      "3 tbsp olive oil",
      "1/4 cup grated Parmesan cheese",
      "Salt and pepper to taste"
    ],
    instructions:
        "Preheat the oven to 400°F. Cut the broccoli into florets and toss with olive oil, garlic, salt, and pepper. Spread on a baking sheet and roast for 20 minutes, until crisp-tender and the edges are browned. Sprinkle with Parmesan cheese and serve.",
    category: "Side-Dishes",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT4.webp?alt=media&token=2c43493e-5546-424d-9742-058fe2bdcd1f",
  );

  //Lunch
  final Recipe chickenSalad = Recipe(
    recipeName: "Avocado Chicken Salad",
    calories: 500,
    prepTime: "15 minutes",
    difficulty: 2,
    ingredients: [
      "2 cooked chicken breasts, chopped",
      "2 ripe avocados",
      "1/2 cup corn",
      "1/4 cup cilantro, chopped",
      "2 tbsp lime juice",
      "Salt and pepper to taste"
    ],
    instructions:
        "In a large bowl, combine all the ingredients and gently stir until the avocado is slightly mashed and all the ingredients are well mixed. Season with salt and pepper to taste. Serve chilled.",
    category: "Lunch",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT5.webp?alt=media&token=16550fb1-b3fb-4608-9252-4f44bfae80f5",
  );
}
