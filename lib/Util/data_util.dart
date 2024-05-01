import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_ai_app/Entities/recipe.dart';

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

  /// Will send a reset password link to the user
  ///
  /// Takes in one input [email] which is the emil address of the user.
  /// Will return `true` if the reset password link was sent to the user, otherwise will return `false` if the link couldn't be sent.
  static Future<bool> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e);
      return false;
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
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
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

  /// Checks if the username the user is signing up with is already taken or not.
  ///
  /// Takes in one input, [username] which is the username the user is attempting to sign up with.
  /// Returns `false` if the username is available, otherwise if the username is taken it will return `true`.
  static Future<bool> usernameAlreadyTaken(String username) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error: usernameAlreadyTaken: $e");
      return true; // If an error is caught, still returns true to act as the username is already taken.
    }
  }

  /// Saves a recipe that belongs to the user in the firebase store
  ///
  /// Takes in two inputs [userId] which is the username of the user and [recipe] which is an entity of the recipe class.
  static Future<void> saveRecipe(String userId, Recipe recipe) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('recipes').add({
        'recipeName': recipe.recipeName,
        'calories': recipe.calories,
        'prepTime': recipe.prepTime,
        'difficulty': recipe.difficulty,
        'ingredients': recipe.ingredients,
        'instructions': recipe.instructions,
        'category': recipe.category,
        'imageURL': recipe.imageURL
      });
    } catch (e) {
      print("Error: saveRecipe: $e");
    }
  }

  /// Gets all the recipes that belong to a user from the firebase store.
  ///
  /// Takes in one input [userId] which is the username of the user.
  /// Returns a list of recipes in a map format
  static Future<List<Map<String, dynamic>>> getUserRecipes(String userId) async {
    List<Map<String, dynamic>> recipes = [];

    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('recipes')
          .get();

      userSnapshot.docs.forEach((doc) {
        Map<String, dynamic> recipeData = {
          'recipeName': doc['recipeName'],
          'calories': doc['calories'],
          'prepTime': doc['prepTime'],
          'difficulty': doc['difficulty'],
          'ingredients': (doc['ingredients'] as List<dynamic>).cast<String>(),
          'instructions': doc['instructions'],
          'category': doc['category'],
          'imageURL': doc['imageURL'],
        };
        recipes.add(recipeData);
      });
    } catch (e) {
      print('Error: getUserRecipes: $e');
    }

    return recipes;
  }
}