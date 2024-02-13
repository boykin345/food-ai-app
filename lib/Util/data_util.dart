import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Deals with the knowledge of accessing & editing the firebase authentication database.
///
/// A list of methods to be used when dealing with the authentication of users such as login & sign out.
class AuthUtil {
  /// Will sign the user into the application via firebase instance.
  ///
  /// Takes in two input values [email] for the email address of the user & [password] for the password of the user.
  /// Will return an instance of the user if they exist, otherwise it will return user as null.
  static Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error: logging in: $e");
      return null;
    }
  }

  /// Will sign the user up to the application via firebase instance.
  ///
  /// Takes in two input values [email] for the email address of the user & [password] for the password of the user.
  /// Will return an instance of the newly created user if successful, otherwise it will return user as null.
  static Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error: signing up: $e");
      return null;
    }
  }
}

/// Deals with the knowledge of accessing & editing the firestore database.
///
/// A list of methods to be used when dealing with the firestore database such as user settings.
class DataUtil {
  /// Add a record of the user to the firestore database.
  ///
  /// Takes in three input values, [userID] a unique ID for identifying the user, [username] the username of the user,
  /// [email] the email address of the user.
  static Future<void> addUser(String userId, String username, String email) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'uid': userId,
        'username': username,
        'email': email,
      });
    } catch (e) {
      print('Error: adding user: $e\n');
    }
  }

  /// Checks if the email the user is signing up with is already taken or not.
  ///
  /// Takes in one input, [email] which is the email address the user is attempting to sign up with.
  /// Returns `false` if the email is available, otherwise if the email is taken it will return `true`.
  static Future<bool> emailAlreadyTaken(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error: emailAlreadyTaken: $e");
      return true; // If an error is caught, still returns true to act as the email is already taken.
    }
  }
}