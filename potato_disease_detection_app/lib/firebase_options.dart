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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCm5n-CZ-EUbiMGeRnfjhW2rn1mr7-xgaY',
    appId: '1:525169750657:web:818b26fe25039ea9379380',
    messagingSenderId: '525169750657',
    projectId: 'semester-project-a1285',
    authDomain: 'semester-project-a1285.firebaseapp.com',
    storageBucket: 'semester-project-a1285.appspot.com',
    measurementId: 'G-DRX7XPK8C0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWDpi9IZgQHB2yljcV25U28ksJK-RCu8k',
    appId: '1:525169750657:android:cbbc2247364615ce379380',
    messagingSenderId: '525169750657',
    projectId: 'semester-project-a1285',
    storageBucket: 'semester-project-a1285.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAM69f19tCDahvEEeVJr11er5v0QWY4SCw',
    appId: '1:525169750657:ios:0c5ff88f0134b0ce379380',
    messagingSenderId: '525169750657',
    projectId: 'semester-project-a1285',
    storageBucket: 'semester-project-a1285.appspot.com',
    iosBundleId: 'com.example.potatoDiseaseDetectionApp',
  );
}
