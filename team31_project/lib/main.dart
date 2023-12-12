import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  String _response = 'No image processed yet';

  TextEditingController ingredientController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

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
    var uri = Uri.parse('https://api.openai.com/v1/chat/completions'); // API URL
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
              {"type": "text", "text": "What are ingredients inside of that fridge? Just give Name:quantity, nothing else. Example: 'Apple: 1 Orange: 3' "},
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

  Map<String, String> ingredientsMap = {
    'Flour': '2',
    'Sugar': '1',
    'Eggs': '2',
    'Milk': '4',
    'Butter': '6',
  };

  Map<String, String> parseContent(String content) {
    Map<String, String> resultMap = {};
    var entries = content.split('\n');

    for (var entry in entries) {
      var keyValue = entry.split(':');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1].trim();
        resultMap[key] = value;
      }
    }
    return resultMap;
  }


  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    String? imageUrl = await uploadImageAndGetDownloadUrl();
    if (imageUrl != null) {
      String response = await sendToOpenAI(imageUrl);
      setState(() {
        var jsonResponse = jsonDecode(response);
        var contentString = jsonResponse['choices'][0]['message']['content'];
        Map<String, String> contentMap = parseContent(contentString);
        _response = contentMap.entries
            .map((entry) => '${entry.key}: ${entry.value}')
            .join(', ');
      });
    } else {
      setState(() {
        _response = "Error: Image was not uploaded successfully.";
      });
    }
  }

  void addIngredients(
      Map<String, String> originalMap, Map<String, String> newIngredients) {
    originalMap.addAll(newIngredients);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _response,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            // New text fields for entering ingredient and quantity
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
                      addItemToIngredientsMap(
                        ingredientController.text,
                        quantityController.text,
                      );
                    },
                    child: const Text('Add Ingredient'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      removeIngredient(
                        ingredientController.text,
                      );
                    },
                    child: const Text('Remove Ingredient'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
