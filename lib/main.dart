<<<<<<< HEAD
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:food_ai_app/recipe_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
=======
import 'package:flutter/material.dart';
>>>>>>> dcee2acd943d9cb5f762c99990a717bb87869518

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
<<<<<<< HEAD
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
=======
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
>>>>>>> dcee2acd943d9cb5f762c99990a717bb87869518
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // Change made here: Convert 'key' to a super parameter
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
<<<<<<< HEAD
  TextEditingController ingredientController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  Map<String, String> ingredientsMap = {};

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
        "max_tokens": 200
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error: ${response.statusCode}';
    }
  }

  Map<String, String> parseContent(String content) {
    Map<String, String> resultMap = {};
    var lines = content.split('\n');

    for (var line in lines) {
      var parts = line.split(':');
      if (parts.length == 2) {
        var ingredient = parts[0].trim();
        var quantity = parts[1].trim();
        resultMap[ingredient] = quantity;
      }
    }
    return resultMap;
  }

  void processImage() async {
    try {
      String? imageUrl = await uploadImageAndGetDownloadUrl();
      if (imageUrl != null) {
        String response = await sendToOpenAI(imageUrl);
        var jsonResponse = jsonDecode(response);
        var contentString = jsonResponse['choices'][0]['message']['content'];
        ingredientsMap = parseContent(contentString);

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
=======
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
>>>>>>> dcee2acd943d9cb5f762c99990a717bb87869518
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
<<<<<<< HEAD
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: processImage,
        tooltip: 'Upload Image',
        child: const Icon(Icons.upload),
=======
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              // Change made here: Replace deprecated 'headline4' with 'headlineMedium'
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
>>>>>>> dcee2acd943d9cb5f762c99990a717bb87869518
      ),
    );
  }
}
