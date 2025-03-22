import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_streaming_proj/widgets/google_singin_button.dart';
import 'package:video_streaming_proj/widgets/login_widget.dart';
import 'package:video_streaming_proj/widgets/signup_widget.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onSignInSuccess; // ✅ Add this parameter

  const AuthScreen({super.key, required this.onSignInSuccess}); // ✅ Required parameter

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false, // ✅ Prevents unwanted resizing
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Video Icon at the Top (Hidden if Keyboard is Visible)
                      if (!isKeyboardVisible)
                        const FaIcon(
                          FontAwesomeIcons.clapperboard,
                          size: 60,
                          color: Colors.deepPurpleAccent,
                        ),
                      if (!isKeyboardVisible) const SizedBox(height: 15),

                      // App Name "StreamSync" (Hidden if Keyboard is Visible)
                      if (!isKeyboardVisible)
                        const Text(
                          "StreamSync",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      if (!isKeyboardVisible) const SizedBox(height: 20),

                      // Toggle between Login & Signup
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _toggleButton("Login", isLogin),
                            _toggleButton("Signup", !isLogin),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // ✅ Pass `onSignInSuccess` callback
                      isLogin 
                        ? LoginWidget(onLoginSuccess: widget.onSignInSuccess) 
                        : SignupWidget(onSignupSuccess: widget.onSignInSuccess),
                      const SizedBox(height: 20),

                      // OR Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[700],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[700],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Google Login Button with Callback
                      GoogleSignInButton(onSignInSuccess: widget.onSignInSuccess), // ✅ Pass callback
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Toggle Button Widget
  Widget _toggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLogin = text == "Login";
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
