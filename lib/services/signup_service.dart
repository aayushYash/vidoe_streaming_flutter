import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Signup Function
  Future<String?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      // 🔍 Check if email already exists
      var userExists = await _auth.fetchSignInMethodsForEmail(email);
      if (userExists.isNotEmpty) return "Email is already in use!";

      // 🔥 Firebase Auth Signup
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) return "Signup failed!";

      // 📝 Store user data in Firestore
      final userData = {
        'uid': user.uid,
        'fullName': fullName,
        'email': email,
        'profilePic': '',
        'coins': 0,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _firestore.collection('users').doc(user.uid).set(userData);

      // 🚀 Save locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(userData));

      return null; // No error (Signup successful)
    } catch (e) {
      return e.toString().split('] ').last; // Return error message
    }
  }
}
