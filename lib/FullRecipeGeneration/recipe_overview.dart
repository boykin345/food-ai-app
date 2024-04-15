import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_ai_app/FullRecipeGeneration/gpt_api_recipe.dart';
import 'package:food_ai_app/FullRecipeGeneration/gpt_api_recipe_mock.dart';

import '../Util/colours.dart';
import '../Util/custom_app_bar.dart';
import '../Util/customer_drawer.dart';

class RecipeOverview extends StatelessWidget {
   //store properties of recipe in separate variables such that they can be distinguished for recipe saving
  late String dishName = " ";
  String caloriesString = " ";
  int calories = 0;
  String cookingTime = " ";
  String difficultyString = " ";
  int difficulty = 0;
  String method = " ";
  String ingredients = " ";
  String category = " ";
  String imageLink;

  //create an instance of the gpt class that can be used to make api requests
  GPTRecipeApi gptRecipeApi = GPTRecipeApi('0f91ba9b74344d7699144a8afbeeae2b');
  MockGPTRecipeApi mockRecipeApi = MockGPTRecipeApi();

  //store the entire recipe
  String recipe = "";

  set image(String imageLink) {
    this.imageLink = imageLink;
  }

  String get image {
    return imageLink;
  }

  set name(String dishName) {
    this.dishName = dishName;
  }

  String get name {
    return dishName;
  }

  //method to request recipe and image from api
  Future<void> getDish() async {
    //request recipe
    recipe = await gptRecipeApi.getRecipe(dishName, false);
    //recipe = mockRecipeApi.recipeText;
  }

 //method to separate parts of the recipe
  void splitRecipe(String recipe)
  {
    //assign each part a number (in order)
    //0 - dish name
    //1 - difficulty
    //2 - cooking time
    //3 - category
    //4 - calories
    //5 - ingredients
    //6 - method

    //keep track of these with count variable
    int count = 0;
    //int to keep track where to start substrings from
    int startPoint = 0;

    //loop through string
    for (int i = 0; i < recipe.length; i++)
    {
        //check for double new line
        if (recipe[i] == '\n')
        {
          if (recipe[i + 1] == '\n')
          {
            //assign substring to variable
              switch(count)
              {
                case (0):
                  dishName = recipe.substring(startPoint, i - 1);
                case (1):
                  difficultyString = recipe.substring(startPoint, i - 1);
                case (2):
                  cookingTime = recipe.substring(startPoint, i - 1);
                case (3):
                   category = recipe.substring(startPoint, i - 1);
                case (4):
                  caloriesString = recipe.substring(startPoint, i - 1);
                case (5):
                  ingredients = recipe.substring(startPoint, i - 1);
                case (6):
                  method = recipe.substring(startPoint, i - 1);

              }
              //increment count and set start point for next substring
              count++;
              startPoint = i + 2;
          }
        }
    }
  }

  //method to save recipe
  Recipe saveRecipe()
  {
    try
    {
      difficulty = int.parse(difficultyString);
      calories = int.parse(caloriesString);
    }catch (exception)
    {
      throw Exception('Could not convert string to int');
    }
    final Recipe recipe = Recipe(recipeName: dishName, calories: calories, prepTime: cookingTime, difficulty: difficulty, ingredients: ingredients, instructions: method, category: category, imageURL: imageURL)
    return recipe;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        //set background colour of page
        backgroundColor: Colours.primary,

        //make page scrollable
        body: SingleChildScrollView(
          //create a container to hold elements
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //display name of dish at the top of the page
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  "You have chosen",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15.0),
              ),
              //display image of the dish
              Container(
                  width: 410,
                  height: 336,
                  //give the image rounded corners
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(42)),
                  child: Image.memory(
                    base64Decode(imageLink),
                    fit: BoxFit.contain,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15.0),
              ),

              //display the generated recipe to the screen
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 15.0),
                child: Text(
                  recipe,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 80.0,
                    left: 15.0,
                    bottom: 15), // Adds more space at the bottom of the page
              )
            ],
          ),
        )),floatingActionButton: FloatingActionButton(
            onPressed:()
            {
              splitRecipe(recipe);
              saveRecipe();
            },
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            child: Text("Save"));
  }
}