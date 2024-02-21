import 'package:flutter/material.dart';

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
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor:
            Colors.blue[900], // Set app bar background color to dark blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
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
                        fontSize: 18, // Adjust font size here
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18, // Adjust font size here
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 3,
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18, // Adjust font size here
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 4,
                    child: Text(
                      '4',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18, // Adjust font size here
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 5,
                    child: Text(
                      '5 (Hard)',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18, // Adjust font size here
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDifficulty = value!;
                  });
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  labelText: 'Difficulty',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 24, // Adjust label font size here
                  ),
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
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
                        fontSize: 18, // Adjust font size here
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCookingTime = value!;
                  });
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  labelText: 'Cooking Time',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 24, // Adjust label font size here
                  ),
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
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
                        fontSize: 18, // Adjust font size here
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text(
                      'For 2 people',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18, // Adjust font size here
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 4,
                    child: Text(
                      'For 4 people',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18, // Adjust font size here
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 6,
                    child: Text(
                      'For 6 people',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18, // Adjust font size here
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPortionSize = value!;
                  });
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  labelText: 'Portion Size',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 24, // Adjust label font size here
                  ),
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
          ],
        ),
      ),
    );
  }
}
