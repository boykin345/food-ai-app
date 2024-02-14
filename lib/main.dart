import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
        title: Text('Main Page'),
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
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Allergies'),
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
      body: Center(child: Text('Main Page')),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedDifficulty = 1;
  String _selectedCookingTime = '30 min';
  int _selectedPortionSize = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            DropdownButtonFormField<int>(
              value: _selectedDifficulty,
              items: [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('1'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('2'),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('3'),
                ),
                DropdownMenuItem<int>(
                  value: 4,
                  child: Text('4'),
                ),
                DropdownMenuItem<int>(
                  value: 5,
                  child: Text('5'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Difficulty'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedCookingTime,
              items: [
                '30 min',
                '1 h',
                '2 h',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCookingTime = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Cooking Time'),
            ),
            DropdownButtonFormField<int>(
              value: _selectedPortionSize,
              items: [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('1'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('2'),
                ),
                DropdownMenuItem<int>(
                  value: 4,
                  child: Text('4'),
                ),
                DropdownMenuItem<int>(
                  value: 6,
                  child: Text('6'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPortionSize = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Portion Size'),
            ),
          ],
        ),
      ),
    );
  }
}

class AllergiesScreen extends StatefulWidget {
  @override
  _AllergiesScreenState createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  List<String> allergies = [];
  final TextEditingController allergyController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchAllergies();
  }

  void fetchAllergies() async {
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc('TestUser').get();
    setState(() {
      var userData = userSnapshot.data()
          as Map<String, dynamic>?; // Cast to Map<String, dynamic> or null
      if (userData != null && userData['allergies'] is List<dynamic>) {
        allergies = (userData['allergies'] as List<dynamic>).cast<String>();
      } else {
        allergies = [];
      }
    });
  }

  void _addAllergy() {
    if (allergyController.text.isNotEmpty) {
      setState(() {
        allergies.add(allergyController.text);
      });
      // Add allergy to Firestore
      firestore.collection('users').doc('TestUser').update({
        'allergies': FieldValue.arrayUnion([allergyController.text])
      });
      allergyController.clear();
    }
  }

  void _removeAllergy(String allergy) {
    setState(() {
      allergies.remove(allergy);
    });
    // Remove allergy from Firestore
    firestore.collection('users').doc('TestUser').update({
      'allergies': FieldValue.arrayRemove([allergy])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: allergyController,
              decoration: InputDecoration(
                labelText: 'Add a new Dietary need',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addAllergy,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: allergies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(allergies[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeAllergy(allergies[index]),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement save functionality if needed
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
