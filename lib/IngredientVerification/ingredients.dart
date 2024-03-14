import 'package:flutter/material.dart';

class Ingredients extends StatefulWidget {
  final String title;
  final String quantity;
  final VoidCallback onDelete;
  final Function(String newName, String newQuantity) onEdit;

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

class _IngredientsState extends State<Ingredients> {
  bool isEditing = false;
  final TextEditingController nameController = TextEditingController();
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

  Widget buildEditFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
                labelText: 'Ingredient', border: OutlineInputBorder()),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            cursorColor: Colors.white,
            controller: quantityController,
            decoration: InputDecoration(
                labelText: 'Quantity', border: OutlineInputBorder()
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
