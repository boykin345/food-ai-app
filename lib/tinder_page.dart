import 'package:flutter/cupertino.dart';
import 'package:food_ai_app/tinder_controller.dart';
import 'package:food_ai_app/tinder_model.dart';
import 'api_mock.dart';

class TinderPage extends StatefulWidget {
  @override
  _TinderPageState createState() => _TinderPageState();
}

class _TinderPageState extends State<TinderPage> {
  late TinderController controller;
  late TinderModel model;
  late MockApiClient apiClient;

  @override
  void initState() {
    super.initState();
    model = TinderModel();
    apiClient = MockApiClient();
    controller = TinderController(model, apiClient);
    controller.onModelUpdated = () {
      setState(() {
        // This will rebuild the TinderPage with the updated model
      });
    };
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return controller
        .createView(); // This will create the view with current model data
  }
}
