import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/services/node_authorization.dart';
import '../services/floating_widget.dart';
import 'package:login_signup/services/firebase_authorization.dart';
import 'package:flutter/foundation.dart';
import 'package:login_signup/services/notification.dart';
import 'package:http/http.dart' as http;
import 'package:login_signup/services/location.dart';

Future<void> checkCurrentUser() async {
  NodeApis nodeApis = NodeApis();
  Map?  user=await nodeApis.getCurrentUser();
    print('currentuser is  : ${user.toString()}');

}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int time = 10;
  AuthService authService = AuthService();
  NodeApis nodeApis = NodeApis();
  NotificationServices notificationServices = NotificationServices();
  Location location = Location();
  FloatingWidget floatingWidget = FloatingWidget();
  var username = '';
  var email = '';
  // User user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCurrentUser();
    notificationServices.requestNotificationPermission();
    location.requestLocationPermission();
    location.askPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setUpInteractMessage(context);
    notificationServices.isTokenRefreshed();

    if(FirebaseAuth.instance.currentUser != null){

        // username = FirebaseAuth.instance.currentUser!.displayName!;
        // email = FirebaseAuth.instance.currentUser!.email!;
        NodeApis nodeApis = NodeApis();
        nodeApis.getCurrentUser().then((value){
          setState(() {
            username = value['username'].toString();
            email = value['email'].toString();
          });
        });

    }
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
          children: <Widget>[
            username != 'null' && username != '' ? Text(username) : const Text('please Login , you are not logged in' , style: TextStyle(fontSize: 20),),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: email == 'null' ? null :  Text('email : $email'),
            ) ,
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
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: (){
                      floatingWidget.showWidget(context);
                    },
                    child: const Text('Show Widget'),),

                  const SizedBox(height: 20.0,),

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
                      Navigator.pushReplacementNamed(context, '/sos');
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
                    onPressed: () {
                     _showInputDialog(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent,
                    ),
                    child: const Text('add a emergency contact'),
                  ),
                  const SizedBox(height: 20,),
                  TextButton(
                    onPressed: () {
                      _showContacts(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent,
                    ),
                    child: const Text('see your emergency contacts'),
                  ),
                  const SizedBox(height: 20,),
                  TextButton(
                    onPressed: ()async {
                      nodeApis.checkLogin();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent,
                    ),
                    child: const Text('testing button'),
                  ),
                  const SizedBox(height: 20,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_initiateSOSAlert (BuildContext context, int time ) async{

  if(time == 0){
    print('times is 0 now ');
      // fetchContacts();
      Navigator.of(context).pop(); // Dismiss alert dialog
    }


  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('SOS will be initiated in ...'
            , style: TextStyle(fontSize: 30.0, color: Colors.black , )),
        content:
        Container(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Text('$time',
              style: const TextStyle(fontSize: 50.0, color: Colors.black , fontWeight: FontWeight.bold , fontFamily: 'Roboto')),
        ),
        contentPadding: EdgeInsets.all(10.0),
        actions: <Widget>[
          TextButton(
            child: const Text('cancel', style: TextStyle(fontSize: 30 , color: Colors.pinkAccent),),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              Navigator.of(context).pop(); // Dismiss alert dialog
            },
          ),
        ],
      );
    },
  );
}

Future<void> fetchContacts(bool isAlert)async{
  try{
    CollectionReference contacts = FirebaseFirestore.instance.collection('emergency_contacts');
    User? currentUser = FirebaseAuth.instance.currentUser;
    QuerySnapshot emergencyContactsQuery = await contacts.where('username', isEqualTo: currentUser!.email).get();
    if (emergencyContactsQuery.docs.isNotEmpty) {
      // Update existing document with the new contact
     Map<String , dynamic> data = emergencyContactsQuery.docs[0].data() as Map<String, dynamic>;
     var contacts = data['contacts'];
     print('contacts found $contacts');

     List<dynamic> tokens = data['tokens'];
      print('tokens found $tokens , and type of tokens is ${tokens.runtimeType}');
      // converting tokens in string to list of strings

      for(dynamic token in tokens){
        token.toString();
        print('type of token is ${token.runtimeType}');
        if(isAlert){
          sendNotification(token , currentUser);
        }
        else{
          sendNotificationSafe(token , currentUser);
        }

      }
    } else {
      print('you dont have any emergency contacts');
    }
  }
  catch (e) {
    if (kDebugMode) {
      print('Error sending FCM message: $e');
    }
  }
}


