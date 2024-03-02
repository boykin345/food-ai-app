import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/LoadingScreen/custom_loading_circle.dart';

import '../FullRecipeGeneration/recipe_overview.dart';

/// A widget that displays a Tinder-like swipe view for recipes.
/// It shows a loading screen until the data is available and then displays the recipe content.
class TinderView extends StatefulWidget {
  /// The model containing recipe data.
  final TinderModel model;

  /// Callback function to invoke when the recipe should be changed.
  final VoidCallback onChangeRecipe;

  /// Object which handles operations for full recipe generation
  final RecipeOverview recipeOverview;

  /// Constructs a [TinderView] with required [model] and [onChangeRecipe] callback and [recipeOverview] object.
  TinderView(
      {super.key,
      required this.model,
      required this.onChangeRecipe,
      required this.recipeOverview});

  @override
  TinderViewState createState() => TinderViewState();
}

class TinderViewState extends State<TinderView> {
  /// Tracks if the view is currently loading data.
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    /// Adds a listener to the model for data changes and updates the loading state accordingly.
    widget.model.addListener(_onModelChange);
  }

  @override
  void dispose() {
    /// Removes the model listener on widget disposal to prevent memory leaks.
    widget.model.removeListener(_onModelChange);
    super.dispose();
  }

  /// Updates the loading state based on the model's data availability.
  void _onModelChange() {
    if (_isLoading && widget.model.hasData()) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handles swipe actions to change the recipe based on the swipe direction.
  void _onSwipe(DismissDirection direction) {
    print('Swipe detected: $direction'); // 这行代码用于输出滑动方向

    if (direction == DismissDirection.endToStart) {
      // Swiped Left - No
      widget.onChangeRecipe();
    } else if (direction == DismissDirection.startToEnd) {
      // Swiped Right - Yes
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => widget.recipeOverview),
      );
    }
    // Refresh view
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    /// Builds the view based on the current loading state and model's data.

    _isLoading = !widget.model.hasData();

    return Scaffold(
      backgroundColor: Color(0xFF2D3444),
      body: _isLoading ? buildLoadingScreen() : buildContent(context),
    );
  }

  /// Builds and returns the loading screen widget.
  Widget buildLoadingScreen() {
    return Center(
      child: CustomLoadingCircle(),
    );
  }

  /// Builds and returns the main content of the TinderView, including the recipe image and description.
  Widget buildContent(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Caviar Dreams',
          ),
    );

    final double buttonHeight = 60;
    final double imageHeight = 300;
    final double imageWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: Color(0xFF2D3444),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Color(0xFF2D3444),
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Based on your Fridge\nBON APPETIT!",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Color(0xFFF5F5F5),
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(height: buttonHeight / 2),
            GestureDetector(
              key: Key('swipeGestureDetector'),
              onHorizontalDragEnd: (dragEndDetails) {
                if (dragEndDetails.primaryVelocity! < 0) {
                  _onSwipe(DismissDirection.endToStart);
                } else if (dragEndDetails.primaryVelocity! > 0) {
                  _onSwipe(DismissDirection.startToEnd);
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: imageHeight,
                    width: imageWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                    ),
                    child: widget.model.getRecipeImage().isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.memory(
                              base64Decode(widget.model.getRecipeImage()),
                              fit: BoxFit.contain,
                            ),
                          )
                        : Icon(Icons.image, size: 100, color: Colors.white54),
                  ),

                  // Buttons Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // No Button
                          ElevatedButton(
                            key: ValueKey('no-button'),
                            onPressed: widget.onChangeRecipe,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(15),
                            ),
                            child: Icon(Icons.close,
                                size: 50, color: Colors.white),
                          ),
                          // Yes Button
                          ElevatedButton(
                            key: ValueKey('yes-button'),
                            onPressed: () {
                              widget.recipeOverview.getDish();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        widget.recipeOverview),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(15),
                            ),
                            child: Icon(Icons.check,
                                size: 50, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: buttonHeight / 2),
            // Recipe Description Container
            Container(
              width: double.infinity,
              color: Color(0xFF2D3444),
              padding: EdgeInsets.all(16.0),
              child: Text(
                widget.model.getRecipeDescription(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Color(0xFFF5F5F5),
                  fontSize: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
