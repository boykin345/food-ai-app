import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _response = 'No image processed yet';

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
        "model": "gpt-4-0613", // Replace with the correct model
        "messages": [
          // If you are sending an image, it would be another message here
          {
            "role": "user",
            "content":
                "What’s in the image? format:'name: quantity' for example: 'grass: a lot' " // Your text prompt/question
          },
          {
            "role": "system",
            "content":
                "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg"
          }
        ],
        // Do NOT include a separate 'prompt' field outside the 'messages' array
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error: ${response.statusCode}';
    }
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    String response = await sendToOpenAI();
    setState(() {
      var jsonResponse = jsonDecode(response);
      var contentString = jsonResponse['choices'][0]['message']['content'];
      Map<String, String> contentMap = parseContent(contentString);
      _response = contentMap.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join(', ');
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
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                _response,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
