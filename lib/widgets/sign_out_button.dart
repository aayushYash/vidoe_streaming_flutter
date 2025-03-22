import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignOutButton extends StatefulWidget {
  @override
  _SignOutButtonState createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
  bool _isLoading = false;

  Future<void> _signOut() async {
    setState(() => _isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userData'); // 📝 Clear stored user data

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'isOnline': false, // ✅ Mark user offline (optional)
        });
      }

      await FirebaseAuth.instance.signOut(); // 🔥 Sign out from Firebase
    } catch (e) {
      debugPrint("Error signing out: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signOut,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: _isLoading
          ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text("Sign Out", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
