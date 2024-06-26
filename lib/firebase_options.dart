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
    apiKey: 'AIzaSyAM29-GT2EiGIgyIhCnUxHF0EtXl8TN07s',
    appId: '1:726915208838:web:0857cd40e0835e485a6307',
    messagingSenderId: '726915208838',
    projectId: 'sendy-app-chat',
    authDomain: 'sendy-app-chat.firebaseapp.com',
    storageBucket: 'sendy-app-chat.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzTSWKfFimykr6c4k1GNH5mZVJ2SvllKQ',
    appId: '1:726915208838:android:d5570eebf390568e5a6307',
    messagingSenderId: '726915208838',
    projectId: 'sendy-app-chat',
    storageBucket: 'sendy-app-chat.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyhK6b5HeHtGtZCAQ5m0N5RnOtn0QuJAs',
    appId: '1:726915208838:ios:34f92c615c82018e5a6307',
    messagingSenderId: '726915208838',
    projectId: 'sendy-app-chat',
    storageBucket: 'sendy-app-chat.appspot.com',
    iosBundleId: 'com.example.sendyAppChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAyhK6b5HeHtGtZCAQ5m0N5RnOtn0QuJAs',
    appId: '1:726915208838:ios:98537ce69d426f245a6307',
    messagingSenderId: '726915208838',
    projectId: 'sendy-app-chat',
    storageBucket: 'sendy-app-chat.appspot.com',
    iosBundleId: 'com.example.sendyAppChat.RunnerTests',
  );
}
