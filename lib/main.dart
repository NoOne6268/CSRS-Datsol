import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:csrs/pages/signup.dart';
import 'package:csrs/pages/login.dart';
import 'package:csrs/pages/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: const FirebaseOptions(
    //   // apiKey: 'AIzaSyBHi2AzFaj6hYRytGV8Mf9faBzY4oQ2Njo',
    //   // appId: '1:797247438844:android:3e60af2a46960574c03c79',
    //   // messagingSenderId: '797247438844',
    //   // projectId: 'login-example-15cb0',
    //   // authDomain: 'login-example-15cb0.firebaseapp.com',
    //   // databaseURL:
    //   //       'https://console.firebase.google.com/u/0/project/login-example-15cb0/database/login-example-15cb0-default-rtdb/data/~2F',
    // ),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MaterialApp(initialRoute: '/login', routes: {
    '/signup': (context) => const SignUp(),
    '/login': (context) => const LogIn(),
    '/home': (context) => const Home(),

  }));
}
