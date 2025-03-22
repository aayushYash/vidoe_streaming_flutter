import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_streaming_proj/screens/auth_screens.dart';
import 'package:video_streaming_proj/screens/home_screen.dart';
import 'package:video_streaming_proj/screens/email_verification_screen.dart'; // 🚀 NEW SCREEN
import 'package:video_streaming_proj/services/gateway_service.dart';

class AuthGateway extends StatefulWidget {
  @override
  _AuthGatewayState createState() => _AuthGatewayState();
}

class _AuthGatewayState extends State<AuthGateway> {
  final GatewayService _gatewayService = GatewayService();
  bool _isChecking = true;
  Widget? _targetScreen;

  @override
  void initState() {
    super.initState();
    _gatewayService.listenAuthState(_handleAuthChange);
  }

  /// 🔄 **Handle authentication state changes**
  void _handleAuthChange(User? user) async {
    if (user != null) {
      if (!user.emailVerified) {
        _navigateToVerification(); // 🚀 Redirect to Email Verification
        return;
      }

      bool hasUserData = await _gatewayService.loadUserData(user.uid);
      hasUserData ? _navigateToHome() : _navigateToLogin();
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    setState(() {
      _targetScreen = HomeScreen();
      _isChecking = false;
    });
  }

  void _navigateToLogin() {
    setState(() {
      _targetScreen = AuthScreen(onSignInSuccess: () => _gatewayService.listenAuthState(_handleAuthChange));
      _isChecking = false;
    });
  }

  void _navigateToVerification() {
    setState(() {
      _targetScreen = EmailVerificationScreen(onVerified: () => _gatewayService.listenAuthState(_handleAuthChange));
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return _targetScreen!;
  }
}
