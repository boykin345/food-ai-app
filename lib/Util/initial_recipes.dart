import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_ai_app/Entities/recipe.dart';
import 'package:food_ai_app/Util/data_util.dart';

/// Initializes a set of predefined recipes for various meal categories.
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

  final Recipe garlicLemonHerbChicken = Recipe(
    recipeName: "Garlic Lemon Herb Chicken",
    calories: 550,
    prepTime: "25 minutes",
    difficulty: 2,
    ingredients: [
      "4 chicken breasts",
      "4 cloves garlic, minced",
      "1 lemon, juiced and zested",
      "2 tbsp olive oil",
      "1 tsp dried oregano",
      "1 tsp dried basil",
      "Salt and pepper to taste"
    ],
    instructions:
        "In a large bowl, combine garlic, lemon juice and zest, olive oil, oregano, and basil. Add chicken and marinate for at least 20 minutes. Preheat grill or skillet over medium-high heat. Cook chicken for 6-7 minutes on each side or until cooked through. Season with salt and pepper to taste. Serve hot.",
    category: "Main",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT6.webp?alt=media&token=536bc31b-1fc9-48a8-8fb7-8ebd6b96e161",
  );

  final Recipe beefStirFry = Recipe(
    recipeName: "Beef Stir Fry",
    calories: 600,
    prepTime: "20 minutes",
    difficulty: 3,
    ingredients: [
      "2 tbsp vegetable oil",
      "1 lb beef, thinly sliced",
      "1 bell pepper, sliced",
      "1 onion, sliced",
      "2 tbsp soy sauce",
      "1 tbsp oyster sauce",
      "1 tsp cornstarch",
      "Salt and pepper to taste"
    ],
    instructions:
        "Heat oil in a large skillet over high heat. Add beef and cook until browned. Remove beef. In the same skillet, add bell pepper and onion, cook for 2-3 minutes. Return beef to the skillet. In a small bowl, mix soy sauce, oyster sauce, and cornstarch, then pour over the beef and vegetables. Stir fry for another 2 minutes. Season with salt and pepper to taste.",
    category: "Main",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT7.webp?alt=media&token=646a75e4-f51b-4049-b75f-ec406f398949",
  );

  final Recipe creamyPasta = Recipe(
    recipeName: "Creamy Garlic Parmesan Pasta",
    calories: 700,
    prepTime: "30 minutes",
    difficulty: 2,
    ingredients: [
      "8 oz pasta",
      "2 tbsp butter",
      "4 cloves garlic, minced",
      "1 cup heavy cream",
      "1 cup grated Parmesan cheese",
      "1 tbsp parsley, chopped",
      "Salt and pepper to taste"
    ],
    instructions:
        "Cook pasta according to package instructions; drain and set aside. In a saucepan, melt butter over medium heat. Add garlic and cook for 2 minutes. Add heavy cream and bring to a simmer. Stir in Parmesan cheese until melted and sauce is creamy. Toss in pasta and coat with the sauce. Season with salt and pepper to taste. Garnish with parsley before serving.",
    category: "Main",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT8.webp?alt=media&token=087473ff-1ca0-42d5-a70a-0f3af3ddf481",
  );

  final Recipe oatmealBerryBowl = Recipe(
    recipeName: "Oatmeal Berry Breakfast Bowl",
    calories: 350,
    prepTime: "10 minutes",
    difficulty: 1,
    ingredients: [
      "1 cup rolled oats",
      "2 cups almond milk",
      "1/2 cup mixed berries",
      "1 tbsp honey",
      "1/4 cup chopped nuts",
      "Pinch of salt"
    ],
    instructions:
        "In a medium saucepan, bring the almond milk to a boil. Add the rolled oats and a pinch of salt, then reduce heat and simmer for 5 minutes, stirring occasionally. Remove from heat and let sit for 2 minutes. Serve in a bowl topped with mixed berries, chopped nuts, and a drizzle of honey.",
    category: "Breakfast",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT9.webp?alt=media&token=761cda89-d9b7-4873-a652-43f71dbbf74b",
  );

  final Recipe spinachFetaOmelette = Recipe(
    recipeName: "Spinach and Feta Omelette",
    calories: 400,
    prepTime: "15 minutes",
    difficulty: 2,
    ingredients: [
      "3 eggs",
      "1/2 cup spinach, chopped",
      "1/4 cup feta cheese, crumbled",
      "1 tbsp olive oil",
      "Salt and pepper to taste"
    ],
    instructions:
        "Beat the eggs in a bowl. Heat the olive oil in a frying pan over medium heat. Add the beaten eggs, tilting the pan to spread them evenly. Once the eggs begin to set, add the spinach and feta cheese on one half of the omelette. Fold the other half over the filling. Cook until the cheese melts. Season with salt and pepper to taste.",
    category: "Breakfast",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT10.webp?alt=media&token=8eff8be0-b62d-4acd-9607-cc297d4390f9",
  );

  final Recipe bananaPeanutButterSmoothie = Recipe(
    recipeName: "Banana Peanut Butter Smoothie",
    calories: 300,
    prepTime: "5 minutes",
    difficulty: 1,
    ingredients: [
      "2 ripe bananas",
      "2 tbsp peanut butter",
      "1 cup Greek yogurt",
      "1/2 cup milk",
      "1 tbsp honey",
      "Ice cubes"
    ],
    instructions:
        "Combine all the ingredients in a blender. Blend until smooth. Serve immediately.",
    category: "Breakfast",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT11.webp?alt=media&token=3501d3fe-2b34-4060-b59f-0b598d9b0e1d",
  );

  final Recipe chocolateBrownies = Recipe(
    recipeName: "Chocolate Brownies",
    calories: 450,
    prepTime: "35 minutes",
    difficulty: 3,
    ingredients: [
      "1/2 cup unsalted butter",
      "1 cup sugar",
      "2 eggs",
      "1 tsp vanilla extract",
      "1/3 cup unsweetened cocoa powder",
      "1/2 cup all-purpose flour",
      "1/4 tsp salt",
      "1/4 tsp baking powder"
    ],
    instructions:
        "Preheat oven to 350°F (175°C). Grease and flour an 8-inch square pan. In a medium bowl, mix melted butter, sugar, eggs, and vanilla. Beat in cocoa, flour, salt, and baking powder. Spread batter into prepared pan. Bake in preheated oven for 25 to 30 minutes. Do not overcook. Allow to cool before cutting into squares.",
    category: "Desserts",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT12.webp?alt=media&token=e486ef28-3719-441f-a428-db40dbedc244",
  );

  final Recipe lemonCheesecake = Recipe(
    recipeName: "Lemon Cheesecake",
    calories: 600,
    prepTime: "45 minutes",
    difficulty: 4,
    ingredients: [
      "1 cup graham cracker crumbs",
      "4 tbsp unsalted butter, melted",
      "2 tbsp sugar",
      "3 (8 oz) packages cream cheese, softened",
      "1 cup sugar",
      "3 tbsp all-purpose flour",
      "3 eggs",
      "1 tbsp lemon zest",
      "1/4 cup lemon juice"
    ],
    instructions:
        "Preheat oven to 325°F (165°C). Mix graham cracker crumbs, melted butter, and sugar; press onto bottom of a 9-inch springform pan. In a large bowl, mix cream cheese, sugar, and flour until smooth. Add eggs one at a time, mixing on low speed after each just until blended. Stir in lemon zest and lemon juice. Pour over crust. Bake 55 minutes or until center is almost set. Cool before removing rim of pan. Refrigerate 4 hours.",
    category: "Desserts",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT13.webp?alt=media&token=2ba57045-147b-431b-a0c8-838cf5f8105b",
  );

  final Recipe appleCrisp = Recipe(
    recipeName: "Apple Crisp",
    calories: 500,
    prepTime: "1 hour",
    difficulty: 2,
    ingredients: [
      "10 cups all-purpose apples, peeled, cored, and sliced",
      "1 cup sugar",
      "1 tbsp all-purpose flour",
      "1 tsp ground cinnamon",
      "1/2 cup water",
      "1 cup quick-cooking oats",
      "1 cup all-purpose flour",
      "1 cup packed brown sugar",
      "1/4 tsp baking powder",
      "1/4 tsp baking soda",
      "1/2 cup unsalted butter, melted"
    ],
    instructions:
        "Preheat oven to 350°F (175°C). Place the sliced apples in a 9x13 inch pan. Mix the sugar, 1 tablespoon flour, and ground cinnamon together, and sprinkle over apples. Pour water evenly over all. Combine the oats, 1 cup flour, brown sugar, baking powder, baking soda, and melted butter together. Crumble evenly over the apple mixture. Bake for about 45 minutes.",
    category: "Desserts",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT14.webp?alt=media&token=6edbd23b-3667-411c-94bf-788df1dea843",
  );

  final Recipe garlicMashedPotatoes = Recipe(
    recipeName: "Garlic Mashed Potatoes",
    calories: 300,
    prepTime: "45 minutes",
    difficulty: 2,
    ingredients: [
      "2 lbs potatoes, peeled and quartered",
      "4 cloves garlic, minced",
      "1/2 cup milk",
      "1/4 cup butter",
      "Salt and pepper to taste"
    ],
    instructions:
        "In a large pot, bring salted water to a boil. Add potatoes and cook until tender, about 15 minutes. In a small saucepan, heat the butter and milk over low heat until the butter is melted. Drain the potatoes and return them to the pot. Add the garlic, milk, and butter. Mash the potatoes using a potato masher or an electric beater until smooth. Season with salt and pepper to taste.",
    category: "Side-Dishes",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT15.webp?alt=media&token=fdcea76d-11d1-4641-aa8c-5ac5d6882157",
  );

  final Recipe roastedBrusselsSprouts = Recipe(
    recipeName: "Roasted Brussels Sprouts",
    calories: 250,
    prepTime: "40 minutes",
    difficulty: 2,
    ingredients: [
      "1.5 lbs Brussels sprouts, ends trimmed and halved",
      "3 tbsp olive oil",
      "1 tsp salt",
      "1/2 tsp ground black pepper"
    ],
    instructions:
        "Preheat oven to 400°F (205°C). Place the trimmed Brussels sprouts, olive oil, salt, and pepper in a large bowl. Toss to coat. Spread on a baking sheet in a single layer. Roast in the preheated oven for 30 to 35 minutes, shaking pan every 5 to 7 minutes for even browning. Remove from oven, and serve immediately.",
    category: "Side-Dishes",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT16.webp?alt=media&token=3e6c431c-81c4-4b70-9290-2bce5952ec7e",
  );

  final Recipe quinoaSalad = Recipe(
    recipeName: "Quinoa Salad",
    calories: 320,
    prepTime: "20 minutes",
    difficulty: 1,
    ingredients: [
      "1 cup quinoa",
      "2 cups water",
      "1/4 cup red bell pepper, chopped",
      "1/4 cup yellow bell pepper, chopped",
      "1/4 cup cucumber, chopped",
      "1/4 cup red onion, chopped",
      "1/4 cup feta cheese, crumbled",
      "2 tbsp olive oil",
      "2 tbsp lemon juice",
      "Salt and pepper to taste"
    ],
    instructions:
        "Rinse the quinoa under cold running water. In a medium saucepan, combine quinoa and water. Bring to a boil, reduce heat to low, cover, and simmer for 15 minutes or until quinoa is fluffy and water is absorbed. In a large bowl, combine the cooked quinoa, red bell pepper, yellow bell pepper, cucumber, red onion, and feta cheese. In a small bowl, whisk together olive oil and lemon juice, then pour over the salad. Toss to coat. Season with salt and pepper to taste.",
    category: "Side-Dishes",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT17.webp?alt=media&token=aaf9f838-eb4a-48f5-bd0a-82627beaba90",
  );

  final Recipe tomatoBasilPasta = Recipe(
    recipeName: "Tomato Basil Pasta",
    calories: 400,
    prepTime: "20 minutes",
    difficulty: 1,
    ingredients: [
      "8 oz pasta",
      "2 cups cherry tomatoes, halved",
      "3 cloves garlic, minced",
      "1/4 cup fresh basil, chopped",
      "2 tbsp olive oil",
      "Salt and pepper to taste",
      "1/4 cup grated Parmesan cheese"
    ],
    instructions:
        "Cook pasta according to package instructions; drain and set aside. In a large skillet, heat the olive oil over medium heat. Add the garlic and cook until fragrant, about 1 minute. Add the cherry tomatoes and cook until they are soft, about 5 minutes. Toss in the cooked pasta and chopped basil. Season with salt and pepper to taste. Garnish with grated Parmesan cheese before serving.",
    category: "Lunch",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT18.webp?alt=media&token=402e43e3-26e8-4a5a-ba45-da6cd5240c2a",
  );

  final Recipe chickenCaesarWrap = Recipe(
    recipeName: "Chicken Caesar Wrap",
    calories: 500,
    prepTime: "15 minutes",
    difficulty: 2,
    ingredients: [
      "2 large flour tortillas",
      "2 cooked chicken breasts, sliced",
      "1/4 cup Caesar dressing",
      "2 cups romaine lettuce, chopped",
      "1/4 cup Parmesan cheese, shredded",
      "Salt and pepper to taste"
    ],
    instructions:
        "Lay out the flour tortillas on a flat surface. Spread the Caesar dressing evenly over each tortilla. Layer the chopped romaine lettuce, cooked chicken slices, and shredded Parmesan cheese on top of each tortilla. Season with salt and pepper to taste. Roll up the tortillas tightly, then cut in half to serve.",
    category: "Lunch",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT19.webp?alt=media&token=98a67b16-fa1f-4e77-8e83-3611f75d7870",
  );

  final Recipe veggieQuinoaBowl = Recipe(
    recipeName: "Veggie Quinoa Bowl",
    calories: 450,
    prepTime: "30 minutes",
    difficulty: 2,
    ingredients: [
      "1 cup quinoa",
      "2 cups vegetable broth",
      "1 avocado, sliced",
      "1/2 cup cherry tomatoes, halved",
      "1/2 cup cucumber, diced",
      "1/4 cup red onion, finely chopped",
      "1/4 cup feta cheese, crumbled",
      "2 tbsp olive oil",
      "1 tbsp lemon juice",
      "Salt and pepper to taste"
    ],
    instructions:
        "In a medium saucepan, bring the vegetable broth to a boil. Add quinoa and reduce heat to low. Cover and simmer for 15-20 minutes, or until all liquid is absorbed. Remove from heat and let sit for 5 minutes; fluff with a fork. In a large bowl, combine the cooked quinoa, avocado, cherry tomatoes, cucumber, and red onion. In a small bowl, whisk together the olive oil and lemon juice, then pour over the quinoa mixture. Toss to combine. Season with salt and pepper to taste. Garnish with crumbled feta cheese before serving.",
    category: "Lunch",
    imageURL:
        "https://firebasestorage.googleapis.com/v0/b/bjss-food-ai.appspot.com/o/images%2FT20.webp?alt=media&token=616d3f57-29b2-4bf3-bff7-478084185763",
  );
}