Future<void> sendNotification (String token , User currentUser)async{

  try {

    Location location = Location();
    Map locationData = await location.getLocation();
    // User? currentUser = FirebaseAuth.instance.currentUser;
    print('current user is $currentUser');
      var data = {
        "notification": {
          "body": "Click on this notification to get ${currentUser!.displayName}'s location",
          "title": "${currentUser!.displayName} needs help",
        },
        "priority": "high",
        "data": {
          "type": "msj",
          "id": "uniqueId",
          "status": "done",
          "langitude": locationData['langitude'].toString(),
          "longitude": locationData['longitude'].toString(),
        },
        "to": token,
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

    }
  catch (e) {
    if (kDebugMode) {
      print('Error sending FCM message: $e');
    }
  }
}
Future<void> sendNotificationSafe (String token , User currentUser)async{

  try {

    Location location = Location();
    Map locationData = await location.getLocation();
    // User? currentUser = FirebaseAuth.instance.currentUser;
    print('current user is $currentUser');
    var data = {
      "notification": {
        "body": "See ${currentUser!.displayName}'s last location",
        "title": "${currentUser!.displayName} is safe now",
      },
      "priority": "high",
      "data": {
        "type": "msj",
        "id": "uniqueId",
        "status": "done",
        "langitude": locationData['langitude'].toString(),
        "longitude": locationData['longitude'].toString(),
      },
      "to": token,
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

  }
  catch (e) {
    if (kDebugMode) {
      print('Error sending FCM message: $e');
    }
  }
}
_showInputDialog(BuildContext context) async {
  final textFieldController = TextEditingController();
  final nodeApis = NodeApis();
  final checkLogin = await nodeApis.checkLogin();

  Future<void> _showDialog(String title, Widget content, List<Widget> actions) async {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: actions,
        );
      },
    );
  }

  if (checkLogin) {
    print('user is logged in');
    final currentEmail = await nodeApis.getCurrentUser();
    final email = currentEmail['email'];
    print('current user is $currentEmail');

    return _showDialog(
      'Add an emergency contact',
      TextField(
        controller: textFieldController,
        decoration: const InputDecoration(
          hintText: 'Enter your contact number',
        ),
      ),
      [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final response = await nodeApis.saveContact(email , textFieldController.text);
            bool isSaved = response['status'];
            String message = response['message'];
            print(isSaved);
            Navigator.of(context).pop();
            isSaved ? _savedalertDialog(context) : _notSavedalertDialog(context , message);
          },
          child: const Text('Save'),
        ),
      ],
    );
  } else {
    print('user is not logged in');

    return _showDialog(
      'Add an emergency contact',
      const Text('You are not logged in'),
      [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}



Future<void> _showContacts(BuildContext context)async {
  NodeApis nodeApis = NodeApis();
  bool isLoggedin = await nodeApis.checkLogin();
  Map currentUser;
  if(isLoggedin){
    currentUser = await nodeApis.getCurrentUser();

  var email = currentUser['email'].toString();
  var data;
  print('current user is ${currentUser.toString()}');
   await nodeApis.getContacts(email).then((value) {
      print('value is $value');
      data = value;
    });
  if(data.isNotEmpty){
    var contacts = data['data'];
    print('contacts found $contacts');
    print('contact is ${contacts[0]['contact'].toString()}');
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Contacts"),
          content: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(contacts[index]['contact'].toString()),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  else {
    print('you dont have any emergency contacts');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your emergency contacts'),
          content: const Text('you dont have any emergency contacts'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  }
  else{
    print('you are not logged in');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your emergency contacts'),
          content: const Text('you are not logged in'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }
}

void _savedalertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Your emergency contacts'),
        content: const Text('Your emergency contact is saved'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

void _notSavedalertDialog(BuildContext context , String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error '),
        content:  Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}



