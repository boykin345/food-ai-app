import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final TextEditingController proteinController = TextEditingController();
final TextEditingController carbsController = TextEditingController();
final TextEditingController fatController = TextEditingController();
final TextEditingController fibreController = TextEditingController();
final TextEditingController calorieController = TextEditingController();

class HealthGoalScreen extends StatefulWidget {
  @override
  GoalScreenState createState() => GoalScreenState();
}

class GoalScreenState extends State<HealthGoalScreen> {
  List<String> healthGoals = [];
  Map<String, bool> checkedHealthGoals = {}; // Track checked state
  final TextEditingController goalsController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    initializeHealthGoals();
    fetchHealthGoals();
  }

  void initializeHealthGoals() async {
    firestore.collection('users').doc('TestUser').collection('Personalisation').doc('Personalisation').update({
      'healthGoals': FieldValue.arrayUnion(['Gain muscle'])
    });

    firestore.collection('users').doc('TestUser').collection('Personalisation').doc('Personalisation').update({
      'healthGoals': FieldValue.arrayUnion(['Lose weight'])
    });
  }
  
  void fetchHealthGoals() async {
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc('TestUser').collection('Personalisation').doc('Personalisation').get();
    setState(() {
      var userData = userSnapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        if (userData['healthGoals'] is List<dynamic>) {
          healthGoals = (userData['healthGoals'] as List<dynamic>).cast<String>();
        } else {
          healthGoals = [];
        }
        if (userData['activeHealthGoals'] is List<dynamic>) {
          // Initialize checkedHealthGoals based on activehealthGoals
          List<String> activehealthGoals = (userData['activeHealthGoals'] as List<dynamic>).cast<String>();
          healthGoals.forEach((preference) {
            checkedHealthGoals[preference] = activehealthGoals.contains(preference);
          });
        } else {
          healthGoals.forEach((preference) {
            checkedHealthGoals[preference] = false;
          });
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

  void addGoal() {
    if (goalsController.text.isNotEmpty) {
      setState(() {
        healthGoals.add(goalsController.text);
        checkedHealthGoals[goalsController.text] = false; // Initialize as unchecked
      });
      firestore.collection('users').doc('TestUser').collection('Personalisation').doc('Personalisation').update({
        'healthGoals': FieldValue.arrayUnion([goalsController.text])
      });
      goalsController.clear();
    }
  }

  void removeGoal(String preference) {
    setState(() {
      healthGoals.remove(preference);
      checkedHealthGoals.remove(preference); // Remove from checkedHealthGoals map
    });
    firestore.collection('users').doc('TestUser').collection('Personalisation').doc('Personalisation').update({
      'healthGoals': FieldValue.arrayRemove([preference]),
      'activeHealthGoals': FieldValue.arrayRemove([preference]) // Ensure consistency
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: Color(0xFF272E3B),
      appBar: AppBar(
        backgroundColor: Color(0xFF272E3B),
        title: Text(style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), 'Health Goals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: goalsController,
              style: TextStyle(color: Color(0xFF272E3B), fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Add a new Health Goal',
                enabledBorder: OutlineInputBorder( // Normal state border
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20.0), 
                ),
                focusedBorder: OutlineInputBorder( // Border when TextField is focused
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20.0), 
                ),
                suffixIcon: IconButton(
                  icon: Icon(color: Color(0xFF272E3B), Icons.add),
                  onPressed: addGoal,
                ),
                fillColor: Colors.white, // Sets the background color inside the TextField to white
                filled: true, // Enables the fillColor to be applied
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 35), // Adds some space between elements
            Text('Nutrients', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1, // Takes 1/3 of the row space
                  child: Text('Protein (g)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2, // Takes 2/3 of the row space
                  child: TextField(
                    controller: proteinController,
                    keyboardType: TextInputType.number, // Ensures only numbers can be entered
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                ),
                Expanded(
                  flex: 1, // Takes 1/3 of the row space
                  child: Text('Fat (g)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2, // Takes 2/3 of the row space
                  child: TextField(
                    controller: fatController,
                    keyboardType: TextInputType.number, // Ensures only numbers can be entered
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1, // Takes 1/3 of the row space
                  child: Text('Carbs (g)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2, // Takes 2/3 of the row space
                  child: TextField(
                    controller: carbsController,
                    keyboardType: TextInputType.number, // Ensures only numbers can be entered
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                ),
                Expanded(
                  flex: 1, // Takes 1/3 of the row space
                  child: Text('Fibre (g)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2, // Takes 2/3 of the row space
                  child: TextField(
                    controller: fibreController,
                    keyboardType: TextInputType.number, // Ensures only numbers can be entered
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1, // Takes 1/3 of the row space
                  child: Text('Calories (cal)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2, // Takes 2/3 of the row space
                  child: TextField(
                    controller: calorieController,
                    keyboardType: TextInputType.number, // Ensures only numbers can be entered
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                ),
              ],
            ),

            SizedBox(height: 45), // Adds some space between elements
            Text('Health Goals', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: healthGoals.length,
                itemBuilder: (context, index) {
                  String currentPreference = healthGoals[index];
                  return CheckboxListTile(
                    title: Text(style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), currentPreference),
                    value: checkedHealthGoals[currentPreference] ?? false, // Default to false if not found
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkedHealthGoals[currentPreference] = newValue!;
                      });
                      if (newValue == true) {
                        // Add to activehealthGoals if checked
                        firestore.collection('users').doc('TestUser').collection('Personalisation').doc('Personalisation').update({
                          'activeHealthGoals': FieldValue.arrayUnion([currentPreference])
                        });
                      } else {
                        // Remove from activehealthGoals if unchecked
                        firestore.collection('users').doc('TestUser').collection('Personalisation').doc('Personalisation').update({
                          'activeHealthGoals': FieldValue.arrayRemove([currentPreference])
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
                // Read values from the controllers
                final String protein = proteinController.text;
                final String carbs = carbsController.text;
                final String fats = fatController.text;
                final String fibre = fibreController.text;
                final String calorie = calorieController.text;


                firestore.collection('users').doc('TestUser').collection('Personalisation').doc('Personalisation').update({
                'Protein': protein,
                'Carbs': carbs,
                'Fats': fats,
                'Fibre': fibre,
                'Calories': calorie,
                });
                
              },
              child: Text(style: TextStyle(color: Color(0xFF272E3B), fontWeight: FontWeight.bold), 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
