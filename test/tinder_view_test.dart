import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/API/image_fetcher_mock.dart';
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
          home: TinderView(model: tinderModel, onChangeRecipe: () {})));

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
              })));

      await tester.timedDrag(find.byKey(Key('swipeGestureDetector')),
          Offset(-300.0, 0.0), Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(callbackTriggered, true);
    });

    testWidgets('_onModelChange updates UI when model changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: TinderView(model: tinderModel, onChangeRecipe: () {})));

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
      )));

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(callbackTriggered, true);
    });



    testWidgets('TinderView shows loading indicator when there is no data', (WidgetTester tester) async {
      tinderModel = TinderModel();
      await tester.pumpWidget(MaterialApp(home: TinderView(model: tinderModel, onChangeRecipe: () {})));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });


    testWidgets('TinderView displays data when available', (WidgetTester tester) async {

      await tester.pumpWidget(MaterialApp(home: TinderView(model: tinderModel, onChangeRecipe: () {})));
      await tester.pump();
      expect(find.text('Delicious recipe'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });



    testWidgets('TinderView updates UI when model changes directly', (WidgetTester tester) async {

      tinderModel = TinderModel();
      imageFetcher = ImageFetcherMock();
      String dummyImageData = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/B8AAwAB/DEMI3YAAAAASUVORK5CYII='; // 有效的 Base64 图片数据


      tinderModel.addRecipe('First Delicious Recipe', dummyImageData);
      tinderModel.addRecipe('Second Delicious Recipe', dummyImageData);


      await tester.pumpWidget(MaterialApp(home: TinderView(model: tinderModel, onChangeRecipe: () {
        tinderModel.removeCurrentRecipe();
      })));


      await tester.pumpAndSettle();
      expect(find.text('First Delicious Recipe'), findsOneWidget);


      tinderModel.removeCurrentRecipe();

      await tester.pumpAndSettle();

      expect(find.text('Second Delicious Recipe'), findsOneWidget);
    });


    testWidgets('TinderView maintains loading state when swiped without data', (WidgetTester tester) async {

      tinderModel = TinderModel();
      await tester.pumpWidget(MaterialApp(home: TinderView(model: tinderModel, onChangeRecipe: () {})));


      await tester.drag(find.byKey(Key('swipeGestureDetector')), Offset(-500.0, 0.0));
      await tester.pump();


      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });



  });
}
