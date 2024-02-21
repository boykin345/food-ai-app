import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/TinderMVC/tinder_view.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  group('TinderView Tests', () {
    testWidgets('Displays content when data is loaded', (WidgetTester tester) async {

      final tinderModel = TinderModel();

      tinderModel.addRecipe();

      await tester.pumpWidget(MaterialApp(home: TinderView(model: tinderModel, onChangeRecipe: () {})));


      await tester.pumpAndSettle();


      expect(find.text("Delicious recipe"), findsOneWidget);
    });

    testWidgets('Swipe right triggers onChangeRecipe callback', (WidgetTester tester) async {
      final tinderModel = TinderModel();

      tinderModel.addRecipe();
      bool callbackTriggered = false;
      await tester.pumpWidget(MaterialApp(home: TinderView(model: tinderModel, onChangeRecipe: () {
        print('onChangeRecipe callback triggered.');
        callbackTriggered = true;
      })));


      await tester.timedDrag(find.byKey(Key('swipeGestureDetector')), Offset(-300.0, 0.0), Duration(milliseconds: 200));
      await tester.pumpAndSettle();


      expect(callbackTriggered, true);
    });

testWidgets('_onModelChange updates UI when model changes', (WidgetTester tester) async {
  final tinderModel = TinderModel();


  tinderModel.addRecipe();

  await tester.pumpWidget(MaterialApp(home: TinderView(model: tinderModel, onChangeRecipe: () {})));


  tinderModel.notifyListeners();

  await tester.pumpAndSettle();


  expect(find.byType(CircularProgressIndicator), findsNothing);
  expect(find.text("Delicious recipe"), findsOneWidget);
});

    testWidgets('buildLoadingScreen displays a loading indicator', (WidgetTester tester) async {
      final tinderModel = TinderModel();

      await tester.pumpWidget(MaterialApp(home: TinderView(model: tinderModel, onChangeRecipe: () {})));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Clicking no button triggers onChangeRecipe callback', (WidgetTester tester) async {
      final tinderModel = TinderModel();
      tinderModel.addRecipe();
      bool callbackTriggered = false;

      await tester.pumpWidget(MaterialApp(home: TinderView(
        model: tinderModel,
        onChangeRecipe: () {
          callbackTriggered = true;
        },
      )));


      await tester.pumpAndSettle();


      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();


      expect(callbackTriggered, true);
    });


  });
}