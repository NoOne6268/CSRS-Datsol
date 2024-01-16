
// class Firebase_function {
//   _initiateSOSAlert(BuildContext context, int time) async {
//     if (time == 0) {
//       print('times is 0 now ');
//       // fetchContacts();
//       Navigator.of(context).pop(); // Dismiss alert dialog
//     }
//
//
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       // false = user must tap button, true = tap outside dialog
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text('SOS will be initiated in ...'
//               , style: TextStyle(fontSize: 30.0, color: Colors.black,)),
//           content:
//           Container(
//             margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
//             child: Text('$time',
//                 style: const TextStyle(fontSize: 50.0,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Roboto')),
//           ),
//           contentPadding: EdgeInsets.all(10.0),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('cancel',
//                 style: TextStyle(fontSize: 30, color: Colors.pinkAccent),),
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(); // Dismiss alert dialog
//                 Navigator.of(context).pop(); // Dismiss alert dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> fetchContacts(bool isAlert) async {
//     try {
//       CollectionReference contacts = FirebaseFirestore.instance.collection(
//           'emergency_contacts');
//       User? currentUser = FirebaseAuth.instance.currentUser;
//       QuerySnapshot emergencyContactsQuery = await contacts.where(
//           'username', isEqualTo: currentUser!.email).get();
//       if (emergencyContactsQuery.docs.isNotEmpty) {
//         // Update existing document with the new contact
//         Map<String, dynamic> data = emergencyContactsQuery.docs[0]
//             .data() as Map<String, dynamic>;
//         var contacts = data['contacts'];
//         print('contacts found $contacts');
//
//         List<dynamic> tokens = data['tokens'];
//         print('tokens found $tokens , and type of tokens is ${tokens
//             .runtimeType}');
//         // converting tokens in string to list of strings
//
//         for (dynamic token in tokens) {
//           token.toString();
//           print('type of token is ${token.runtimeType}');
//           if (isAlert) {
//             sendNotification(token, currentUser);
//           }
//           else {
//             sendNotificationSafe(token, currentUser);
//           }
//         }
//       } else {
//         print('you dont have any emergency contacts');
//       }
//     }
//     catch (e) {
//       if (kDebugMode) {
//         print('Error sending FCM message: $e');
//       }
//     }
//   }
//
//
//   Future<void> sendNotification(String token, User currentUser) async {
//     try {
//       Location location = Location();
//       Map locationData = await location.getLocation();
//       // User? currentUser = FirebaseAuth.instance.currentUser;
//       print('current user is $currentUser');
//       var data = {
//         "notification": {
//           "body": "Click on this notification to get ${currentUser!
//               .displayName}'s location",
//           "title": "${currentUser!.displayName} needs help",
//         },
//         "priority": "high",
//         "data": {
//           "type": "msj",
//           "id": "uniqueId",
//           "status": "done",
//           "langitude": locationData['langitude'].toString(),
//           "longitude": locationData['longitude'].toString(),
//         },
//         "to": token,
//       };
//       try {
//         await http.post(
//           Uri.parse('https://fcm.googleapis.com/fcm/send'),
//           body: jsonEncode(data),
//
//           headers: {
//             'Content-Type': 'application/json; charset=UTF-8',
//             'Authorization':
//             'key=AAAAuZ-mf_w:APA91bEAdeM38FUcuwwZl07Pkqn7x7DlrRQ1zItXryfTmIUIOKOgYQ-483JogeY5d0q7crAj4VY4dfRL7TU-p4Vyd7NRCA7QyzOOiQDLuMyT2_5AIdaQDmIIO_c3Zfu8xkYVVLytH4Bg'
//           },
//         );
//         if (kDebugMode) {
//           print(data);
//         }
//       } catch (e) {
//         if (kDebugMode) {
//           print('Error sending FCM message: $e');
//         }
//       }
//     }
//     catch (e) {
//       if (kDebugMode) {
//         print('Error sending FCM message: $e');
//       }
//     }
//   }
//
//   Future<void> sendNotificationSafe(String token, User currentUser) async {
//     try {
//       Location location = Location();
//       Map locationData = await location.getLocation();
//       // User? currentUser = FirebaseAuth.instance.currentUser;
//       print('current user is $currentUser');
//       var data = {
//         "notification": {
//           "body": "See ${currentUser!.displayName}'s last location",
//           "title": "${currentUser!.displayName} is safe now",
//         },
//         "priority": "high",
//         "data": {
//           "type": "msj",
//           "id": "uniqueId",
//           "status": "done",
//           "langitude": locationData['langitude'].toString(),
//           "longitude": locationData['longitude'].toString(),
//         },
//         "to": token,
//       };
//       try {
//         await http.post(
//           Uri.parse('https://fcm.googleapis.com/fcm/send'),
//           body: jsonEncode(data),
//
//           headers: {
//             'Content-Type': 'application/json; charset=UTF-8',
//             'Authorization':
//             'key=AAAAuZ-mf_w:APA91bEAdeM38FUcuwwZl07Pkqn7x7DlrRQ1zItXryfTmIUIOKOgYQ-483JogeY5d0q7crAj4VY4dfRL7TU-p4Vyd7NRCA7QyzOOiQDLuMyT2_5AIdaQDmIIO_c3Zfu8xkYVVLytH4Bg'
//           },
//         );
//         if (kDebugMode) {
//           print(data);
//         }
//       } catch (e) {
//         if (kDebugMode) {
//           print('Error sending FCM message: $e');
//         }
//       }
//     }
//     catch (e) {
//       if (kDebugMode) {
//         print('Error sending FCM message: $e');
//       }
//     }
//   }
// }