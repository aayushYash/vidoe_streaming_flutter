import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_streaming_proj/services/google_signin_service.dart';

class GoogleSignInButton extends StatefulWidget {
  final VoidCallback onSignInSuccess;

  GoogleSignInButton({required this.onSignInSuccess});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isLoading = false;
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    String? result = await _googleSignInService.signInWithGoogle();

    setState(() => _isLoading = false);

    if (result == null) {
      widget.onSignInSuccess(); // ✅ Navigate on success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Failed: $result')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _handleGoogleSignIn,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const FaIcon(FontAwesomeIcons.google, color: Colors.white, size: 20),
        label: Text(
          _isLoading ? "Signing in..." : "Continue with Google",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isLoading ? Colors.grey : Colors.white10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
