import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_ai_app/SettingsPage/health_goals.dart';

import 'package:food_ai_app/Util/custom_app_bar.dart';
import 'package:food_ai_app/Util/customer_drawer.dart';
import 'package:food_ai_app/Util/colours.dart';

import '../Util/navigation_buttons.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, String> ingredientsMapCons;

  const SettingsScreen({super.key, required this.ingredientsMapCons});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedDifficulty = 1;
  String _selectedCookingTime = '30 min';
  int _selectedPortionSize = 1;
  List<String> allergies = [];
  final TextEditingController allergyController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(user?.uid).get();
      setState(() {
        var userData = userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null) {
          _selectedDifficulty =
              userData['difficulty'] is int ? userData['difficulty'] as int : 1;
          _selectedCookingTime = userData['cookingTime'] is String
              ? userData['cookingTime'] as String
              : '30 min';
          _selectedPortionSize = userData['portionSize'] is int
              ? userData['portionSize'] as int
              : 1;
          if (userData['allergies'] is List<dynamic>) {
            allergies = (userData['allergies'] as List<dynamic>).cast<String>();
          } else {
            allergies = [];
          }
        }
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _updateSettings() async {
    try {
      await firestore.collection('users').doc(user?.uid).update({
        'difficulty': _selectedDifficulty,
        'cookingTime': _selectedCookingTime,
        'portionSize': _selectedPortionSize,
        'allergies': allergies,
      });
    } catch (error) {
      print('Error updating settings: $error');
    }
  }

  Future<void> _addAllergy() async {
    try {
      if (allergyController.text.isNotEmpty) {
        setState(() {
          allergies.add(allergyController.text);
        });
        await _updateSettings(); // Update all user settings
        allergyController.clear();
      }
    } catch (error) {
      print('Error adding allergy: $error');
    }
  }

  Future<void> _removeAllergy(String allergy) async {
    try {
      setState(() {
        allergies.remove(allergy);
      });
      await _updateSettings(); // Update all user settings
    } catch (error) {
      print('Error removing allergy: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      backgroundColor: Colours.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Difficulty',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colours.backgroundOff,
              ),
              child: DropdownButtonFormField<int>(
                value: _selectedDifficulty,
                items: [
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text(
                      '1 (Easy)',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 3,
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 4,
                    child: Text(
                      '4',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 5,
                    child: Text(
                      '5 (Hard)',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDifficulty = value!;
                  });
                  _updateSettings();
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Cooking Time',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colours.backgroundOff,
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedCookingTime,
                items: [
                  '30 min',
                  '1 h',
                  '2 h',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCookingTime = value!;
                  });
                  _updateSettings();
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Portion Size',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colours.backgroundOff,
              ),
              child: DropdownButtonFormField<int>(
                value: _selectedPortionSize,
                items: [
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text(
                      'For 1 person',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text(
                      'For 2 people',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 4,
                    child: Text(
                      'For 4 people',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 6,
                    child: Text(
                      'For 6 people',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPortionSize = value!;
                  });
                  _updateSettings();
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: allergyController,
              decoration: InputDecoration(
                labelText: 'Add a new Dietary need',
                labelStyle: TextStyle(
                    color: Colours.backgroundOff, fontWeight: FontWeight.w800),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colours.backgroundOff,
                  ),
                  onPressed: _addAllergy,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: allergies.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colours.backgroundOff,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        allergies[index],
                        style: TextStyle(
                          color: Colours.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colours.secondary,
                        ),
                        onPressed: () => _removeAllergy(allergies[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
            NavigationButtons(
              onBack: () {
                Navigator.pop(context);
              },
              onContinue: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthGoalScreen(
                      ingredientsMapCons: widget.ingredientsMapCons,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
