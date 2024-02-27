import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferencesScreen> {
  List<String> preferences = [];
  Map<String, bool> checkedPreferences = {}; // Track checked state
  final TextEditingController preferenceController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchPreferences();
  }

  void fetchPreferences() async {
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc('TestUser').get();
    setState(() {
      var userData = userSnapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        if (userData['preferences'] is List<dynamic>) {
          preferences = (userData['preferences'] as List<dynamic>).cast<String>();
        } else {
          preferences = [];
        }
        if (userData['activePreferences'] is List<dynamic>) {
          // Initialize checkedPreferences based on activePreferences
          List<String> activePreferences = (userData['activePreferences'] as List<dynamic>).cast<String>();
          preferences.forEach((preference) {
            checkedPreferences[preference] = activePreferences.contains(preference);
          });
        } else {
          preferences.forEach((preference) {
            checkedPreferences[preference] = false;
          });
        }
      } else {
        preferences = [];
        checkedPreferences = {};
      }
    });
  }

  void _addPreference() {
    if (preferenceController.text.isNotEmpty) {
      setState(() {
        preferences.add(preferenceController.text);
        checkedPreferences[preferenceController.text] = false; // Initialize as unchecked
      });
      firestore.collection('users').doc('TestUser').update({
        'preferences': FieldValue.arrayUnion([preferenceController.text])
      });
      preferenceController.clear();
    }
  }

  void _removePreference(String preference) {
    setState(() {
      preferences.remove(preference);
      checkedPreferences.remove(preference); // Remove from checkedPreferences map
    });
    firestore.collection('users').doc('TestUser').update({
      'preferences': FieldValue.arrayRemove([preference]),
      'activePreferences': FieldValue.arrayRemove([preference]) // Ensure consistency
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: preferenceController,
              decoration: InputDecoration(
                labelText: 'Add a new Preference',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addPreference,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: preferences.length,
                itemBuilder: (context, index) {
                  String currentPreference = preferences[index];
                  return CheckboxListTile(
                    title: Text(currentPreference),
                    value: checkedPreferences[currentPreference] ?? false, // Default to false if not found
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkedPreferences[currentPreference] = newValue!;
                      });
                      if (newValue == true) {
                        // Add to activePreferences if checked
                        firestore.collection('users').doc('TestUser').update({
                          'activePreferences': FieldValue.arrayUnion([currentPreference])
                        });
                      } else {
                        // Remove from activePreferences if unchecked
                        firestore.collection('users').doc('TestUser').update({
                          'activePreferences': FieldValue.arrayRemove([currentPreference])
                        });
                      }
                    },
                    secondary: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removePreference(currentPreference),
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
