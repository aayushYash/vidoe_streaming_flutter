import 'package:flutter/material.dart';
import 'package:video_streaming_proj/widgets/custom_input.dart';
import 'package:video_streaming_proj/services/signup_service.dart';

class SignupWidget extends StatefulWidget {
  final VoidCallback onSignupSuccess;
  const SignupWidget({required this.onSignupSuccess, Key? key}) : super(key: key);

  @override
  _SignupWidgetState createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final SignupService _signupService = SignupService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signUp() async {
    setState(() => _errorMessage = null);

    String fullName = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // 🔹 Password Match Validation
    if (password != confirmPassword) {
      setState(() => _errorMessage = "Passwords do not match!");
      return;
    }

    // 🔥 Call SignupService to sign up
    setState(() => _isLoading = true);
    String? result = await _signupService.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );
    setState(() => _isLoading = false);

    if (result == null) {
      widget.onSignupSuccess(); // Navigate on success
    } else {
      setState(() => _errorMessage = result); // Show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomInputField(controller: nameController, hintText: "Full Name", icon: Icons.person_outline),
        const SizedBox(height: 15),
        CustomInputField(controller: emailController, hintText: "Email", icon: Icons.email_outlined),
        const SizedBox(height: 15),
        CustomInputField(controller: passwordController, hintText: "Password", icon: Icons.lock_outline, isPassword: true),
        const SizedBox(height: 15),
        CustomInputField(controller: confirmPasswordController, hintText: "Confirm Password", icon: Icons.lock_outline, isPassword: true),

        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
          ),
        const SizedBox(height: 25),

        // Signup Button
        ElevatedButton(
          onPressed: _isLoading ? null : _signUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Signup", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }
}
