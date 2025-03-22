import 'package:flutter/material.dart';
import 'package:video_streaming_proj/services/firebase_auth_service.dart';
import 'package:video_streaming_proj/widgets/custom_input.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginWidget({required this.onLoginSuccess, Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signInWithEmail() async {
    try {
      setState(() => _isLoading = true);
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      await _authService.signInWithEmail(email, password);
      widget.onLoginSuccess(); // ✅ Notify AuthGateway
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomInputField(controller: emailController, hintText: "Email", icon: Icons.email_outlined, isPassword: false),
        const SizedBox(height: 15),
        CustomInputField(controller: passwordController, hintText: "Password", icon: Icons.lock_outline, isPassword: true),
        const SizedBox(height: 25),

        // Login Button
        ElevatedButton(
          onPressed: _isLoading ? null : _signInWithEmail,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }
}
