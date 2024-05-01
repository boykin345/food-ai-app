import 'package:flutter/material.dart';

/// A StatefulWidget that displays and allows editing of a single ingredient with its quantity.
///
/// This widget provides a ListTile that shows the ingredient's name and quantity.
/// It can toggle to edit mode where the user can update these details.
class Ingredients extends StatefulWidget {
  /// The title of the ingredient.
  final String title;

  /// The quantity of the ingredient, defaulting to an empty string if not provided.
  final String quantity;

  /// A callback function triggered when the delete icon is tapped.
  final VoidCallback onDelete;

  /// A callback function that is called when the save icon is tapped.
  /// It passes the new name and quantity of the ingredient.
  final Function(String newName, String newQuantity) onEdit;

  /// Constructs an instance of [Ingredients].
  ///
  /// Requires [title] for the ingredient's name, and [onDelete], [onEdit] callbacks for managing
  /// ingredient deletion and updates.
  const Ingredients({
    super.key,
    required this.title,
    this.quantity = '',
    required this.onDelete,
    required this.onEdit,
  });

  @override
  _IngredientsState createState() => _IngredientsState();
}

/// The state class for [Ingredients] widget that handles editing and viewing of an ingredient.
class _IngredientsState extends State<Ingredients> {
  /// Indicates whether the ingredient is currently in edit mode.
  bool isEditing = false;

  /// Controller for editing the ingredient's name.
  final TextEditingController nameController = TextEditingController();

  /// Controller for editing the ingredient's quantity.
  final TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.title;
    quantityController.text = widget.quantity;
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  /// Toggles the editing state of this ingredient widget.
  void toggleEdit() => setState(() => isEditing = !isEditing);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: isEditing
          ? buildEditFields()
          : ListTile(
              onTap: () {
                print('Clicked On Ingredient');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              tileColor: Colors.white,
              title: Text(
                nameController.text,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              subtitle: Text(
                quantityController.text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.black,
                    onPressed: toggleEdit,
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    color: Colors.red,
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
    );
  }

  /// Builds the editing fields when the widget is in editing mode.
  ///
  /// Provides text fields for ingredient name and quantity, and buttons for saving or
  /// canceling edits.
  Widget buildEditFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: nameController,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20), // Text color
            decoration: InputDecoration(
              labelText: 'Ingredient',
              labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20), // Label text color
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                // Normal border color
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                // Border color when TextField is focused
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            cursorColor: Colors.white,
            controller: quantityController,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20), // Text color
            decoration: InputDecoration(
              labelText: 'Quantity',
              labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20), // Label text color
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                // Normal border color
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                // Border color when TextField is focused
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.save),
          color: Colors.white,
          onPressed: () {
            widget.onEdit(nameController.text, quantityController.text);
            toggleEdit();
          },
        ),
        IconButton(
          icon: Icon(Icons.cancel),
          color: Colors.red,
          onPressed: () {
            nameController.text = widget.title;
            quantityController.text = widget.quantity;
            toggleEdit();
          },
        ),
      ],
    );
  }
}
