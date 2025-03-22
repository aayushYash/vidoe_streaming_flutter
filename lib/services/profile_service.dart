import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// **Fetch user data & email verification status**
  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserData = prefs.getString('userData');

    Map<String, dynamic> userData = {
      'fullName': 'User',
      'email': 'example@example.com',
      'emailVerified': false, // Default value
    };

    if (storedUserData != null) {
      userData = jsonDecode(storedUserData);
    }

    // Fetch real-time email verification status
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload(); // 🔄 Refresh user data
      userData['emailVerified'] = user.emailVerified;
    }

    return userData;
  }
}
