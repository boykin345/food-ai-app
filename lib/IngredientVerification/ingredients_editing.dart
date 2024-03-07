import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:food_ai_app/IngredientVerification/ingredients.dart';

import 'package:food_ai_app/IngredientVerification/mock_ingredients.dart';
import 'package:food_ai_app/SettingsPage/Preferences.dart';

import 'package:food_ai_app/SettingsPage/Settings.dart';

class IngredientEditing extends StatefulWidget {
  final Map<String, String> ingredientsMapCons;

  const IngredientEditing({super.key, required this.ingredientsMapCons});

  @override
  IngredientEditingState createState() => IngredientEditingState();
}

class IngredientEditingState extends State<IngredientEditing> {
  //final mockIngredients = MockIngredients();
  Map<String, String> ingredientsMap = {};
  final TextEditingController ingredientNameController =
      TextEditingController();
  final TextEditingController ingredientQuantityController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    ingredientsMap = widget.ingredientsMapCons;
    //ingredientsMap = mockIngredients.getMap();
  }

  @override
  void dispose() {
    ingredientNameController.dispose();
    ingredientQuantityController.dispose();
    super.dispose();
  }

  Future<Set<String>> loadFoodNames() async {
    final String response =
        await rootBundle.loadString('assets/data/food_names.json');
    final List<dynamic> data = json.decode(response) as List<dynamic>;
    return data.map<String>((item) => item.toString()).toSet();
  }

  List<Widget> _buildIngredientWidgets(Map<String, String> items) {
    return items.entries.map((entry) {
      return Ingredients(
        key: ValueKey(entry.key),
        title: entry.key,
        quantity: entry.value,
        onDelete: () => removeIngredient(entry.key),
        onEdit: (newName, newQuantity) =>
            validateAndEditIngredient(entry.key, newName, newQuantity),
      );
    }).toList();
  }

  Future<void> validateAndAddItem(String itemName, String quantity) async {
    final Set<String> foodNames = await loadFoodNames();
    if (foodNames.contains(itemName)) {
      addItemToIngredientsMap(itemName, quantity);
    } else {
      print("Not Found");
    }
  }

  Future<void> validateAndEditIngredient(
      String oldName, String newName, String newQuantity) async {
    final Set<String> foodNames = await loadFoodNames();

    if (foodNames.contains(newName)) {
      editIngredient(oldName, newName, newQuantity);
    } else {
      print("Not Found");
    }
  }

  void editIngredient(String oldName, String newName, String newQuantity) {
    setState(() {
      final bool isNameUpdated = oldName != newName;

      if (isNameUpdated && !ingredientsMap.containsKey(oldName)) {
        // If the old name doesn't exist then add new name
        ingredientsMap[newName] = newQuantity;
      } else {
        // Create a new map to update the item in place
        final Map<String, String> updatedItems = {};
        ingredientsMap.forEach((key, value) {
          if (key == oldName) {
            // Replace with new name and quantity
            updatedItems[newName] = newQuantity;
          } else {
            // Copy all other items as they were
            updatedItems[key] = value;
          }
        });

        ingredientsMap = updatedItems;
      }
    });
  }

  void addItemToIngredientsMap(String itemName, String quantity) {
    setState(() {
      // Removes the item if it exists to add it back and to move it to the top
      final existingQuantity = ingredientsMap.remove(itemName);
      final newItems = Map<String, String>.from({itemName: quantity});

      // Only adds back the existing items if the item was in previous map
      if (existingQuantity != null) {
        newItems.addAll(ingredientsMap);
        ingredientsMap = newItems;
      } else {
        // If the item wasn't there before, just add it at the top
        ingredientsMap = {
          itemName: quantity,
          ...ingredientsMap,
        };
      }
    });
  }

  void removeIngredient(String itemName) {
    setState(() {
      ingredientsMap.remove(itemName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Caviar Dreams',
            ),
      ),
      home: Scaffold(
        backgroundColor: Color(0xFF2D3444),
        appBar: _buildAppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 05, vertical: 0),
          child: Column(
            children: [
              Text(
                'Based on your Fridge \nWE DETECTED',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              searchBox(),
              Expanded(
                child: ListView(
                  children: _buildIngredientWidgets(ingredientsMap),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          },
          child: Icon(Icons.check_box),
          backgroundColor: Colors.blue,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ingredientNameController, // Update ingredient name
              decoration: InputDecoration(
                hintText: 'Ingredient',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: ingredientQuantityController, // Update quantity
              decoration: InputDecoration(
                hintText: 'Quantity',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              final itemName = ingredientNameController.text;
              final quantity = ingredientQuantityController.text;
              if (itemName.isNotEmpty && quantity.isNotEmpty) {
                validateAndAddItem(itemName, quantity);
                ingredientNameController.clear();
                ingredientQuantityController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF2D3444),
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: Colors.black,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            child: Image.asset('assets/pflpic.png'),
          ),
        ),
      ]),
    );
  }
}
