import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ai_app/ImageDetection/api_call.dart';
import 'package:food_ai_app/ImageDetection/take_photo.dart';
import 'package:food_ai_app/IngredientVerification/ingredients_editing.dart';
import 'package:food_ai_app/Util/colours.dart';
import 'package:food_ai_app/Util/custom_app_bar.dart';
import 'package:food_ai_app/Util/customer_drawer.dart';
import 'package:food_ai_app/Util/initial_recipes.dart';
import 'package:image_picker/image_picker.dart';

import '../Entities/recipe.dart';
import '../LoadingScreen/custom_loading_circle.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  bool _isLoading = false;
  RecipeInitialiser recipeInitialiser = RecipeInitialiser();

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
      setState(() {
        _isLoading = true; // Start loading
      });
      final String? imageUrl =
          await APICall.uploadImageAndGetDownloadUrl(imageFile);

      if (imageUrl != null) {
        final String response = await APICall.sendToOpenAI(imageUrl);
        final jsonResponse = jsonDecode(response);
        final contentString = jsonResponse['choices'][0]['message']['content'];
        setState(() {
          _isLoading = false; // Stop loading
          _response = contentString as String;
          final ingredientsMap = parseContent(_response);
          final IngredientEditing ingredientEditing =
              IngredientEditing(ingredientsMapCons: ingredientsMap);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ingredientEditing),
          );
        });
      } else {
        setState(() {
          _isLoading = false; // Stop loading
          _response = "Error: Image was not uploaded successfully.";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading
        _response = 'Error processing image: ${e}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: _isLoading
          ? Center(child: CustomLoadingCircle()) // Show loading indicator
          : buildUI(context),
    );
  }

  Widget buildUI(BuildContext context) {
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
                "Breakfasts",
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
                    recipe: recipeInitialiser.frenchToast,
                  ),
                ],
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
              height:
                  270, //Adjusts the space allocated for the Desserts Section
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecipeItem(
                    recipe: recipeInitialiser.pestoChicken,
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
              height: 270, //Adjusts the space for the Mains Section
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecipeItem(
                    recipe: recipeInitialiser.lavaCake,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45.0, left: 15.0, bottom: 15),
              child: Text(
                "Side-Dishes",
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
                    recipe: recipeInitialiser.roastedBroccoli,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45.0, left: 15.0, bottom: 15),
              child: Text(
                "Lunch",
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
                    recipe: recipeInitialiser.chickenSalad,
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
                        title: Text('Take Photo',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            )),
                        onTap: () async {
                          //Navigate to Take Picture Screen
                          //Navigator.pop(context);
                          final imagePath =
                              await initialiseTakePictureScreen(context);
                          //Handle returned image path
                          if (imagePath != null) {
                            setState(() {
                              _imageFile = File(
                                  imagePath); // Update _imageFile with the captured image
                              processImage(_imageFile!);
                            });
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo),
                        title: Text('Select From Gallery',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            )),
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
    required Recipe recipe,
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
              recipe.imageURL,
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
                      recipe.recipeName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text("Calories: ${recipe.calories}.",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w800)),
                    Text(
                      "Prep Time: ${recipe.prepTime}",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w800),
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
