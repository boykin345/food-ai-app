import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:food_ai_app/Util/colours.dart';
import 'package:food_ai_app/Util/custom_app_bar.dart';

/// Controller for text field where user's can enter thier goals for protein
final TextEditingController proteinController = TextEditingController();

/// Controller for text field where user's can enter thier goals for carbohydrates
final TextEditingController carbsController = TextEditingController();

/// Controller for text field where user's can enter thier goals for fats
final TextEditingController fatController = TextEditingController();

/// Controller for text field where user's can enter thier goals for fibre
final TextEditingController fibreController = TextEditingController();

/// Controller for text field where user's can enter thier goals for calories
final TextEditingController calorieController = TextEditingController();

/// A StatefulWidget that represents the health goal screen of the app.
///
/// This screen allows users to manage their health goals, such as "Gain Muscle" or "Lose Weight"
/// and set daily nutritional goals for protein, carbs, fat, fibre, and calories.
class HealthGoalScreen extends StatefulWidget {
  @override
  GoalScreenState createState() => GoalScreenState();
}

class GoalScreenState extends State<HealthGoalScreen> {
  /// A list to hold the health goals fetched from the Firestore database.
  List<String> healthGoals = [];

  /// A map to track the checked state of each health goal.
  Map<String, bool> checkedHealthGoals = {};

  /// A TextEditingController for adding new health goals.
  final TextEditingController goalsController = TextEditingController();

  /// Firestore instance for database operations.
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// The current authenticated user.
  final user = FirebaseAuth.instance.currentUser;

  /// initializes the Health Goals page with the default health goals
  /// and macros and calories
  @override
  void initState() {
    super.initState();
    initializeHealthGoals();
    fetchHealthGoals();
  }

  /// Initializes health goals in the Firestore database if they don't exist.
  ///
  /// This method checks if the 'healthGoals' field exists for the current user in the Firestore database.
  /// If it doesn't, it initializes the field with default values such as "Gain Muscle" and "Lose Weight".
  Future<void> initializeHealthGoals() async {
    final personalisationDocRef = firestore
        .collection('users')
        .doc(user?.uid)
        .collection('Personalisation')
        .doc('Personalisation');

    /// snapshot of the user's halth goals that are stored in Firebase
    final docSnapshot = await personalisationDocRef.get();

    // Check if the document exists
    if (docSnapshot.exists) {
      /// Document exists, now check if 'healthGoals' field exists
      final data = docSnapshot.data();
      if (data != null && !data.containsKey('healthGoals')) {
        // 'healthGoals' field doesn't exist, initialize it
        await personalisationDocRef.update({
          'healthGoals': FieldValue.arrayUnion(['Gain Muscle', 'Lose Weight'])
        });
      }
    } else {
      // Document doesn't exist, create it and initialize 'healthGoals'
      await personalisationDocRef.set({
        'healthGoals': ['Gain Muscle', 'Lose Weight']
      });
    }
  }

