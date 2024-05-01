import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_ai_app/FullRecipeGeneration/recipe_overview.dart';
import 'package:food_ai_app/LoadingScreen/custom_loading_circle.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/Util/colours.dart';
import 'package:food_ai_app/Util/custom_app_bar.dart';
import 'package:food_ai_app/Util/customer_drawer.dart';

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
  bool isLoading = true;
  bool isLoadingRecipe = false;

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
    if (isLoading && widget.model.hasData()) {
      if (mounted) {
        setState(() {
          isLoading = false;
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

    isLoading = !widget.model.hasData();

    return Scaffold(
      backgroundColor: Colours.primary,
      body: isLoading || isLoadingRecipe
          ? buildLoadingScreen()
          : buildContent(context),
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
    final double imageHeight = 300;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth * 0.9;
    final double sidePadding = (screenWidth - imageWidth) * 2;
    final double textMargin = (screenWidth - imageWidth) - 15;
    final double secondImageHeight = imageHeight - (imageHeight * 0.9);
    final double secondImageWidth = screenWidth / 2;

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      backgroundColor: Colours.primary,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(
                "Based on your Fridge",
                style: TextStyle(
                  fontSize: 30,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "BON APPETIT!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colours.backgroundOff,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15.0),
            ),
            GestureDetector(
              key: Key('swipeGestureDetector'),
              onHorizontalDragEnd: (dragEndDetails) {
                if (dragEndDetails.primaryVelocity! < 0) {
                  _onSwipe(DismissDirection.endToStart);
                } else if (dragEndDetails.primaryVelocity! > 0) {
                  _onSwipe(DismissDirection.startToEnd);
                }
              },
              child: Column(
                children: [
                  Container(
                    height: imageHeight,
                    width: imageWidth,
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Second image (background)
                        Positioned(
                          left: secondImageWidth,
                          bottom: secondImageHeight,
                          child: widget.model.getSecondRecipeImage().isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    children: [
                                      Image.memory(
                                        base64Decode(widget.model
                                            .getSecondRecipeImage()),
                                        fit: BoxFit.contain,
                                        height: imageHeight * 0.8,
                                        width: imageWidth * 0.8,
                                      ),
                                      Container(
                                        height: imageHeight * 0.8,
                                        width: imageWidth * 0.8,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(), // Placeholder
                        ),
                        // First image (foreground)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: widget.model.getRecipeImage().isNotEmpty
                              ? Image.memory(
                                  base64Decode(widget.model.getRecipeImage()),
                                  fit: BoxFit.contain,
                                )
                              : Icon(Icons.image,
                                  size: 100, color: Colours.backgroundOff),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, sidePadding, 0),
                    // Buttons Overlay
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Yes Button
                        ElevatedButton(
                          key: ValueKey('yes-button'),
                          onPressed: () async {
                            setState(() {
                              isLoadingRecipe = true; // Start loading
                            });
                            await widget.recipeOverview.getDish();

                            setState(() {
                              isLoadingRecipe = false; // End  loading
                            });

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => widget.recipeOverview),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(15),
                          ),
                          child: Icon(Icons.check,
                              size: 50, color: Colours.backgroundOff),
                        ),
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
                              size: 50, color: Colours.backgroundOff),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 15.0),
              child: Text(
                "DISH DETAILS...",
                style: TextStyle(
                  fontSize: 30,
                  color: Colours.backgroundOff,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15.0),
            ),
            // Recipe Description Container
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, textMargin + 30, 0),
              color: Colours.primary,
              padding: EdgeInsets.all(15.0),
              child: Wrap(
                children: [
                  Text(
                    widget.model.getRecipeDescription(),
                    style: TextStyle(
                      color: Colours.backgroundOff,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
