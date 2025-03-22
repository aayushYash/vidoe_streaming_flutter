import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔐 Sign in with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;
      if (user == null) throw Exception("Login failed!");

      // 🔄 Check local storage first
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUserData = prefs.getString('userData');

      if (storedUserData == null) {
        // 🛑 If not found locally, fetch from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          // ✅ Convert Firestore Timestamp to String before storing
          userData.forEach((key, value) {
            if (value is Timestamp) {
              userData[key] = value.toDate().toIso8601String();
            }
          });

          // 📝 Save locally
          await prefs.setString('userData', jsonEncode(userData));
        }
      }

      return user;
    } catch (e) {
      throw Exception("Login Failed: ${e.toString().split('] ').last}");
    }
  }

  /// 🚪 Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }

  /// 🔍 Get Current User
  User? get currentUser => _auth.currentUser;
}
