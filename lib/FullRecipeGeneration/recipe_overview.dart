import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:food_ai_app/FullRecipeGeneration/gpt_api_recipe.dart';
import 'package:food_ai_app/FullRecipeGeneration/gpt_api_recipe_mock.dart';

class RecipeOverview extends StatelessWidget {
  //create background colour
  Color back = const Color.fromARGB(255, 45, 52, 68);

  //create an instance of the gpt class that can be used to make api requests
  GPTRecipeApi gptRecipeApi =
      GPTRecipeApi('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');
  MockGPTRecipeApi mockRecipeApi = MockGPTRecipeApi();

  //store the entire recipe
  String recipe = "";
  //store the name of the dish
  String dishName = "Paella";
  //store a link to an image of the dish
  String imageLink = "";

  //method to request recipe and image from api
  Future<void> getDish() async {
    //request recipe
    //recipe = await gptRecipeApi.getRecipe("Strawberry cheesecake", false);
    //request image
    //imageLink = await gptRecipeApi.getRecipe("Strawberry cheesecake", true);

    recipe = mockRecipeApi.recipeText;
    imageLink = mockRecipeApi.imageLink;
  }

  @override
  Widget build(BuildContext context) {
    //generate recipe
    getDish();

    return MaterialApp(
      //set all text to white
      theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
              fontFamily: 'Caviar Dreams')),

      //set title of page
      title: 'Recipe Overview',

      //create scaffold to lay out elements
      home: Scaffold(
          //set background colour of page
          backgroundColor: back,

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

                //display image of the dish
                Container(
                  width: 410,
                  height: 336,
                  //give the image rounded corners
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(42)),
                  child: Image.network(imageLink),
                ),
                SizedBox(height: 20),

                //display the generated recipe to the screen
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(recipe, style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 20),
              ],
            ),
          ))),
    );
  }
}
