import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_ai_app/LoginPages/login_signup_page.dart';
import 'package:url_launcher/url_launcher.dart';

// Initialises the state for the index page.
class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

// Returns a scaffold widget to display the index page.
class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D3444),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              children: [
                // Container to display the text at the top of the screen.
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Food AI',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 60,
                            color: Colors.white),
                      ),
                      Text(
                        'Lets find the food you love',
                        style: TextStyle(
                          color: Color(0xFFC4CCD8),
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                // Container to display the buttons on the screen such as login, sing up.
                Container(
                  child: Column(
                    children: [
                      // Handles the login button.
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30, top: 30),
                        child: ElevatedButton(
                          key: ValueKey('loginButton'),
                          // Provide an onPressed redirecting to the login page.
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginSignupPage(screenType: false)),
                              //builder: (context) => LoginSignupScreen(screenType: false)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(125, 30.0)),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Handles the sign up button.
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30, top: 30),
                        child: ElevatedButton(
                          key: ValueKey('signUpButton'),
                          // Provide an onPressed redirecting to the sign up page.
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginSignupPage(screenType: true)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(125, 30.0)),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Handles the help button.
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30, top: 30),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(125, 30.0)),
                          child: Text(
                            'Help',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Container to display the social media section.
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      // Container to display some text "follow us".
                      Container(
                        child: Column(
                          children: [
                            Text(
                              "FOLLOW US",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC4CCD8),
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

                      // Container to display the social media buttons.
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Provide an onTap redirecting the user to google plus social media page.
                              GestureDetector(
                                onTap: () async {
                                  await launchUrl(
                                      Uri(scheme: 'https', host: 'google.com'),
                                      mode: LaunchMode.externalApplication);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey[200],
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/google.svg',
                                    semanticsLabel: 'Google plus',
                                    height: 32,
                                    width: 32,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),

                              // Provide an onTap redirecting the user to facebook social media page.
                              GestureDetector(
                                onTap: () async {
                                  await launchUrl(
                                      Uri(scheme: 'https', host: 'google.com'),
                                      mode: LaunchMode.externalApplication);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey[200],
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/facebook.svg',
                                    semanticsLabel: 'Facebook',
                                    height: 32,
                                    width: 32,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),

                              // Provide an onTap redirecting the user to twitter social media page.
                              GestureDetector(
                                onTap: () async {
                                  await launchUrl(
                                      Uri(scheme: 'https', host: 'google.com'),
                                      mode: LaunchMode.externalApplication);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey[200],
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/twitter.svg',
                                    semanticsLabel: 'Twitter',
                                    height: 32,
                                    width: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