  /// Fetches health goals from the Firestore database and updates the local list.
  ///
  /// This method queries the Firestore database for the current user's health goals and updates
  /// the local [healthGoals] list with the fetched values.
  Future<void> fetchHealthGoals() async {
    /// Snapshot of the document containing the user's health goals.
    final DocumentSnapshot userSnapshot = await firestore
        .collection('users')
        .doc(user?.uid)
        .collection('Personalisation')
        .doc('Personalisation')
        .get();
    setState(() {
      ///Gets the user's data as a snapshot
      final userData = userSnapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        if (userData['healthGoals'] is List<dynamic>) {
          healthGoals =
              (userData['healthGoals'] as List<dynamic>).cast<String>();
        } else {
          healthGoals = [];
        }
        if (userData['activeHealthGoals'] is List<dynamic>) {
          // Initialize checkedHealthGoals based on activehealthGoals
          final List<String> activehealthGoals =
              (userData['activeHealthGoals'] as List<dynamic>).cast<String>();
          for (final preference in healthGoals) {
            checkedHealthGoals[preference] =
                activehealthGoals.contains(preference);
          }
        } else {
          for (final preference in healthGoals) {
            checkedHealthGoals[preference] = false;
          }
        }

        // Load nutrient values into TextControllers
        if (userData.containsKey('Protein')) {
          proteinController.text = userData['Protein'].toString();
        }
        if (userData.containsKey('Carbs')) {
          carbsController.text = userData['Carbs'].toString();
        }
        if (userData.containsKey('Fats')) {
          fatController.text = userData['Fats'].toString();
        }
        if (userData.containsKey('Fibre')) {
          fibreController.text = userData['Fibre'].toString();
        }
        if (userData.containsKey('Calories')) {
          calorieController.text = userData['Calories'].toString();
        }
      } else {
        healthGoals = [];
        checkedHealthGoals = {};
      }
    });
  }

  /// Adds a new health goal to the Firestore database and updates the UI.
  ///
  /// This method adds a new health goal entered by the user to the Firestore database and
  /// updates the local list of health goals to reflect the change.
  void addGoal() {
    if (goalsController.text.isNotEmpty) {
      setState(() {
        healthGoals.add(goalsController.text);
        checkedHealthGoals[goalsController.text] =
            false; // Initialize as unchecked
      });
      firestore
          .collection('users')
          .doc(user?.uid)
          .collection('Personalisation')
          .doc('Personalisation')
          .update({
        'healthGoals': FieldValue.arrayUnion([goalsController.text])
      });
      goalsController.clear();
    }
  }

  /// Removes a health goal from the Firestore database and updates the UI.
  ///
  /// This method removes the specified health goal from the Firestore database and
  /// updates the local list of health goals to reflect the change.
  void removeGoal(String preference) {
    setState(() {
      healthGoals.remove(preference);
      checkedHealthGoals
          .remove(preference); // Remove from checkedHealthGoals map
    });
    firestore
        .collection('users')
        .doc(user?.uid)
        .collection('Personalisation')
        .doc('Personalisation')
        .update({
      'healthGoals': FieldValue.arrayRemove([preference]),
      'activeHealthGoals':
          FieldValue.arrayRemove([preference]) // Ensure consistency
    });
  }

  /// Builds the UI for the health goal screen.
  ///
  /// This method constructs a Scaffold widget that defines the structure of the health goal screen.
  /// The screen includes an AppBar with the title 'Health Goals', text fields for adding new health goals
  /// and entering daily nutritional information, a list of existing health goals with checkboxes to select them,
  /// and a button to save the entered information to the Firestore database.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colours.primary,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: goalsController,
              style: TextStyle(
                  color: Color(0xFF272E3B), fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Add a new Health Goal',
                enabledBorder: OutlineInputBorder(
                  // Normal state border
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  // Border when TextField is focused
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(color: Color(0xFF272E3B), Icons.add),
                  onPressed: addGoal,
                ),
                fillColor: Colors
                    .white, // Sets the background color inside the TextField to white
                filled: true, // Enables the fillColor to be applied
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 35), // Adds some space between elements
            Text('Nutrients',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Protein (g)',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2, // Takes 2/3 of the row space
                  child: TextField(
                      controller: proteinController,
                      keyboardType: TextInputType
                          .number, // Ensures only numbers can be entered
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                Expanded(
                  child: Text('Fat (g)',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2, // Takes 2/3 of the row space
                  child: TextField(
                    controller: fatController,
                    keyboardType: TextInputType
                        .number, // Ensures only numbers can be entered
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Carbs (g)',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2, // Takes 2/3 of the row space
                  child: TextField(
                      controller: carbsController,
                      keyboardType: TextInputType
                          .number, // Ensures only numbers can be entered
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                Expanded(
                  child: Text('Fibre (g)',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2, // Takes 2/3 of the row space
                  child: TextField(
                    controller: fibreController,
                    keyboardType: TextInputType
                        .number, // Ensures only numbers can be entered
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Calories (cal)',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2, // Takes 2/3 of the row space
                  child: TextField(
                      controller: calorieController,
                      keyboardType: TextInputType
                          .number, // Ensures only numbers can be entered
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ],
            ),

            SizedBox(height: 45), // Adds some space between elements
            Text('Health Goals',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: healthGoals.length,
                itemBuilder: (context, index) {
                  final String currentPreference = healthGoals[index];
                  return CheckboxListTile(
                    title: Text(
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        currentPreference),
                    value: checkedHealthGoals[currentPreference] ??
                        false, // Default to false if not found
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkedHealthGoals[currentPreference] = newValue!;
                      });
                      if (newValue == true) {
                        // Add to activehealthGoals if checked
                        firestore
                            .collection('users')
                            .doc(user?.uid)
                            .collection('Personalisation')
                            .doc('Personalisation')
                            .update({
                          'activeHealthGoals':
                              FieldValue.arrayUnion([currentPreference])
                        });
                      } else {
                        // Remove from activehealthGoals if unchecked
                        firestore
                            .collection('users')
                            .doc(user?.uid)
                            .collection('Personalisation')
                            .doc('Personalisation')
                            .update({
                          'activeHealthGoals':
                              FieldValue.arrayRemove([currentPreference])
                        });
                      }
                    },
                    secondary: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => removeGoal(currentPreference),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                /// Reads and stores value from protein controller and stores
                final String protein = proteinController.text;

                /// Reads and stores value from carbs  controller and stores
                final String carbs = carbsController.text;

                /// Reads and stores value from fat controller and stores
                final String fats = fatController.text;

                /// Reads and stores value from fibre controller and stores
                final String fibre = fibreController.text;

                /// Reads and stores value from calorie controller and stores
                final String calorie = calorieController.text;

                /// updates the user's database with he necessary. 
                firestore
                    .collection('users')
                    .doc(user?.uid)
                    .collection('Personalisation')
                    .doc('Personalisation')
                    .update({
                  'Protein': protein,
                  'Carbs': carbs,
                  'Fats': fats,
                  'Fibre': fibre,
                  'Calories': calorie,
                });
              },
              child: Text(
                  style: TextStyle(
                      color: Color(0xFF272E3B), fontWeight: FontWeight.bold),
                  'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
