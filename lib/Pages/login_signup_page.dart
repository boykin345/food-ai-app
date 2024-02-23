import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:food_ai_app/Util/colours.dart';
import 'package:food_ai_app/Util/data_util.dart';

/// Initialises the state for the login & sign up page.
///
/// [screenType] whether it shows the login page or the sign up page, where true will show the sign up page.
class LoginSignupPage extends StatefulWidget {
  /// Whether the we are loading the login page or the sign up page.
  final bool screenType;

  LoginSignupPage({required this.screenType});

  @override
  LoginSignupPageState createState() => LoginSignupPageState();
}

/// Returns a scaffold widget to display login/signup page with certain properties.
class LoginSignupPageState extends State<LoginSignupPage> {
  // Controllers for the editable text fields within the pages.
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Whether the user has interacted with a particular text field.
  bool usernameInteracted = false;
  bool emailInteracted = false;
  bool passwordInteracted = false;
  bool confirmPasswordInteracted = false;

  // Managed the focus state of the text fields within the pages.
  late FocusNode usernameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;

  // Whether the password text fields are obscure or not.
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  // Whether the we are loading the login page or the sign up page.
  bool isSignupScreen = false;

  /// Called when the widget is initialised to setup properties for the widget to function.
  @override
  void initState() {
    super.initState();
    // Updates the boolean value decide which page to show.
    isSignupScreen = widget.screenType;

    // Sets up the focus nodes for the text fields.
    usernameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();

    // Adds a listener to track changes to the username text field.
    usernameFocusNode.addListener(() {
      setState(() {
        usernameInteracted = !usernameFocusNode.hasFocus;
      });
    });

    // Adds a listener to track changes to the email text field.
    emailFocusNode.addListener(() {
      setState(() {
        emailInteracted = !emailFocusNode.hasFocus;
      });
    });

    // Adds a listener to track changes to the password text field.
    passwordFocusNode.addListener(() {
      setState(() {
        passwordInteracted = !passwordFocusNode.hasFocus;
      });
    });

    // Adds a listener to track changes to the confirm password text field.
    confirmPasswordFocusNode.addListener(() {
      setState(() {
        confirmPasswordInteracted = !confirmPasswordFocusNode.hasFocus;
      });
    });
  }

