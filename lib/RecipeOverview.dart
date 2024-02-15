import 'package:flutter/material.dart';

void main()
{
  runApp(RecipeOverview());
}

class RecipeOverview extends StatelessWidget
{
  //create background colour
  Color bck = const Color.fromARGB(255, 45, 52, 68);
  //get picture of food
  Image food_img = const Image(image: AssetImage("adams_cake.png"));

  @override
  Widget build(BuildContext context) {
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
              //title of recipe
              Text("Adams cake", style: TextStyle(fontSize: 50.0,)),
              SizedBox(height: 100,),
              //image

              
              //ingredients
              Text("Ingredients:", style: TextStyle(fontSize: 30)),
              SizedBox(height: 20),
              Text("Butter, Digestives, Strawberries, Cream cheese"),
              SizedBox(height: 20,),

              //method
              Text("Method : ", style: TextStyle(fontSize: 30)),
              SizedBox(height: 20,),
              Text("""
                For the crust, melt 85g butter in a medium pan. 
                Stir in 140g digestive biscuit crumbs and 1 tbsp golden caster or
                 granulated sugar so the mixture is evenly moistened.""")
            ],
          ),
        )
      ),
    );
  }

}


