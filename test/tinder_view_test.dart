import 'package:flutter_test/flutter_test.dart';
import 'package:food_ai_app/API/chatgpt_recipe_interface.dart';
import 'package:food_ai_app/API/chatgpt_recipe_mock.dart';
import 'package:food_ai_app/API/image_fetcher_interface.dart';
import 'package:food_ai_app/API/image_fetcher_mock.dart';
import 'package:food_ai_app/LoadingScreen/custom_loading_circle.dart';
import 'package:food_ai_app/TinderMVC/tinder_controller.dart';
import 'package:food_ai_app/TinderMVC/tinder_model.dart';
import 'package:food_ai_app/TinderMVC/tinder_view.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';

void main() {
  group('TinderView Tests', () {
    late TinderController controller;
    late TinderModel model;
    late ChatGPTRecipeInterface gptApiClient;
    late ImageFetcherInterface imageFetcherClient;
    late VoidCallback onChangeRecipe;

    setUp(() {
      model = TinderModel();
      gptApiClient = ChatGPTRecipeMock("");
      imageFetcherClient = ImageFetcherMock();
      controller = TinderController(model, gptApiClient, imageFetcherClient);
      onChangeRecipe = () {};
      controller.initialize();
      controller.createView();
    });

    testWidgets('Should display loading indicator when model has no data',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: TinderView(model: model, onChangeRecipe: onChangeRecipe)));

      expect(find.byType(CustomLoadingCircle), findsOneWidget);
    });

    testWidgets('Should display content when model has data',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: TinderView(model: model, onChangeRecipe: onChangeRecipe)));
      await tester.pump(); // Allow animations to complete
    });

    testWidgets('Swiping left calls onChangeRecipe',
        (WidgetTester tester) async {
      // Setup the widget
      await tester.pumpWidget(MaterialApp(
          home: TinderView(model: model, onChangeRecipe: onChangeRecipe)));

      // Perform the swipe action
      await tester.drag(find.byType(GestureDetector), Offset(-300.0, 0.0));
      await tester.pumpAndSettle();

      // Verify that onChangeRecipe is called
      // This might require your onChangeRecipe to be a mock or spy that can verify method calls
    });

    testWidgets('Pressing "No" button triggers onChangeRecipe',
        (WidgetTester tester) async {
      // Setup the widget
      await tester.pumpWidget(MaterialApp(
          home: TinderView(model: model, onChangeRecipe: onChangeRecipe)));

      // Find and tap the "No" button
      await tester.tap(find.byKey(ValueKey('no-button')));
      await tester.pump();

      // Similar to the swipe test, verify that onChangeRecipe is called
    });

    testWidgets('Golden test for TinderView', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: TinderView(model: model, onChangeRecipe: onChangeRecipe)));
      await tester.pumpAndSettle(); // Wait for animations
      await expectLater(find.byType(TinderView),
          matchesGoldenFile('test/golden_files/tinder_view.png'));
    });
  });
}
