import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:food_ai_app/IngredientVerification/ingredients.dart';
import 'package:food_ai_app/IngredientVerification/mock_ingredients.dart';
import 'package:food_ai_app/SettingsPage/Settings.dart';

import 'package:food_ai_app/Util/colours.dart';
import 'package:food_ai_app/Util/custom_app_bar.dart';
import 'package:food_ai_app/Util/customer_drawer.dart';
import 'package:food_ai_app/Util/navigation_buttons.dart';

/// A StatefulWidget that provides a UI for viewing and managing a list of ingredients.
///
/// This widget allows the user to add, edit, and delete ingredients from a given list.
/// It utilizes autocomplete for ingredient names based on a JSON data file.
class IngredientEditing extends StatefulWidget {
  /// The initial map of ingredients and their quantities.
  final Map<String, String> ingredientsMapCons;

  /// Creates a new instance of [IngredientEditing] with the specified initial ingredient map.
  const IngredientEditing({super.key, required this.ingredientsMapCons});

  @override
  IngredientEditingState createState() => IngredientEditingState();
}

/// The state class for [IngredientEditing] that manages the editing of ingredients.
class IngredientEditingState extends State<IngredientEditing> {
  /// A mock database of ingredients, used for demonstration.
  final mockIngredients = MockIngredients();

  /// A set containing names of food items loaded from an asset file.
  Set<String> foodNames = {};

  /// A map holding the names and quantities of the ingredients being edited.
  Map<String, String> ingredientsMap = {};

  /// Controller for the text field that allows editing the name of an ingredient.
  late TextEditingController ingredientNameController = TextEditingController();

  /// Controller for the text field that allows editing the quantity of an ingredient.
  final TextEditingController ingredientQuantityController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    ingredientsMap = widget.ingredientsMapCons;
    //ingredientsMap = mockIngredients.getMap();

    loadFoodNames().then((loadedNames) {
      setState(() {
        foodNames = loadedNames;
      });
    });
  }

  @override
  void dispose() {
    ingredientNameController.dispose();
    ingredientQuantityController.dispose();
    super.dispose();
  }

  /// Loads and returns a set of food names from a JSON asset.
  Future<Set<String>> loadFoodNames() async {
    final String response =
        await rootBundle.loadString('assets/data/food_names.json');
    final List<dynamic> data = json.decode(response) as List<dynamic>;
    return data.map<String>((item) => item.toString()).toSet();
  }

  /// Builds a list of [Ingredients] widgets from a map of ingredient items.
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

  /// Validates and adds an ingredient and its quantity to the map if the item exists in [foodNames].
  Future<void> validateAndAddItem(String itemName, String quantity) async {
    final Set<String> foodNames = await loadFoodNames();
    if (foodNames.contains(itemName)) {
      addItemToIngredientsMap(itemName, quantity);
    } else {
      print("Not Found");
    }
  }

  /// Validates and updates an ingredient's name and quantity if the new name exists in [foodNames].
  Future<void> validateAndEditIngredient(
      String oldName, String newName, String newQuantity) async {
    final Set<String> foodNames = await loadFoodNames();

    if (foodNames.contains(newName)) {
      editIngredient(oldName, newName, newQuantity);
    } else {
      print("Not Found");
    }
  }

  /// Edits an ingredient by updating its name and quantity in the map.
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

  /// Adds a new ingredient to the top of the map, ensuring any existing entry for that ingredient is updated.
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

  /// Removes an ingredient from the map.
  void removeIngredient(String itemName) {
    setState(() {
      ingredientsMap.remove(itemName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0, bottom: 15),
              child: Text(
                'Based on your Fridge \nWE DETECTED',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10.0, left: 15.0, right: 15.0, bottom: 15),
              child: searchBox(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                children: _buildIngredientWidgets(ingredientsMap),
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
                    builder: (context) => SettingsScreen(
                      ingredientsMapCons: ingredientsMap,
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

  /// Returns a search box widget that includes an autocomplete field for ingredient names and a text field for quantities.
  Widget searchBox() {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return foodNames.where((String option) {
                  return option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                ingredientNameController = textEditingController;

                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Ingredient',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w900),
                  ),
                );
              },
              onSelected: (String selection) {
                ingredientNameController.text = selection;
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: ingredientQuantityController,
              decoration: InputDecoration(
                hintText: 'Quantity',
                border: InputBorder.none,
                hintStyle:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w900),
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
}
