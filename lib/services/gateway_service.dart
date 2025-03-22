import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GatewayService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔄 **Listen for authentication state changes**
  void listenAuthState(Function(User?) callback) {
    _auth.authStateChanges().listen(callback);
  }

  /// ✅ **Fetch user data & Check Email Verification**
  Future<bool> loadUserData(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserData = prefs.getString('userData');

    if (storedUserData != null) {
      return true; // ✅ User data is available locally
    }

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // 🔄 Convert Firestore Timestamp to ISO String
      if (userData.containsKey('createdAt') && userData['createdAt'] is Timestamp) {
        userData['createdAt'] = (userData['createdAt'] as Timestamp).toDate().toIso8601String();
      }

      await prefs.setString('userData', jsonEncode(userData));
      return true; // ✅ User data loaded successfully
    }

    return false; // ❌ User data not found
  }

  /// 📩 **Send Email Verification**
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// 🔄 **Sign Out User**
  Future<void> signOut() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }
}
