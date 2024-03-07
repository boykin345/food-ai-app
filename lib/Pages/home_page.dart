import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:food_ai_app/SettingsPage/HealthGoals.dart';
import 'package:food_ai_app/SettingsPage/Preferences.dart';
import 'package:food_ai_app/SettingsPage/Settings.dart';
import 'package:food_ai_app/TinderMVC/tinder_page.dart';
import 'package:food_ai_app/ImageDetection/take_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_ai_app/ImageDetection/api_call.dart';

import 'package:food_ai_app/Pages/index_page.dart';

import 'package:food_ai_app/IngredientVerification/ingredients_editing.dart';

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
      print(imageUrl);
      if (imageUrl != null) {
        final String response = await APICall.sendToOpenAI(imageUrl);
        final jsonResponse = jsonDecode(response);
        final contentString = jsonResponse['choices'][0]['message']['content'];
        setState(() {
          _response = contentString as String;
          final ingredientsMap = parseContent(_response);
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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              "Favourites",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            iconSize: 50,
            onPressed: () {
              // Add functionality to navigate to user profile page
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('George Cook', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Tinder Selection'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TinderPage()),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Preferences'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PreferencesScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Health Goals'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HealthGoalScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IndexPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Text(
                "Mains",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Text(
                "Desserts",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                style: TextStyle(fontSize: 20, color: Color(0xFF2D3444))),
            backgroundColor: Color(0xFFFAF0F0)),
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
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      width: 220, //for space in between each box
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0), //roundness of rectangle
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  width: 220, //size of each box
                  height: 270,
                  fit:
                      BoxFit.cover, // Use BoxFit.cover to maintain aspect ratio
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1, //forces recipe name to one line
                          overflow: TextOverflow.ellipsis, //truncates w/ ...
                          style: TextStyle(
                            color: Color(0xFFFAF0F0),
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          "Calories: $calories",
                          style: TextStyle(
                            color: Color(0xFFFAF0F0),
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          "Prep Time: $prepTime",
                          style: TextStyle(
                            color: Color(0xFFFAF0F0),
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
