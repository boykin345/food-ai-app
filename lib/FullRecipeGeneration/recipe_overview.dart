import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_ai_app/FullRecipeGeneration/gpt_api_recipe.dart';
import 'package:food_ai_app/FullRecipeGeneration/gpt_api_recipe_mock.dart';

import 'package:food_ai_app/Util/colours.dart';
import 'package:food_ai_app/Util/custom_app_bar.dart';

class RecipeOverview extends StatelessWidget {
  late String dishName;
  late String imageLink;

  //create an instance of the gpt class that can be used to make api requests
  GPTRecipeApi gptRecipeApi = GPTRecipeApi('bfc9723eaa5443bcabf0fa450647baf3');
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
        ));
  }
}
