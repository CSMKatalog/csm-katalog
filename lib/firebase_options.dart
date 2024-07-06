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
    apiKey: 'AIzaSyAERGUnICjcVl_veNDpSWL1TOfa7GpQ6dM',
    appId: '1:25104211908:web:d0a5e3c00814d9b6e4ce91',
    messagingSenderId: '25104211908',
    projectId: 'csm-katalog',
    authDomain: 'csm-katalog.firebaseapp.com',
    storageBucket: 'csm-katalog.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBNfoOqpPhyB5eo7L7ouF_JqCG-g6FfPs',
    appId: '1:25104211908:android:ace972a8c70fb5ffe4ce91',
    messagingSenderId: '25104211908',
    projectId: 'csm-katalog',
    storageBucket: 'csm-katalog.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsDOWMkTO_SJH2jeDBodCq_VtqUyR8cIQ',
    appId: '1:25104211908:ios:b5aa8e532f6d0888e4ce91',
    messagingSenderId: '25104211908',
    projectId: 'csm-katalog',
    storageBucket: 'csm-katalog.appspot.com',
    iosBundleId: 'com.csm.katalog.csmkatalog',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCsDOWMkTO_SJH2jeDBodCq_VtqUyR8cIQ',
    appId: '1:25104211908:ios:b5aa8e532f6d0888e4ce91',
    messagingSenderId: '25104211908',
    projectId: 'csm-katalog',
    storageBucket: 'csm-katalog.appspot.com',
    iosBundleId: 'com.csm.katalog.csmkatalog',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAERGUnICjcVl_veNDpSWL1TOfa7GpQ6dM',
    appId: '1:25104211908:web:4c8cbddc6ba01f8be4ce91',
    messagingSenderId: '25104211908',
    projectId: 'csm-katalog',
    authDomain: 'csm-katalog.firebaseapp.com',
    storageBucket: 'csm-katalog.appspot.com',
  );

}