import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                labelStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
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
