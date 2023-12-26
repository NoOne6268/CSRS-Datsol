import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csrs/services/floating_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:csrs/services/authorization.dart';
import 'package:flutter/foundation.dart';

import 'package:csrs/services/notification.dart';
import 'package:http/http.dart' as http;
import 'package:csrs/services/location.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AuthService authService = AuthService();
  NotificationServices notificationServices = NotificationServices();
  Location location = Location();
  FloatingWidget floatingWidget = FloatingWidget();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    location.requestLocationPermission();
    location.askPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setUpInteractMessage(context);
    notificationServices.isTokenRefreshed();
    notificationServices.getToken().then((value){
      if (kDebugMode) {
        print('token is $value');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home screen',
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                    ),
                    child: const Text('login'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      authService.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                    ),
                    child: const Text('Logout'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                    ),
                    child: const Text('signup'),
                  ),
                  TextButton(
                    onPressed: () {
                      sendNotification();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0.0),
                      backgroundColor: Colors.redAccent,


                    ),
                    child: Container(
                      height: 30,
                      width: 50,
                      alignment: Alignment.center,
                      child: const Text('SOS' ,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: (){
                      floatingWidget.showWidget();
                    },
                      child: const Text('Show Widget'),),
                  const SizedBox(height: 20.0,),
                  TextButton(
                    onPressed: () {
                     _showInputDialog(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent,
                    ),
                    child: const Text('add a emergency contact'),
                  ),
                  const SizedBox(height: 20,),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child:  Text('This button will get a notification from firebase and will redirect you to google maps.'
                      ,style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,


                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Future<void> sendNotification ()async{

  try {
    NotificationServices notificationServices = NotificationServices();
    Location location = Location();
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

_showInputDialog(BuildContext context) async {
  TextEditingController textFieldController = TextEditingController();
  AuthService authService = AuthService();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add a emergency contact'),
        content: TextField(
          controller: textFieldController,
          decoration: InputDecoration(hintText: 'Enter your contact number'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              authService.saveContact(textFieldController.text, context);

              // Dismiss the pop-up
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}
