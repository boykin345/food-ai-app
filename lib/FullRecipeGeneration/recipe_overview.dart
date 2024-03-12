import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:food_ai_app/FullRecipeGeneration/gpt_api_recipe.dart';
import 'package:food_ai_app/FullRecipeGeneration/gpt_api_recipe_mock.dart';

void main()
{
  runApp(RecipeOverview());
}

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



  //create background colour
  Color back = const Color.fromARGB(255, 44,52,67,);

  //create an instance of the gpt class that can be used to make api requests
  GPTRecipeApi gptRecipeApi = GPTRecipeApi('46ac92c47cd344e48007ac50e31d7771');
  MockGPTRecipeApi mockRecipeApi = MockGPTRecipeApi();

  //store the entire recipe
  String recipe = " ";

  set name(String dishName) {
    this.dishName = dishName;
  }

  String get name {
    return dishName;
  }

  //method to request recipe and image from api
  Future<void> getDish() async {
    //request recipe
    recipe = await gptRecipeApi.getRecipe("Paella");
    //recipe = mockRecipeApi.recipeText;
  }

  //method to separate parts of the recipe
  void splitRecipe(String recipe)
  {
    //assign each part a number (in order)
    //0 - dish name
    //1 - difficulty
    //2 - cooking time
    //3 - calories
    //4 - ingredients
    //5 - method

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
                  caloriesString = recipe.substring(startPoint, i - 1);
                case (4):
                  ingredients = recipe.substring(startPoint, i - 1);
                case (5):
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
  void saveRecipe()
  {
    try
    {
      difficulty = int.parse(difficultyString);
      calories = int.parse(caloriesString);
    }catch (exception)
    {
      throw Exception('Could not convert string to int');
    }
  }


  @override
  Widget build(BuildContext context) {

    getDish();
    return MaterialApp(
      //set all text to white
      theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
              fontFamily: 'CaviarDreams')),

      //set title of page
      title: 'Recipe Overview',

      //create scaffold to lay out elements
      home: Scaffold(
          //set background colour of page
          backgroundColor: const Color.fromARGB(255, 44,52,67,),

          //make page scrollable
          body: SingleChildScrollView(
              //create a container to hold elements
              child: Container(
            //center the elements of the page
            alignment: Alignment.center,
            child: Column(
              children: [
                //display name of dish at the top of the page
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("You have chosen $dishName",
                      style: TextStyle(
                        fontSize: 30.0,
                      )),
                ),
                SizedBox(height: 20),

                // //display image of the dish
                // Container(
                //     width: 410,
                //     height: 336,
                //     //give the image rounded corners
                //     clipBehavior: Clip.antiAlias,
                //     decoration:
                //         BoxDecoration(borderRadius: BorderRadius.circular(42)),
                //     child: Image.memory(
                //       base64Decode(imageLink),
                //       fit: BoxFit.contain,
                //     )),
                // SizedBox(height: 20),

                //display the generated recipe to the screen
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(recipe, style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          ),
            floatingActionButton: FloatingActionButton(
            onPressed:()
            {
              splitRecipe(recipe);
              saveRecipe();

            },
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            child: Text("Save"))
      ),
    );
  }
}