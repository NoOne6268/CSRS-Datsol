import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:login_signup/services/location.dart';
class NodeNotificationApi{
  final String baseUrl = 'https://csrs-server-3928af365723.herokuapp.com';
  Location location = Location();
  Future<void> sendAlertNotification(String userID) async {
      try {
        Map data = await location.getLocation();
        final response = await http.post(
          Uri.parse('$baseUrl/sendnotification'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<dynamic, dynamic>{
            'userID': userID,
            'lang': data['langitude'],
            'long': data['longitude'],
            'content' : 'Emergency Alert',
          }),
        );
        print(response.body);
      } catch (e) {
        print(e);
      }
    }
}