import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_ai_app/recipe_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOOD AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FOOD AI Prototype'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController ingredientController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  Map<String, String> ingredientsMap = {
    'Flour': '2 cups',
    'Sugar': '1 cup',
    'Eggs': '2',
    'Milk': '1 cup',
  };

  String _response = 'No image processed yet';

  Future<String?> uploadImageAndGetDownloadUrl() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String fileName = path.basename(file.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$fileName');
      await ref.putFile(file);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } else {
      return null;
    }
  }

  Future<String> sendToOpenAI(String imageUrl) async {
    var uri =
        Uri.parse('https://api.openai.com/v1/chat/completions'); // API URL
    const String API_KEY =
        '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'; // Replace with your actual API Key

    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $API_KEY'
      },
      body: jsonEncode({
        "model": "gpt-4-vision-preview", // Replace with the correct model
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text":
                    "What are ingredients inside of that fridge? Just give Name:quantity, nothing else. Example: 'Apple: 1' "
              },
              {"type": "image_url", "image_url": imageUrl}
            ]
          }
        ],
        "max_tokens": 1000
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error: ${response.statusCode}';
    }
  }

  void processImage() async {
    try {
      String? imageUrl = await uploadImageAndGetDownloadUrl();
      if (imageUrl != null) {
        String response = await sendToOpenAI(imageUrl);
        var jsonResponse = jsonDecode(response);
        var contentString = jsonResponse['choices'][0]['message']['content'];
        setState(() {
          _response = contentString;
        });
      } else {
        setState(() {
          _response = "Error: Image was not uploaded successfully.";
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error processing image: ${e.toString()}';
      });
    }
  }

  void addItemToIngredientsMap(String itemName, String quantity) {
    setState(() {
      ingredientsMap[itemName] = quantity;
    });
  }

  void removeIngredient(String itemName) {
    setState(() {
      ingredientsMap.remove(itemName);
    });
  }

  void navigateToRecipeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeScreen(ingredients: ingredientsMap),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        // Making the entire column scrollable
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true, // Shrinking the ListView to its content size
                physics:
                    NeverScrollableScrollPhysics(), // Disabling ListView's scrolling as it's nested in a SingleChildScrollView
                itemCount: ingredientsMap.length,
                itemBuilder: (context, index) {
                  String key = ingredientsMap.keys.elementAt(index);
                  return ListTile(
                    title: Text(key),
                    subtitle: Text('Quantity: ${ingredientsMap[key]}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => removeIngredient(key),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: ingredientController,
                      decoration: InputDecoration(
                        labelText: 'Ingredient',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (ingredientController.text.isNotEmpty &&
                            quantityController.text.isNotEmpty) {
                          addItemToIngredientsMap(
                            ingredientController.text,
                            quantityController.text,
                          );
                          ingredientController.clear();
                          quantityController.clear();
                        }
                      },
                      child: const Text('Add Ingredient'),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: navigateToRecipeScreen,
                child: const Text('Get Recipe Suggestions'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _response,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: processImage,
        tooltip: 'Upload Image',
        child: const Icon(Icons.upload),
      ),
    );
  }
}
