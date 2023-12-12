import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
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
  String _response = 'No image processed yet';

  // TextEditingController reads user inputs
  TextEditingController ingredientController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

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

  Future<String> sendToOpenAI() async {
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
            "content":
            "What are ingredients inside of that fridge? Just give Name:quantity, nothing else. Example: 'Apple: 1 Orange: 3' " // Your text prompt/question
          },
          {
            "role": "system",
            "content":
            "https://upload.wikimedia.org/wikipedia/commons/7/7b/Open_refrigerator_with_food_at_night.jpg"
          }
        ],
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

  void updateUI() async {
    setState(() {
    });

    String response = await sendToOpenAI();

    setState(() {
      var jsonResponse = jsonDecode(response);
      var contentString = jsonResponse['choices'][0]['message']['content'];
      Map<String, String> contentMap = parseContent(contentString);
      addIngredients(contentMap, ingredientsMap);
      _response = contentMap.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join(', ');
    });
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
        onPressed: updateUI,
        tooltip: 'Scan Fridge',
        child: const Icon(Icons.search),
      ),
    );
  }
}
