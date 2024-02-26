import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main()
{
  runApp(RecipeOverview());
}


class RecipeOverview extends StatelessWidget
{
  //create background colour
  Color back = const Color.fromARGB(255, 45, 52, 68);


  //create an instance of the gpt class that can be used to make api requests
  GPTRecipe gptapi = GPTRecipe('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');
  gptMock mock = gptMock();


  //store the entire recipe
  String recipe = " ";
  //store the name of the dish
  String dishName = "Paella";
  //store a link to an image of the dish
  String imageLink = " ";


  //method to request recipe and image from api
  Future<void> getDish() async
  {
    //request recipe
    //recipe = await gptapi.getRecipe("Strawberry cheesecake", false);
    //request image
    //imageLink = await gptapi.getRecipe("Strawberry cheesecake", true);

    recipe = mock.recipeText;
    imageLink = mock.imageLink;
  }


  @override
  Widget build(BuildContext context)
  {
    //generate recipe
    getDish();

    return MaterialApp(
      //set all text to white
      theme: ThemeData(textTheme:Theme.of(context).textTheme.apply(
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
                child: Text("You have chosen $dishName", style: TextStyle(fontSize: 30.0,)),
              ),
              SizedBox(height: 20),

              //display image of the dish
             Container(
               width: 410,
               height: 336,
               //give the image rounded corners
               clipBehavior: Clip.antiAlias,
               decoration:  BoxDecoration(
                   borderRadius: BorderRadius.circular(42)
               ),
              child : Image.network(imageLink),
             ),
              SizedBox(height: 20),

              //display the generated recipe to the screen
              Padding(padding: EdgeInsets.all(20),
              child : Text(recipe, style: TextStyle(fontSize: 16)) ,),
              SizedBox(height: 20),


            ],
          ),
        )
       )
      ),
    );
  }
}


//class to handle GPT api requests to generate a recipe
class GPTRecipe
{
  final String apiKey;

  //constructor method
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
  Future<String> getRecipe(String dishName, bool isImage) async {
    try {

      String message = " ";
      if (!isImage)
        {
          //instruct the api to return a recipe with name, difficulty cooking time, ingredients and method
          message = 'Tell me how to make $dishName, give me the name of the dish, a difficulty rating out of 10 and estimated cooking time, then give me a list of ingredients and a full method with step-by-step instructions';
        }
      else
        {
          //instruct the api to get an image of the dish
          message = "Give me the image address of an image of a $dishName";
        }


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

class gptMock
{
  String recipeText = " ";
  String imageLink = " ";

  gptMock()
  {
    recipeText =
    """
    Ingredients: 
    
  - large pinch saffron strands
  - 1 vegetable or chicken stock cube, made up to 600ml
  - 3 tbsp olive oil, plus extra for drizzling
  - 125g chorizo, roughly chopped
  - 500g boneless, skinless chicken breasts or thighs (or a mix), chopped
  - 1 onion, finely chopped
  - 3 garlic cloves, finely chopped
  - 1 red pepper, deseeded and chopped
  - 2 tsp paprika
  - 250g Spanish paella rice
  - 4 medium tomatoes, roughly chopped
  - 75g frozen peas
  - 250g cooked prawns with shells on (thawed if frozen) and rinsed
  - small handful flat-leaf parsley, chopped, to serve
  - chopped lemon wedges, to serve
  
  Method:
  
  Stir the saffron strands into the stock and set aside to infuse while you prepare the rest of the paella.
  
  Heat 1 tbsp oil in a paella pan or a large deep frying pan with a lid. Tip in the chorizo and fry for about 3 mins until crisp and the oil has been released. Remove the chorizo and drain on kitchen paper, leaving the oil in the pan.
  
  Stir the chicken into the pan and fry over a high heat for 7-8 mins, or until the meat is golden and cooked through. Transfer the chicken to a bowl and set aside.
  
  Pour another 1 tbsp of oil into the pan, tip in the chopped onion and garlic and stir-fry for 4-5 mins, until softened and just starting to colour. Stir in the pepper and paprika with the remaining tablespoon of oil and stir-fry for a further 1-2 mins. The pan should have lots of crispy, brown bits on the bottom, which will all add flavour.
  
  With the heat still quite high, quickly stir in the rice so it is well-coated in the oil, then pour in the saffron-infused stock plus 450ml boiling water, scraping up the sticky brown bits from the bottom of the pan with a wooden spoon.
  
  Return the browned chicken pieces to the pan, then add the chopped tomatoes. Cover the pan and cook on a medium heat for 10 mins, stirring once or twice. Scatter the peas, prawns and fried chorizo over the top, cover again and leave to cook a further 5-10 mins, or until the rice is just cooked and most of the liquid in the pan has been absorbed.
  
  Remove the pan from the heat, put the lid on and leave to rest for 5 mins. Stir a few times to mix the ingredients, season to taste and scatter over the chopped parsley. Serve with lemon wedges and an extra drizzle of oil, if you like.
    """;
    imageLink =
    "https://images.immediate.co.uk/production/volatile/sites/30/2018/06/Oven-paella-5d16b06.jpg?resize=768,574";
  }

}