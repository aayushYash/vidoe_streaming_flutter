import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signInWithGoogle() async {
    try {
      // 🔄 Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return "User canceled sign-in";

      // 🔑 Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 🔥 Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) return "User sign-in failed!";

      // 🔄 Firestore reference
      final userRef = _firestore.collection('users').doc(user.uid);
      final userSnapshot = await userRef.get();

      Map<String, dynamic> userData;

      if (!userSnapshot.exists) {
        // 🆕 New User → Save structured data in Firestore
        userData = {
          'uid': user.uid,
          'fullName': user.displayName ?? '',
          'email': user.email ?? '',
          'profilePic': user.photoURL ?? 'https://example.com/default-profile.png',
          'bio': '',
          'coins': 0,
          'friends': [],
          'createdAt': FieldValue.serverTimestamp(), // 🕒 Firestore timestamp
        };

        await userRef.set(userData);
      } else {
        // 🔄 Existing user
        userData = userSnapshot.data() as Map<String, dynamic>;
      }

      // 🚀 Convert Timestamp to String before saving locally
      if (userData.containsKey('createdAt') && userData['createdAt'] is Timestamp) {
        userData['createdAt'] = (userData['createdAt'] as Timestamp).toDate().toIso8601String();
      }

      // 🚀 Save user data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(userData));

      return null; // ✅ Success
    } catch (e) {
      return e.toString(); // Return error message
    }
  }
}
