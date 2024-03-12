import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllergiesScreen extends StatefulWidget {
  @override
  _AllergiesScreenState createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  List<String> allergies = [];
  final TextEditingController allergyController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchAllergies();
  }

  Future<void> fetchAllergies() async {
    try {
      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(user?.uid).get();
      setState(() {
        var userData = userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData['allergies'] is List<dynamic>) {
          allergies = (userData['allergies'] as List<dynamic>).cast<String>();
        } else {
          allergies = [];
        }
      });
    } catch (error) {
      print('Error fetching allergies: $error');
    }
  }

  Future<void> _addAllergy() async {
    try {
      if (allergyController.text.isNotEmpty) {
        setState(() {
          allergies.add(allergyController.text);
        });
        await firestore.collection('users').doc(user?.uid).update({
          'allergies': FieldValue.arrayUnion([allergyController.text])
        });
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
      await firestore.collection('users').doc(user?.uid).update({
        'allergies': FieldValue.arrayRemove([allergy])
      });
    } catch (error) {
      print('Error removing allergy: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergies', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: allergyController,
              decoration: InputDecoration(
                labelText: 'Add a new Dietary need',
                labelStyle: TextStyle(color: Colors.black),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
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
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        allergies[index],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () => _removeAllergy(allergies[index]),
                      ),
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
