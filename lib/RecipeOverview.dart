import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main()
{
  runApp(RecipeOverview());
}

//Future<string> getChatResponse(String Message) async {}

class RecipeOverview extends StatelessWidget
{
  //create background colour
  Color bck = const Color.fromARGB(255, 45, 52, 68);
  //get picture of food

  //list of ingredients
  List<String> ingredients = ["item 1", "item 2", "item 3"];

  GPTRecipe gptapi = GPTRecipe('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');
  String recipe = " ";

  // List<Widget> ingredientsWidget()
  // {
  //   List<Widget> textWidgets = [];
  //
  //   for (int i = 0; i < ingredients.length; i++)
  //   {
  //     textWidgets.add(Text(ingredients[i]),);
  //   }
  //   return textWidgets;
  // }

  Future<void> getDish() async
  {
    recipe = await gptapi.getRecipe("Strawberry cheesecake");
  }


  @override
  Widget build(BuildContext context)
  {
    getDish();

    return MaterialApp(
      //set all text to white
      theme: ThemeData(textTheme:Theme.of(context).textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,)),

      //set title of page
      title: 'Recipe Overview',

      //create scaffold to lay out elements
      home: Scaffold(
        //set background colour of page
        backgroundColor: bck,

        //create a container to hold elements
        body: Container(
          child: Column(
            children: [
              //Name of dish
              Text("Dish Name", style: TextStyle(fontSize: 50.0,)),
              SizedBox(height: 100,),

              //image


              //details
              Text("Details", style: TextStyle(fontSize: 30.0,)),
              SizedBox(height: 20,),
              
              //ingredients
              Text("Ingredients:", style: TextStyle(fontSize: 30)),
              SizedBox(height: 20),

              //tester

              Text(recipe, style: TextStyle(fontSize: 30)),


              SizedBox(height: 20,),

              //method
              Text("Method : ", style: TextStyle(fontSize: 30)),
              SizedBox(height: 20,),
              Text("Method Text"),


            ],
          ),
        )
      ),
    );
  }
}


//class to handle GPT api requests
class GPTRecipe
{
  final String apiKey;

  GPTRecipe(this.apiKey);

  //method for fetching responses from GPT
  Future<String> getChatResponse(String message) async
  {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': message}
        ],
        'max_tokens': 200,
        'model': 'gpt-4',
      }),
    );

    //return response if successful
    if (response.statusCode == 200)
    {
      return response.body;
    }
    //throw exception of not successful
    else
    {
      throw Exception('Failed to fetch chat response');
    }

  }

  //function to get a recipe from GPT
  Future<String> getRecipe(String dishName) async {
    try {
      //instruct the api to return a recipe with name, difficulty cooking time, ingredients and method
      final message = 'Tell me how to make $dishName, give me the name of the dish, a difficulty rating out of 10 and estimated cooking time, then give me a list of ingredients and a full method with step-by-step instructions';

      final response = await getChatResponse(message);
      final decodedResponse = jsonDecode(response)

      as Map<String, dynamic>; // Safely cast to Map<String, dynamic>
      if (decodedResponse.containsKey('choices') &&
          decodedResponse['choices'] is List) {
        final choices = decodedResponse['choices'] as List;
        if (choices.isNotEmpty && choices[0] is Map<String, dynamic>) {
          final firstChoice = choices[0] as Map<String, dynamic>;
          if (firstChoice.containsKey('message') &&
              firstChoice['message'] is Map<String, dynamic>) {
            final messageContent =
            firstChoice['message'] as Map<String, dynamic>;
            if (messageContent.containsKey('content') &&
                messageContent['content'] is String) {
              final String recipe =
              messageContent['content'] as String; // Safely cast to String
              return recipe;
            }
          }
        }
      }
      throw Exception('Invalid response structure');
    } catch (e) {
      throw Exception('Error fetching recipe: $e');
    }
  }

}