  /// Called when the widget is no longer need to release the resources used.
  @override
  void dispose() {
    usernameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundOff,
      body: Stack(
        children: [
          // Top part of the screen.
          Positioned(
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              padding: EdgeInsets.only(top: 90, left: 20),
              color: Palette.primary,
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Food AI",
                      style: TextStyle(
                        fontSize: 48,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Login container box.
          AnimatedPositioned(
            duration: Duration(milliseconds: 600),
            curve: Curves.bounceInOut,
            // Changes the size of the container starting height depending if it's the login page or the sign up page.
            top: isSignupScreen ? 190 : 220,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              curve: Curves.bounceInOut,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 60,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Row to change between the login page & the sign up page.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                              resetTextFields();
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "LOGIN",
                                key: Key('loginButton'),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen
                                        ? Palette.primary
                                        : Palette.greyText),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Palette.accent,
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                              resetTextFields();
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SIGN UP",
                                key: Key('signUpButton'),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Palette.primary
                                        : Palette.greyText),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Palette.accent,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Whether to show the sign up page or not.
                    if (isSignupScreen) signUpSection(),

                    // Whether to show the login page or not.
                    if (!isSignupScreen) logInSection(),

                    // Container to show the login / sign up button after the text fields.
                    Container(
                      key: ValueKey('submitButton'),
                      margin: EdgeInsets.only(
                          top: 30, bottom: 15, left: 40, right: 40),
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: isSignupScreen ? signUp : login,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(width: 2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  isSignupScreen ? "SIGN UP" : "SIGN IN",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Creates the login container.
  Container logInSection() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            // Email text field.
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                key: ValueKey('emailTextField'),
                controller: emailController,
                focusNode: emailFocusNode,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Palette.icon,
                  ),
                  contentPadding: EdgeInsets.all(10),
                  hintText: "Info@email.com",
                  hintStyle: TextStyle(fontSize: 14, color: Palette.greyText),
                  errorText: validateEmail(emailController.text),
                ),
              ),
            ),

            // Password text field.
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                key: ValueKey('passwordTextField'),
                obscureText: !passwordVisible,
                controller: passwordController,
                focusNode: passwordFocusNode,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Palette.icon,
                  ),
                  suffixIcon: IconButton(
                      key: Key('passwordVisibleButton'),
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      // When pressed will update the obscure text value to the opposite, e.g. hidden text will become visible.
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      }),
                  contentPadding: EdgeInsets.all(10),
                  hintText: "Password",
                  hintStyle: TextStyle(fontSize: 14, color: Palette.greyText),
                  errorText: validatePassword(passwordController.text),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("Forgot Password?",
                      style: TextStyle(fontSize: 12, color: Palette.greyText)),
                ),
              ],
            ),
          ],
        ));
  }

  // Creates the sign up container.
  Container signUpSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          // Username text field.
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              key: ValueKey('usernameTextField'),
              controller: usernameController,
              focusNode: usernameFocusNode,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.account_circle_outlined,
                    color: Palette.icon,
                  ),
                  contentPadding: EdgeInsets.all(10),
                  hintText: "Username",
                  hintStyle: TextStyle(fontSize: 14, color: Palette.greyText),
                  errorText: validateUsername(usernameController.text)),
            ),
          ),

          // Email text field.
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              key: ValueKey('emailTextField'),
              controller: emailController,
              focusNode: emailFocusNode,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Palette.icon,
                ),
                contentPadding: EdgeInsets.all(10),
                hintText: "Info@email.com",
                hintStyle: TextStyle(fontSize: 14, color: Palette.greyText),
                errorText: validateEmail(emailController.text),
              ),
            ),
          ),

          // Password text field.
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              key: ValueKey('passwordTextField'),
              obscureText: !passwordVisible,
              controller: passwordController,
              focusNode: passwordFocusNode,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Palette.icon,
                ),
                suffixIcon: IconButton(
                  key: Key('passwordVisibleButton'),
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  // When pressed will update the obscure text value to the opposite, e.g. hidden text will become visible.
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
                contentPadding: EdgeInsets.all(10),
                hintText: "Password",
                hintStyle: TextStyle(fontSize: 14, color: Palette.greyText),
                errorText: validatePassword(passwordController.text),
              ),
            ),
          ),

          // Confirm password text field.
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              key: ValueKey('confirmPasswordTextField'),
              obscureText: !confirmPasswordVisible,
              controller: confirmPasswordController,
              focusNode: confirmPasswordFocusNode,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Palette.icon,
                ),
                suffixIcon: IconButton(
                  key: Key('confirmPasswordVisibleButton'),
                  icon: Icon(
                    confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      confirmPasswordVisible = !confirmPasswordVisible;
                    });
                  },
                ),
                contentPadding: EdgeInsets.all(10),
                hintText: "Confirm password",
                hintStyle: TextStyle(fontSize: 14, color: Palette.greyText),
                errorText:
                    validateConfirmPassword(confirmPasswordController.text),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Validates the provided username input.
  ///
  /// Returns an error message if [username] is invalid, otherwise it will return `null`.
  String? validateUsername(String? username) {
    // Checks to see if the text field has been interacted with, if not exit early.
    if (usernameInteracted == false) {
      return null;
    }

    // Checks if the username field is empty.
    if (username == null || username.isEmpty) {
      return "Username field is empty!";
    }

    // Checks if the username length meets the minimal amount of characters.
    if (username.length < 3) {
      return "Minimum length is 3 characters!";
    }

    // Checks username doesn't exceed a certain amount of characters
    if (username.length > 32) {
      return "Maximum length is 32 characters!";
    }

    return null; // Validation successful.
  }

  /// Validates the provided email input.
  ///
  /// Returns an error message if [email] is invalid, otherwise it will return `null`.
  String? validateEmail(String? email) {
    // Checks to see if the text field has been interacted with, if not exit early.
    if (emailInteracted == false) {
      return null;
    }

    // Checks if the email field is empty.
    if (email == null || email.isEmpty) {
      return "Email address field is empty!";
    }

    // Checks email address doesn't exceed a certain amount of characters
    if (email.length > 255) {
      return "Maximum length is 255 characters!";
    }

    // Checks if the email address is in the correct format.
    if (!email.contains('@')) {
      return "Not a valid email address!";
    }

    return null; // Validation successful.
  }

  /// Validates the provided password input.
  ///
  /// Returns an error message if [password] is invalid, otherwise it will return `null`.
  String? validatePassword(String? password) {
    // Checks to see if the text field has been interacted with, if not exit early.
    if (passwordInteracted == false) {
      return null;
    }

    // Checks if the password field is empty.
    if (password == null || password.isEmpty) {
      return "Password field is empty!";
    }

    // Checks if the password length meets the minimal amount of characters.
    if (password.length < 8) {
      return "Minimum length is 8 characters!";
    }

    // Checks password doesn't exceed a certain amount of characters
    if (password.length > 32) {
      return "Maximum length is 32 characters!";
    }

    return null; // Validation successful.
  }

  /// Validates the provided confirm password input.
  ///
  /// Returns an error message if [confirmPassword] is invalid, otherwise it will return `null`.
  String? validateConfirmPassword(String? confirmPassword) {
    // Checks to see if the text field has been interacted with, if not exit early.
    if (confirmPasswordInteracted == false) {
      return null;
    }

    // Checks if the password field is empty.
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Confirm password field is empty!";
    }

    // Checks if the password length meets the minimal amount of characters.
    if (confirmPassword.length < 8) {
      return "Minimum length is 8 characters!";
    }

    // Checks confirm password doesn't exceed a certain amount of characters
    if (confirmPassword.length > 32) {
      return "Maximum length is 32 characters!";
    }

    // Checks to make sure the password field box matches the confirm password field box.
    if (passwordController.text != confirmPassword) {
      return "Passwords do not match!";
    }

    return null; // Validation successful.
  }

  /// Resets the text fields for when changing between the login & sign up pages.
  ///
  /// Will reset the text input field, if the user has interacted with the text field, and the obscure visibility of the text field.
  void resetTextFields() {
    // Reset controller text input string.
    usernameController.text = "";
    emailController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";

    // Reset the interact value of the text fields.
    usernameInteracted = false;
    emailInteracted = false;
    passwordInteracted = false;
    confirmPasswordInteracted = false;

    // Reset the obscure visibility of the text fields if they have this property.
    passwordVisible = false;
    confirmPasswordVisible = false;
  }

  /// Called when the user presses on the login button.
  ///
  /// Performs multiple checks to ensure all the data entered is valid and there is a record of the data in the database.
  Future<void> login() async {
    // Checks the email entered is valid, otherwise return.
    emailInteracted = true;
    if (validateEmail(emailController.text.trim()) != null) {
      FocusScope.of(context).requestFocus(emailFocusNode);
      FocusScope.of(context).requestFocus(FocusNode());
      return;
    }

    // Checks the password entered is valid, otherwise return.
    passwordInteracted = true;
    if (validatePassword(passwordController.text.trim()) != null) {
      FocusScope.of(context).requestFocus(passwordFocusNode);
      FocusScope.of(context).requestFocus(FocusNode());
      return;
    }

    // Checks the user is actually in the database, otherwise return null.
    User? user = await AuthUtil.login(
        emailController.text.trim(), passwordController.text.trim());

    // If the user doesn't exist, display an error message.
    if (user == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    "There is no user record corresponding to this combination of email and password, please double check the information entered!"));
          });
    }
  }

  Future<void> signUp() async {
    // Checks the username entered is valid, otherwise return.
    usernameInteracted = true;
    if (validateUsername(usernameController.text.trim()) != null) {
      FocusScope.of(context).requestFocus(usernameFocusNode);
      FocusScope.of(context).requestFocus(FocusNode());
      return;
    }

    // Checks the email address entered is valid, otherwise return.
    emailInteracted = true;
    if (validateEmail(emailController.text.trim()) != null) {
      FocusScope.of(context).requestFocus(emailFocusNode);
      FocusScope.of(context).requestFocus(FocusNode());
      return;
    }

    // Checks the password entered is valid, otherwise return.
    passwordInteracted = true;
    if (validatePassword(passwordController.text.trim()) != null) {
      FocusScope.of(context).requestFocus(passwordFocusNode);
      FocusScope.of(context).requestFocus(FocusNode());
      return;
    }

    // Checks the confirm password entered is valid, otherwise return.
    confirmPasswordInteracted = true;
    if (validateConfirmPassword(confirmPasswordController.text.trim()) !=
        null) {
      FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
      FocusScope.of(context).requestFocus(FocusNode());
      return;
    }

    // Checks the email entered doesn't already exists
    if (await DataUtil.emailAlreadyTaken(emailController.text.trim()) == true) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    "This email address is already taken!\nPlease select a different email address or reset your password."));
          });
      return;
    }

    User? user = await AuthUtil.signUp(
        emailController.text.trim(), passwordController.text.trim());
    DataUtil.addUser(
        user!.uid, usernameController.text.trim(), emailController.text.trim());
  }
}
