import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUtil {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }
}

class DataUtil {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUserData(String userId, String username, String email) async {
    try {
      await usersCollection.doc(userId).set({
        'username': username,
        'email': email,
        // Add other fields as needed
      });
      print('User data added successfully!');
    } catch (e) {
      print('Error adding user data: $e');
    }
  }
}