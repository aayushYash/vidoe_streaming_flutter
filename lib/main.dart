import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video_streaming_proj/firebase_options.dart';  // ✅ Corrected import
import 'package:video_streaming_proj/widgets/auth_gateway.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "StreamSync",
      theme: ThemeData.dark(), // Set default theme
      home: AuthGateway(),     // Go to Authentication Screen
    );
  }
}
