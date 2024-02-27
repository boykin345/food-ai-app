import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    fetchhealthGoals();
  }

  void initializeHealthGoals() async {
    firestore.collection('users').doc('TestUser').collection('Personalisation').doc('Personalisation').update({
      'healthGoals': FieldValue.arrayUnion(['Gain muscle'])
    });

    firestore.collection('users').doc('TestUser').collection('Personalisation').doc('Personalisation').update({
      'healthGoals': FieldValue.arrayUnion(['Lose weight'])
    });
  }
  
  void fetchhealthGoals() async {
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
      } else {
        healthGoals = [];
        checkedHealthGoals = {};
      }
    });
  }

  void addPreference() {
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

  void removePreference(String preference) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('healthGoals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: goalsController,
              decoration: InputDecoration(
                labelText: 'Add a new Preference',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addPreference,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: healthGoals.length,
                itemBuilder: (context, index) {
                  String currentPreference = healthGoals[index];
                  return CheckboxListTile(
                    title: Text(currentPreference),
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
                      onPressed: () => removePreference(currentPreference),
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
