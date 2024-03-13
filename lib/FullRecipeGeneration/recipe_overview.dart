import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:food_ai_app/FullRecipeGeneration/gpt_api_recipe.dart';
import 'package:food_ai_app/FullRecipeGeneration/gpt_api_recipe_mock.dart';

class RecipeOverview extends StatelessWidget {
  late String dishName;
  late String imageLink;

  //create background colour
  Color back = const Color.fromARGB(255, 45, 52, 68);

  //create an instance of the gpt class that can be used to make api requests
  GPTRecipeApi gptRecipeApi = GPTRecipeApi('46ac92c47cd344e48007ac50e31d7771');
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
    //recipe = await gptRecipeApi.getRecipe(dishName, false);
    recipe = mockRecipeApi.recipeText;
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text("You have chosen $name",
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
                    child: Image.memory(
                      base64Decode(imageLink),
                      fit: BoxFit.contain,
                    )),
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
