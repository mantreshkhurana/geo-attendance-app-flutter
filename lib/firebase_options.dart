// File generated as a PLACEHOLDER to unblock local testing.
// These are NOT real Firebase credentials — auth/firestore/storage will fail
// at runtime. Replace by running `flutterfire configure`.
//
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyPlaceholderKeyDoNotUse000000000000000',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'placeholder-project',
    storageBucket: 'placeholder-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyPlaceholderKeyDoNotUse000000000000000',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'placeholder-project',
    storageBucket: 'placeholder-project.appspot.com',
    iosBundleId: 'com.mantresh.geoattendance',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyPlaceholderKeyDoNotUse000000000000000',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'placeholder-project',
    storageBucket: 'placeholder-project.appspot.com',
    iosBundleId: 'com.mantresh.geoattendance',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyPlaceholderKeyDoNotUse000000000000000',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'placeholder-project',
    authDomain: 'placeholder-project.firebaseapp.com',
    storageBucket: 'placeholder-project.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyPlaceholderKeyDoNotUse000000000000000',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'placeholder-project',
    authDomain: 'placeholder-project.firebaseapp.com',
    storageBucket: 'placeholder-project.appspot.com',
  );
}
