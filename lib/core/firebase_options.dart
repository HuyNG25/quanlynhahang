import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCSOateHOIG6UJcM61CDcVVecPNLYmTv7k',
    // LƯU Ý: Phải lấy mã appId của Web (thường có dạng 1:xxxx:web:xxxx)
    appId: '1:239022873408:android:81f5b59429b9429aff78a5', 
    messagingSenderId: '...',
    projectId: 'flutter-firebase-1771020357',
    authDomain: 'flutter-firebase-1771020357.firebaseapp.com',
    storageBucket: 'flutter-firebase-1771020357.appspot.com',
  );
}