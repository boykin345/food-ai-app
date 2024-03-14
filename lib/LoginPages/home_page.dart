import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:food_ai_app/SettingsPage/health_goals.dart';
import 'package:food_ai_app/SettingsPage/preferences.dart';
import 'package:food_ai_app/SettingsPage/settings.dart';
import 'package:food_ai_app/IngredientVerification/mock_ingredients.dart';
import 'package:food_ai_app/TinderMVC/tinder_page.dart';
import 'package:food_ai_app/ImageDetection/take_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_ai_app/ImageDetection/api_call.dart';

import 'package:food_ai_app/LoginPages/index_page.dart';

import 'package:food_ai_app/IngredientVerification/ingredients_editing.dart';

import 'package:food_ai_app/Util/custom_app_bar.dart';
import 'package:food_ai_app/Util/customer_drawer.dart';

import 'package:food_ai_app/Util/colours.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late IngredientEditing ingredientEditing;

  File? _imageFile;
  String _response = 'No image processed yet';

  @override
  void initState() {
    super.initState();
  }

  /// Function to get an image from the device's gallery.
  Future<void> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path); // Update image file state
      });
      processImage(_imageFile!);
    }
  }

  /// Map to store ingredients and their quantities.
  Map<String, String> ingredientsMap = {};

  /// Parse the content string to extract ingredients and their quantities.
  Map<String, String> parseContent(String content) {
    final Map<String, String> resultMap = {};
    final lines = content.split('\n');
    for (final line in lines) {
      final parts = line.split(':');
      if (parts.length == 2) {
        final ingredient = parts[0].trim();
        final quantity = parts[1].trim();
        resultMap[ingredient] = quantity;
      }
    }
    return resultMap;
  }

  /// Process the selected image to extract information using APIs.
  Future<void> processImage(File imageFile) async {
    try {
      final String? imageUrl =
          await APICall.uploadImageAndGetDownloadUrl(imageFile);
      if (imageUrl != null) {
        /*final String response = await APICall.sendToOpenAI(imageUrl);
        final jsonResponse = jsonDecode(response);
        final contentString = jsonResponse['choices'][0]['message']['content'];*/
        setState(() {
          /* _response = contentString as String;
          final ingredientsMap = parseContent(_response);*/
          final mockIngredients = MockIngredients();
          final ingredientsMap = mockIngredients.getMap();
          ingredientEditing =
              IngredientEditing(ingredientsMapCons: ingredientsMap);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ingredientEditing),
          );
        });
      } else {
        setState(() {
          _response = "Error: Image was not uploaded successfully.";
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error processing image: ${e}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      backgroundColor: Colours.primary,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                "Let's find the",
                style: TextStyle(
                  fontSize: 30,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Meals you'll Love",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45.0, left: 15.0, bottom: 15),
              child: Text(
                "Mains",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Container(
              height: 270, //Adjusts the space for the Mains Section
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecipeItem(
                    imageUrl: "https://via.placeholder.com/150",
                    name: "Chicken Curry",
                    calories: "400 kcal",
                    prepTime: "30 min",
                  ),
                  _buildRecipeItem(
                    imageUrl: "https://via.placeholder.com/150",
                    name: "Spaghetti Bolognese",
                    calories: "500 kcal",
                    prepTime: "45 min",
                  ),
                  _buildRecipeItem(
                    imageUrl: "https://via.placeholder.com/150",
                    name: "Vegetable Stir Fry",
                    calories: "300 kcal",
                    prepTime: "25 min",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45.0, left: 15.0, bottom: 15),
              child: Text(
                "Desserts",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Container(
              height:
                  270, //Adjusts the space allocated for the Desserts Section
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecipeItem(
                    imageUrl: "https://via.placeholder.com/150",
                    name: "Chocolate Cake",
                    calories: "350 kcal",
                    prepTime: "40 min",
                  ),
                  _buildRecipeItem(
                    imageUrl: "https://via.placeholder.com/150",
                    name: "Apple Pie",
                    calories: "250 kcal",
                    prepTime: "35 min",
                  ),
                  _buildRecipeItem(
                    imageUrl: "https://via.placeholder.com/150",
                    name: "Strawberry Cheesecake",
                    calories: "450 kcal",
                    prepTime: "50 min",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 80.0,
                  left: 15.0,
                  bottom:
                      15), // Adds more space at the bottom of the page so scan button doesnt cover dessert section
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity, //will fit to the size of the screen
        margin: EdgeInsets.symmetric(horizontal: 24.0), //margin for the button
        child: FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text('Take Photo'),
                        onTap: () async {
                          //Navigate to Take Picture Screen
                          //Navigator.pop(context);
                          final imagePath =
                              await initialiseTakePictureScreen(context);
                          //Handle returned image path
                          if (imagePath != null) {
                            setState(() {
                              print(imagePath);
                              _imageFile = File(
                                  imagePath); // Update _imageFile with the captured image
                              processImage(_imageFile!);
                            });
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo),
                        title: Text('Select From Gallery'),
                        onTap: () async {
                          Navigator.pop(context);
                          getImageFromGallery();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            label: Text("Scan Your Fridge",
                style: TextStyle(
                    fontSize: 20,
                    color: Colours.primary,
                    fontWeight: FontWeight.bold)),
            backgroundColor: Colours.backgroundOff),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildRecipeItem({
    required String imageUrl,
    required String name,
    required String calories,
    required String prepTime,
  }) {
    return Container(
      width: 220, // Set a fixed width for the item card
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: Colours.backgroundOff,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Use minimum space needed by children
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            child: Image.network(
              imageUrl,
              height: 150, // Fixed height for the image
              width: double.infinity, // Image takes the full width available
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            // Make the text section flexible
            child: SingleChildScrollView(
              // Make it scrollable
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Calories: $calories",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      "Prep Time: $prepTime",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
