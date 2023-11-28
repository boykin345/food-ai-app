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
    var entries = content.split('\n'); // 使用逗号分割字符串

    for (var entry in entries) {
      var keyValue = entry.split(':'); // 分割键和值
      if (keyValue.length == 2) {
        var key = keyValue[0].trim(); // 清除空格
        var value = keyValue[1].trim(); // 清除空格
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
      // 解析响应 JSON 字符串
      var jsonResponse = jsonDecode(response);
      // 假设 "choices" 数组的第一个元素的 "message" 对象包含 "content" 字段
      var contentString = jsonResponse['choices'][0]['message']['content'];
      // 将 "content" 字段的字符串转换为 Map
      Map<String, String> contentMap = parseContent(contentString);
      // 现在 contentMap 包含了转换后的哈希表，可以根据需要使用它
      _response = contentMap.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
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
