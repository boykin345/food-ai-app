import 'package:flutter/material.dart';
import 'package:food_ai_app/LoginPages/login_signup_page.dart';
import 'package:food_ai_app/Util/data_util.dart';

import 'package:food_ai_app/Util/colours.dart';

/// Initialises the state for the forgot password page.
class ForgotPasswordPage extends StatefulWidget {
  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

/// Returns a scaffold widget to display the forgot password page.
class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Controls for the editable text fields within the page.
  final emailController = TextEditingController();

  // Whether the user has interacted with a particular text field.
  bool emailInteracted = false;

  // Managed the focus state of the text fields within the pages.
  late FocusNode emailFocusNode;

  /// Called when the widget is initialised to setup properties for the widget to function.
  @override
  void initState() {
    super.initState();

    // Sets up the focus nodes for the text fields.
    emailFocusNode = FocusNode();

    // Adds a listener to track changes to the email text field.
    emailFocusNode.addListener(() {
      setState(() {
        emailInteracted = !emailFocusNode.hasFocus;
      });
    });
  }

  /// Called when the widget is no longer need to release the resources used.
  @override
  void dispose() {
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.backgroundOff,
      appBar: AppBar(
        backgroundColor: Colours.primary,
        iconTheme: IconThemeData(color: Colours.backgroundOff),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Container(
              child: Center(
                  child: Text(
                      'Enter your email address and we will send a link to reset your password',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 12.0, bottom: 12.0, left: 12.0, right: 12.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextField(
                controller: emailController,
                focusNode: emailFocusNode,
                decoration: InputDecoration(
                  hintText: "Info@gmail.com",
                  hintStyle: TextStyle(fontSize: 14, color: Colours.greyText),
                  errorText: LoginSignupPageState.validateEmail(
                      emailController.text, emailInteracted),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: MaterialButton(
              onPressed: passwordReset,
              child: Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              color: Colours.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Called when the user presses on the reset password button.
  ///
  /// Performs multiple checks to ensure the email address is valid, if so will send a reset password link to the user.
  Future<void> passwordReset() async {
    // Checks the email entered is valid, otherwise return.
    emailInteracted = true;
    if (LoginSignupPageState.validateEmail(
            emailController.text.trim(), emailInteracted) !=
        null) {
      FocusScope.of(context).requestFocus(emailFocusNode);
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).unfocus();
      return;
    }

    final bool result =
        await AuthUtil.resetPassword(emailController.text.trim());

    if (result == true) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content:
                    Text("Password reset link sent! Check your email inbox."));
          });
      return;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    "This email address is not associated to an account, consider signing up using the email address instead"));
          });
    }
  }
}
