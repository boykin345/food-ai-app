import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Util/colours.dart';
import '../Util/custom_app_bar.dart';
import '../Util/customer_drawer.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferencesScreen> {
  List<String> preferences = [];
  Map<String, bool> checkedPreferences = {}; // Track checked state
  final TextEditingController preferenceController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    initializePreferences();
    fetchPreferences();
  }

  void initializePreferences() async {
    // Reference to the Personalisation document
    var personalisationDocRef = firestore
        .collection('users')
        .doc(user?.uid)
        .collection('Personalisation')
        .doc('Personalisation');

    var docSnapshot = await personalisationDocRef.get();

    // Check if the document exists
    if (docSnapshot.exists) {
      // Document exists, now check if 'prefrences' field exists
      var data = docSnapshot.data();
      if (data != null && !data.containsKey('preferences')) {
        // 'healthGoals' field doesn't exist, initialize it
        await personalisationDocRef.update({
          'preferences': FieldValue.arrayUnion(
              ['Vegetarian', 'Vegan', 'Halal', 'Dairy Free'])
        });
      }
    } else {
      // Document doesn't exist, create it and initialize 'preferences'
      await personalisationDocRef.set({
        'preferences': FieldValue.arrayUnion(
            ['Vegetarian', 'Vegan', 'Halal', 'Dairy Free'])
      });
    }
  }

  void fetchPreferences() async {
    DocumentSnapshot userSnapshot = await firestore
        .collection('users')
        .doc(user?.uid)
        .collection('Personalisation')
        .doc('Personalisation')
        .get();
    setState(() {
      var userData = userSnapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        if (userData['preferences'] is List<dynamic>) {
          preferences =
              (userData['preferences'] as List<dynamic>).cast<String>();
        } else {
          preferences = [];
        }
        if (userData['activePreferences'] is List<dynamic>) {
          // Initialize checkedPreferences based on activePreferences
          List<String> activePreferences =
              (userData['activePreferences'] as List<dynamic>).cast<String>();
          preferences.forEach((preference) {
            checkedPreferences[preference] =
                activePreferences.contains(preference);
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

  void addPreference() {
    if (preferenceController.text.isNotEmpty) {
      setState(() {
        preferences.add(preferenceController.text);
        checkedPreferences[preferenceController.text] =
            false; // Initialize as unchecked
      });
      firestore
          .collection('users')
          .doc(user?.uid)
          .collection('Personalisation')
          .doc('Personalisation')
          .update({
        'preferences': FieldValue.arrayUnion([preferenceController.text])
      });
      preferenceController.clear();
    }
  }

  void removePreferece(String preference) {
    setState(() {
      preferences.remove(preference);
      checkedPreferences
          .remove(preference); // Remove from checkedPreferences map
    });
    firestore
        .collection('users')
        .doc(user?.uid)
        .collection('Personalisation')
        .doc('Personalisation')
        .update({
      'preferences': FieldValue.arrayRemove([preference]),
      'activePreferences':
          FieldValue.arrayRemove([preference]) // Ensure consistency
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272E3B),
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: preferenceController,
              style: TextStyle(
                  color: Color(0xFF272E3B), fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Add a new Preference',
                enabledBorder: OutlineInputBorder(
                  // Normal state border
                  borderSide: BorderSide(color: Colours.backgroundOff),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  // Border when TextField is focused
                  borderSide: BorderSide(color: Colours.backgroundOff),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(color: Color(0xFF272E3B), Icons.add),
                  onPressed: addPreference,
                ),
                fillColor: Colours
                    .backgroundOff, // Sets the background color inside the TextField to white
                filled: true, // Enables the fillColor to be applied
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: preferences.length,
                itemBuilder: (context, index) {
                  String currentPreference = preferences[index];
                  return CheckboxListTile(
                    title: Text(
                        style: TextStyle(
                            color: Colours.backgroundOff,
                            fontWeight: FontWeight.bold),
                        currentPreference),
                    value: checkedPreferences[currentPreference] ??
                        false, // Default to false if not found
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkedPreferences[currentPreference] = newValue!;
                      });
                      if (newValue == true) {
                        // Add to activePreferences if checked
                        firestore
                            .collection('users')
                            .doc(user?.uid)
                            .collection('Personalisation')
                            .doc('Personalisation')
                            .update({
                          'activePreferences':
                              FieldValue.arrayUnion([currentPreference])
                        });
                      } else {
                        // Remove from activePreferences if unchecked
                        firestore
                            .collection('users')
                            .doc(user?.uid)
                            .collection('Personalisation')
                            .doc('Personalisation')
                            .update({
                          'activePreferences':
                              FieldValue.arrayRemove([currentPreference])
                        });
                      }
                    },
                    secondary: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => removePreferece(currentPreference),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
