import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_streaming_proj/services/gateway_service.dart';

class EmailVerificationScreen extends StatefulWidget {
  final VoidCallback onVerified;

  const EmailVerificationScreen({required this.onVerified, Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final GatewayService _gatewayService = GatewayService();
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _gatewayService.sendEmailVerification(); // 📩 Send verification email on entry
  }

  /// 🔄 **Check Email Verification Status**
  Future<void> _checkVerificationStatus() async {
    setState(() => _isChecking = true);

    await FirebaseAuth.instance.currentUser?.reload(); // 🔄 Refresh user state
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      widget.onVerified(); // ✅ Move to Home after verification
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email not verified yet. Please check your inbox.")),
      );
    }

    setState(() => _isChecking = false);
  }

  /// 🚪 **Sign Out User**
  Future<void> _signOut() async {
    await _gatewayService.signOut();
    widget.onVerified();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: SingleChildScrollView(  // ✅ Fix overflow issue
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,  // ✅ Center content
            children: [
              const SizedBox(height: 50),  // ✅ Add spacing for small screens
              const Icon(Icons.email, size: 100, color: Colors.deepPurpleAccent),
              const SizedBox(height: 20),
              const Text(
                "A verification email has been sent to your email address.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please check your inbox and verify your email before continuing.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _isChecking
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.deepPurpleAccent),  
                      onPressed: _checkVerificationStatus,
                      child: const Text("I have verified my email"),
                    ),
              const SizedBox(height: 20),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.deepPurpleAccent),
                onPressed: _signOut,
                child: const Text("Logout & Sign in Again"),
              ),
              const SizedBox(height: 50),  // ✅ Extra padding to prevent overflow
            ],
          ),
        ),
      ),
    );
  }
}
