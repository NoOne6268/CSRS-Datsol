import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/pages/signup.dart';
import 'package:login_signup/pages/login.dart';
import 'package:login_signup/pages/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:login_signup/pages/sos.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBHi2AzFaj6hYRytGV8Mf9faBzY4oQ2Njo',
      appId: '1:797247438844:android:3e60af2a46960574c03c79',
      messagingSenderId: '797247438844',
      projectId: 'login-example-15cb0',
      authDomain: 'login-example-15cb0.firebaseapp.com',

    ),
  );
  await dotenv.load(fileName: ".env");
  initPlatform();



  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MaterialApp(initialRoute: '/home', routes: {
    '/signup': (context) => const SignUp(),
    '/login': (context) => const LogIn(),
    '/home': (context) => const Home(),
    '/sos': (context) => const sosScreen(),

  }));
}


Future<void> initPlatform()async {
  // OneSignal.initialize('845c208f-f5ea-410a-abc5-92bfe17326fe');
  // OneSignal.Notifications.requestPermission(true);
  // OneSignal.Notifications.addClickListener((event) {
  //    print('clicked');
  //    print('event is ${event.notification.additionalData}');
  //    print('event is ${event.notification.body}');
  // });
  //   print('onesignal userId is : ${OneSignal.Debug.setLogLevel()} ' );
  // }
  OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  OneSignal.shared.setAppId('845c208f-f5ea-410a-abc5-92bfe17326fe');
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print('Accepted permission: $accepted');
  });
  OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
    print('notification will show in foreground');
  });

  OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    print('notification received and clicked  ${openedResult!.notification}');
    print('event is ${openedResult.notification.additionalData}');
       print('event is ${openedResult.notification.body}');

  });
  OneSignal.shared.getDeviceState().then(
          (value)=>{
        print('user id is : ${value!.userId} , and device state is ${value.jsonRepresentation()}')
      });
  // print('something is happening');
}