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
            DropdownButtonFormField<int>(
              value: _selectedDifficulty,
              items: [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('1 (Easy)'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('2'),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('3'),
                ),
                DropdownMenuItem<int>(
                  value: 4,
                  child: Text('4'),
                ),
                DropdownMenuItem<int>(
                  value: 5,
                  child: Text('5 (Hard)'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Difficulty',
                labelStyle:
                    TextStyle(color: Colors.white), // Set label color to white
              ),
            ),
            DropdownButtonFormField<String>(
              value: _selectedCookingTime,
              items: [
                '30 min',
                '1 h',
                '2 h',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCookingTime = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Cooking Time',
                labelStyle:
                    TextStyle(color: Colors.white), // Set label color to white
              ),
            ),
            DropdownButtonFormField<int>(
              value: _selectedPortionSize,
              items: [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('For 1 person'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('For 2 people'),
                ),
                DropdownMenuItem<int>(
                  value: 4,
                  child: Text('For 4 people'),
                ),
                DropdownMenuItem<int>(
                  value: 6,
                  child: Text('For 6 people'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPortionSize = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Portion Size',
                labelStyle:
                    TextStyle(color: Colors.white), // Set label color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
