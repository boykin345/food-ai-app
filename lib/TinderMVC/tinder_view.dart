import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';

import '../LoadingScreen/custom_loading_circle.dart';

class TinderView extends StatefulWidget {
  final TinderModel model;
  final VoidCallback onChangeRecipe;

  TinderView({super.key, required this.model, required this.onChangeRecipe});

  @override
  _TinderViewState createState() => _TinderViewState();
}

class _TinderViewState extends State<TinderView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Add model listener
    widget.model.addListener(_onModelChange);
  }

  @override
  void dispose() {
    // Remove model listener
    widget.model.removeListener(_onModelChange);
    super.dispose();
  }

  void _onModelChange() {
    // Check if the loading screen is being displayed and if data is now available
    if (_isLoading && widget.model.hasData()) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onSwipe(DismissDirection direction) {
    if (direction == DismissDirection.endToStart) {
      // Swiped Left - No
      widget.onChangeRecipe();
    } else if (direction == DismissDirection.startToEnd) {
      // Swiped Right - Yes
      // Need to implement what happens when swiped right
    }
    // Refresh view
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Check if model has data
    _isLoading = !widget.model.hasData();

    return Scaffold(
      backgroundColor: Color(0xFF2D3444),
      body: _isLoading ? buildLoadingScreen() : buildContent(context),
    );
  }

  Widget buildLoadingScreen() {
    return Center(
      child: CustomLoadingCircle(),
    );
  }

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
                            onPressed: () {
                              // Handle Yes action
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
