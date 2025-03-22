// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBblMEs0RRdB36p926CerNEERT-MFBiedw',
    appId: '1:682103622261:web:f146f8948f2182bc72863c',
    messagingSenderId: '682103622261',
    projectId: 'video-streaming-4fac1',
    authDomain: 'video-streaming-4fac1.firebaseapp.com',
    storageBucket: 'video-streaming-4fac1.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFQKBn3-3WXPlWc43g_NCtKiFDe1llMZI',
    appId: '1:682103622261:android:8591023c28fec2de72863c',
    messagingSenderId: '682103622261',
    projectId: 'video-streaming-4fac1',
    storageBucket: 'video-streaming-4fac1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCnIG2A92mNnCxE1TzE2Fwxg7zIDoQ6KMo',
    appId: '1:682103622261:ios:c45591318a600e6572863c',
    messagingSenderId: '682103622261',
    projectId: 'video-streaming-4fac1',
    storageBucket: 'video-streaming-4fac1.firebasestorage.app',
    iosBundleId: 'com.example.videoStreamingProj',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCnIG2A92mNnCxE1TzE2Fwxg7zIDoQ6KMo',
    appId: '1:682103622261:ios:c45591318a600e6572863c',
    messagingSenderId: '682103622261',
    projectId: 'video-streaming-4fac1',
    storageBucket: 'video-streaming-4fac1.firebasestorage.app',
    iosBundleId: 'com.example.videoStreamingProj',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBblMEs0RRdB36p926CerNEERT-MFBiedw',
    appId: '1:682103622261:web:652d0639c8697c6472863c',
    messagingSenderId: '682103622261',
    projectId: 'video-streaming-4fac1',
    authDomain: 'video-streaming-4fac1.firebaseapp.com',
    storageBucket: 'video-streaming-4fac1.firebasestorage.app',
  );
}
