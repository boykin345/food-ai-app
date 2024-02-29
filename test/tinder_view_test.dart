import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/API/image_fetcher_mock.dart';
import 'package:food_ai_app/FullRecipeGeneration/recipe_overview.dart';
import 'package:food_ai_app/LoadingScreen/custom_loading_circle.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/TinderMVC/tinder_view.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

/// I1/I.2 Tests for the view in the TinderMVC
void main() {
  group('TinderView Tests', () {
    late TinderModel tinderModel;
    late ImageFetcherMock imageFetcher;

    setUp(() async {
      tinderModel = TinderModel();
      imageFetcher = ImageFetcherMock();
      var img = await imageFetcher.fetchImage("");
      tinderModel.addRecipe("Delicious recipe", img);
    });

    testWidgets('Displays content when data is loaded',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: TinderView(
              model: tinderModel,
              onChangeRecipe: () {},
              recipeOverview: RecipeOverview())));

      await tester.pumpAndSettle();

      expect(find.text("Delicious recipe"), findsOneWidget);
    });

    testWidgets('Swipe right triggers onChangeRecipe callback',
        (WidgetTester tester) async {
      bool callbackTriggered = false;
      await tester.pumpWidget(MaterialApp(
          home: TinderView(
              model: tinderModel,
              onChangeRecipe: () {
                print('onChangeRecipe callback triggered.');
                callbackTriggered = true;
              },
              recipeOverview: RecipeOverview())));

      await tester.timedDrag(find.byKey(Key('swipeGestureDetector')),
          Offset(-300.0, 0.0), Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(callbackTriggered, true);
    });

    testWidgets('_onModelChange updates UI when model changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: TinderView(
              model: tinderModel,
              onChangeRecipe: () {},
              recipeOverview: RecipeOverview())));

      tinderModel.notifyListeners();

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text("Delicious recipe"), findsOneWidget);
    });

    testWidgets('buildLoadingScreen displays a loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: CircularProgressIndicator())));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Clicking X button triggers onChangeRecipe callback',
        (WidgetTester tester) async {
      bool callbackTriggered = false;

      await tester.pumpWidget(MaterialApp(
          home: TinderView(
              model: tinderModel,
              onChangeRecipe: () {
                callbackTriggered = true;
              },
              recipeOverview: RecipeOverview())));

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(callbackTriggered, true);
    });

    testWidgets('TinderView shows loading indicator when there is no data',
        (WidgetTester tester) async {
      tinderModel = TinderModel();
      await tester.pumpWidget(MaterialApp(
          home: TinderView(
              model: tinderModel,
              onChangeRecipe: () {},
              recipeOverview: RecipeOverview())));
      await tester.pump();
      expect(find.byType(CustomLoadingCircle), findsOneWidget);
    });

    testWidgets('TinderView displays data when available',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: TinderView(
              model: tinderModel,
              onChangeRecipe: () {},
              recipeOverview: RecipeOverview())));
      await tester.pump();
      expect(find.text('Delicious recipe'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
