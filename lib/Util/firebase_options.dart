// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBfxEVoj-iTaJIT1LNL_WlitwNRbpmKOvU',
    appId: '1:265622470895:web:d00a4330eefa3d26e11b1a',
    messagingSenderId: '265622470895',
    projectId: 'bjss-food-ai',
    authDomain: 'bjss-food-ai.firebaseapp.com',
    storageBucket: 'bjss-food-ai.appspot.com',
    measurementId: 'G-75G26TGSSQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGXrbQ1Z7sKGt_dYrocxkcbpkefyRQMhw',
    appId: '1:265622470895:android:8d0fbe0cf1b22509e11b1a',
    messagingSenderId: '265622470895',
    projectId: 'bjss-food-ai',
    storageBucket: 'bjss-food-ai.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDq1IdbdQ3R8akLqxgaUtB25OGsrG0M_EI',
    appId: '1:265622470895:ios:aaab9758991e731ce11b1a',
    messagingSenderId: '265622470895',
    projectId: 'bjss-food-ai',
    storageBucket: 'bjss-food-ai.appspot.com',
    iosBundleId: 'com.example.foodAiApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDq1IdbdQ3R8akLqxgaUtB25OGsrG0M_EI',
    appId: '1:265622470895:ios:c61445881dadd2eee11b1a',
    messagingSenderId: '265622470895',
    projectId: 'bjss-food-ai',
    storageBucket: 'bjss-food-ai.appspot.com',
    iosBundleId: 'com.example.foodAiApp.RunnerTests',
  );
}