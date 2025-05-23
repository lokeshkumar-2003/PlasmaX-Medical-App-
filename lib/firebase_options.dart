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
    apiKey: 'AIzaSyAxpm2u8alFyuzp6haQ4OBm9ZCkWwPuxb8',
    appId: '1:1083555156301:web:c14aea7101e1fb9970e704',
    messagingSenderId: '1083555156301',
    projectId: 'plasmax-20b7b',
    authDomain: 'plasmax-20b7b.firebaseapp.com',
    storageBucket: 'plasmax-20b7b.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-4MiPdlIDOBM49bDjsSGsIK35qXKXSzI',
    appId: '1:1083555156301:android:a2d1c419125923bf70e704',
    messagingSenderId: '1083555156301',
    projectId: 'plasmax-20b7b',
    storageBucket: 'plasmax-20b7b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAi7ZM95T0hJ3KgQikVbYhESKOE3dG0-30',
    appId: '1:1083555156301:ios:79e80f81aaf4c0cb70e704',
    messagingSenderId: '1083555156301',
    projectId: 'plasmax-20b7b',
    storageBucket: 'plasmax-20b7b.firebasestorage.app',
    iosBundleId: 'com.example.quizapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAi7ZM95T0hJ3KgQikVbYhESKOE3dG0-30',
    appId: '1:1083555156301:ios:79e80f81aaf4c0cb70e704',
    messagingSenderId: '1083555156301',
    projectId: 'plasmax-20b7b',
    storageBucket: 'plasmax-20b7b.firebasestorage.app',
    iosBundleId: 'com.example.quizapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAxpm2u8alFyuzp6haQ4OBm9ZCkWwPuxb8',
    appId: '1:1083555156301:web:d0d2818c068d444570e704',
    messagingSenderId: '1083555156301',
    projectId: 'plasmax-20b7b',
    authDomain: 'plasmax-20b7b.firebaseapp.com',
    storageBucket: 'plasmax-20b7b.firebasestorage.app',
  );

}