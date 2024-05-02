import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:food_ai_app/Util/colours.dart';
import 'package:food_ai_app/Util/custom_app_bar.dart';

/// A StatefulWidget that represents the preferences screen in the application.
///
/// This screen allows users to view and manage their preferences, such as dietary restrictions
/// or other personalization settings. It interacts with Firestore to fetch and update user preferences.
class PreferencesScreen extends StatefulWidget {
  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

/// The state for [PreferencesScreen] that manages user preferences.
///
/// This class handles the state and UI interactions for the preferences screen, allowing users to
/// view and modify their preferences such as dietary restrictions or notification settings.
///
/// It integrates with Firebase Firestore to store and retrieve user preferences,
/// and Firebase Auth to identify the current user.
class _PreferenceScreenState extends State<PreferencesScreen> {
  /// Stores a list of the user's preferences.
  List<String> preferences = [];

  /// Tracks the checked state of each preference.
  Map<String, bool> checkedPreferences = {};

  /// Controls the text input for adding new preferences
  final TextEditingController preferenceController = TextEditingController();

  /// Instance of Firestore used to interact with the Firebase Firestore database.
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// The currently authenticated user.
  final user = FirebaseAuth.instance.currentUser;

  /// Initializes the state of the preferences screen.
  @override
  void initState() {
    super.initState();
    initializePreferences();
    fetchPreferences();
  }

  /// Initializes the user's preferences and stores them in the Firestore database.
  /// If preferences don't already exist they will ne initialized
  /// If they already exist, then the preferences will be loaded in
  Future<void> initializePreferences() async {
    // Reference to the Personalisation document
    final personalisationDocRef = firestore
        .collection('users')
        .doc(user?.uid)
        .collection('Personalisation')
        .doc('Personalisation');

    /// Stores the personalisation document.
    final docSnapshot = await personalisationDocRef.get();

    // Check if the document exists
    if (docSnapshot.exists) {
      // Document exists, now check if 'prefrences' field exists
      final data = docSnapshot.data();
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

  /// Fetches and stores the user's preferences in an array
  Future<void> fetchPreferences() async {
    final DocumentSnapshot userSnapshot = await firestore
        .collection('users')
        .doc(user?.uid)
        .collection('Personalisation')
        .doc('Personalisation')
        .get();
    setState(() {
      final userData = userSnapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        if (userData['preferences'] is List<dynamic>) {
          preferences =
              (userData['preferences'] as List<dynamic>).cast<String>();
        } else {
          preferences = [];
        }
        if (userData['activePreferences'] is List<dynamic>) {
          // Initialize checkedPreferences based on activePreferences
          final List<String> activePreferences =
              (userData['activePreferences'] as List<dynamic>).cast<String>();
          for (final preference in preferences) {
            checkedPreferences[preference] =
                activePreferences.contains(preference);
          }
        } else {
          for (final preference in preferences) {
            checkedPreferences[preference] = false;
          }
        }
      } else {
        /// stores preferences and checked preferences
        preferences = [];
        checkedPreferences = {};
      }
    });
  }

  /// Adds the text stored in [preferenceController] to the user's preferences in firebase.
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

  /// Removes the selected preference from the current user's preference document
  /// Takes preference as a parameter
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

  /// This function returns a Scaffold widget with a specified background color and an AppBar
  /// containing the title "Preferences". The body consists of a TextField for adding new preferences
  /// and a ListView.builder for displaying existing preferences as CheckboxListTiles.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272E3B),
      appBar: CustomAppBar(),
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
                  final String currentPreference = preferences[index];
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
