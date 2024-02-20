import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Allergies.dart';
import 'Settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAGXrbQ1Z7sKGt_dYrocxkcbpkefyRQMhw",
        appId: "1:265622470895:android:8d0fbe0cf1b22509e11b1a", // android
        messagingSenderId: "265622470895",
        projectId: "bjss-food-ai"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Caviar Dreams',
              bodyColor: Colors.white,
            ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(background: Colors.blue[900]),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hi George',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                  child: Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllergiesScreen()),
                    );
                  },
                  child: Text(
                    'Allergies',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllergiesScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Hi George!')),
    );
  }
}
