import 'package:flutter/material.dart';

import '../Util/Palette.dart';

class LoginSignupScreen extends StatefulWidget {
  final bool screenType;

  LoginSignupScreen({required this.screenType});

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Interact with field boxes
  bool usernameInteracted = false;
  bool emailInteracted = false;
  bool passwordInteracted = false;
  bool confirmPasswordInteracted = false;

  late FocusNode usernameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;

  // Visible
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  bool isSignupScreen = false;

  @override
  void initState() {
    super.initState();
    isSignupScreen = widget.screenType;

    usernameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();

    usernameFocusNode.addListener(() {
      setState(() {
        usernameInteracted = !usernameFocusNode.hasFocus;
      });
    });

    emailFocusNode.addListener(() {
      setState(() {
        emailInteracted = !emailFocusNode.hasFocus;
      });
    });

    passwordFocusNode.addListener(() {
      setState(() {
        passwordInteracted = !passwordFocusNode.hasFocus;
      });
    });

    confirmPasswordFocusNode.addListener(() {
      setState(() {
        confirmPasswordInteracted = !confirmPasswordFocusNode.hasFocus;
      });
    });
  }

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
          // Top part of the screen
          Positioned(
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              padding: EdgeInsets.only(top: 90, left: 20),
              color: Palette.backgroundMain,
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
          // Login container box
          AnimatedPositioned(
            duration: Duration(milliseconds: 600),
            curve: Curves.bounceInOut,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "LOGIN",
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
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SIGN UP",
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
                    if (isSignupScreen) signUpSection(),
                    if (!isSignupScreen) signInSection(),
                    Container(
                      margin: EdgeInsets.only(
                          top: 30, bottom: 15, left: 40, right: 40),
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {},
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
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          Text(
                            "OR",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            height: 2,
                            width: 25,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          socialButtons(),
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

  // Creates the sign in container
  Container signInSection() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: emailController,
                focusNode: emailFocusNode,
                maxLength: 128,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                obscureText: !passwordVisible,
                controller: passwordController,
                focusNode: passwordFocusNode,
                maxLength: 32,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Palette.icon,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("Forgot Password?",
                      style: TextStyle(fontSize: 12, color: Palette.greyText)),
                ),
              ],
            )
          ],
        ));
  }

  // Creates the signUp container
  Container signUpSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              controller: usernameController,
              focusNode: usernameFocusNode,
              maxLength: 32,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_circle_outlined,
                  color: Palette.icon,
                ),
                contentPadding: EdgeInsets.all(10),
                hintText: "Username",
                hintStyle: TextStyle(fontSize: 14, color: Palette.greyText),
                errorText: validateUsername(usernameController.text)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              controller: emailController,
              focusNode: emailFocusNode,
              maxLength: 128,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              obscureText: !passwordVisible,
              controller: passwordController,
              focusNode: passwordFocusNode,
              maxLength: 32,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Palette.icon,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              obscureText: !confirmPasswordVisible,
              controller: confirmPasswordController,
              focusNode: confirmPasswordFocusNode,
              maxLength: 32,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Palette.icon,
                ),
                suffixIcon: IconButton(
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
                errorText: validateConfirmPassword(confirmPasswordController.text),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Creates the social buttons at the bottom of the page
  Container socialButtons() {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 40, right: 40),
      child: Column(
        children: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(width: 2, color: Color(0xFF4267B2)),
              minimumSize: Size(150, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Color(0xFF4267B2).withOpacity(0.9),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.facebook),
                SizedBox(width: 5),
                Text("Facebook"),
              ],
            ),
          ),
          SizedBox(height: 5),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(width: 2, color: Color(0xFFEA5252)),
              minimumSize: Size(150, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Color(0xFFEA5252).withOpacity(0.9),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail),
                SizedBox(width: 5),
                Text("Google"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? validateUsername(String? username) {
    // Checks to see if the text field has been interacted with, if not exit early
    if (usernameInteracted == false) {
      return null;
    }

    // Checks if the username field is empty
    if (username == null || username.isEmpty) {
      return "Username field is empty!";
    }

    // Checks if the username length meets the minimal amount of characters
    if (username.length < 3) {
      return "Minimum length is 3 characters!";
    }

    return null; // validation successful
  }

  String? validateEmail(String? email) {
    // Checks to see if the text field has been interacted with, if not exit early
    if (emailInteracted == false) {
      return null;
    }

    // Checks if the email field is empty
    if (email == null || email.isEmpty) {
      return "Email address field is empty!";
    }

    // Checks if the email address is in the correct format
    if (!email.contains('@')) {
      return "Not a valid email address!";
    }

    return null; // validation successful
  }

  String? validatePassword(String? password) {
    // Checks to see if the text field has been interacted with, if not exit early
    if (passwordInteracted == false) {
      return null;
    }

    // Checks if the password field is empty
    if (password == null || password.isEmpty) {
      return "Password field is empty!";
    }

    // Checks if the password length meets the minimal amount of characters
    if (password.length < 8) {
      return "Minimum length is 8 characters!";
    }

    return null; // Return null if the validation is successful
  }

  String? validateConfirmPassword(String? confirmPassword) {
    // Checks to see if the text field has been interacted with, if not exit early
    if (confirmPasswordInteracted == false) {
      return null;
    }

    // Checks if the password field is empty
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Confirm password field is empty!";
    }

    // Checks if the password length meets the minimal amount of characters
    if (confirmPassword.length < 8) {
      return "Minimum length is 8 characters!";
    }

    return null; // Return null if the validation is successful
  }
}