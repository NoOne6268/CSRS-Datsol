
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app_settings/app_settings.dart';
import 'package:csrs/services/location.dart';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;

// import 'package:login_signup/pages/login.dart';
class NotificationServices {
  Location location = Location();
  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  Future<String> getToken() async {
    String? token = await messaging.getToken();
    return token!;
  }
  void initLocalNotifications(BuildContext context , RemoteMessage message) {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings ,
        onDidReceiveNotificationResponse: (payload) async {

            handleMessage(context , message);
            if (kDebugMode) {
              print('notification payload: ${payload.toString()}');

          }
        });
}
  void handleMessage(BuildContext context , RemoteMessage message){
  if(message.data['type'] == 'msj'){
  // Navigator.push(context , MaterialPageRoute(builder: (context) => const Home()));
  location.sendLocation();
  print('location fetched successfully');
}

}
  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((event) {
      if (kDebugMode) {
        print(event.notification!.body);
        print(event.notification!.title);
        print(event.data.toString());
        print(event.data['type']);
      }
      if(Platform.isAndroid){
        initLocalNotifications(context , event);
        showNotifications(event);
      }else if(Platform.isIOS){
        showNotifications(event);
      }

    });
  }

  Future<void> showNotifications (RemoteMessage message)async {

    AndroidNotificationDetails androidNotificationDetails =const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notification',
      channelDescription: 'This notification is used to notify the user',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
      largeIcon:  DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    const  darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero , (){
      _flutterLocalNotificationsPlugin.show(
        1,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    });

  }

  void isTokenRefreshed() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('token refreshed');
      }
    });
  }

  void setUpInteractMessage(BuildContext context)async{
    //when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context , initialMessage);
    }
    // when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context , event);
    });
  }
}

Future<void> sendNotification ()async{

  try {
    NotificationServices notificationServices = NotificationServices();
    CollectionReference contacts = FirebaseFirestore.instance.collection('emergency_contacts');
    User? currentUser = FirebaseAuth.instance.currentUser;
    QuerySnapshot emergencyContactsQuery = await contacts.where('username', isEqualTo: currentUser!.email).get();
    if (emergencyContactsQuery.docs.isNotEmpty) {
      // Update existing document with the new contact
      await FirebaseFirestore.instance
          .collection('emergency_contacts')
          .doc(emergencyContactsQuery.docs[0].id).get();
    } else {
      print('you dont have any emergency contacts');
    }
    await notificationServices.getToken().then((value) async{
      if (kDebugMode) {
        print('token is $value');
      }
      var data = {
        "notification": {
          "body": "this will redirect you to google maps",
          "title": "click on this to see your location on google maps"
        },
        "priority": "high",
        "data": {
          "type": "msj",
          "id": "1dsfsafd",
          "status": "done"
        },
        "to": value.toString(),
      };
      try {
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data),

          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
            'key=AAAAuZ-mf_w:APA91bEAdeM38FUcuwwZl07Pkqn7x7DlrRQ1zItXryfTmIUIOKOgYQ-483JogeY5d0q7crAj4VY4dfRL7TU-p4Vyd7NRCA7QyzOOiQDLuMyT2_5AIdaQDmIIO_c3Zfu8xkYVVLytH4Bg'
          },
        );
        if (kDebugMode) {
          print(data);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error sending FCM message: $e');
        }
      }

    });}
  catch (e) {
    if (kDebugMode) {
      print('Error sending FCM message: $e');
    }
  }
}
