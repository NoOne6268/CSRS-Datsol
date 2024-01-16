import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:login_signup/services/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
var currentUser = '';
var currentEmail = '';


class NodeApis {

  final client = http.Client();
  // client.withCredentials = true; // Enable cookie handling

  Location location = Location();
  final String baseUrl = 'https://csrs-server-3928af365723.herokuapp.com';
  Future<String> getUserID() async{
    String userID ;
    try {
      // OneSignal.shared.getDeviceState().then((value) {
      //    userID = value!.userId!;
      //   print('device state is got in signup function is : $userID');
      //
      // });
      userID = await OneSignal.shared.getDeviceState().then((value) => value!.userId!);
      return userID;
    } catch (e) {
      print('error in getting user id  is $e');
      return 'error';
    }
  }

  Future<void> signUp(String username, String password, String email,String userID ,
      BuildContext context) async {

    try {
      if (!context.mounted) return;
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'username': username,
          'password': password,
          'email': email,
          'userID':  userID ,
        }),
      );
      print('this is response body : ${response.body}');
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registered succesfully')));
        Navigator.pushReplacementNamed(context, '/login');
      } else if (response.statusCode == 410) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email Provided already Exists')));
      } else if (response.statusCode == 411 && response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong')));
      }
    } catch (e) {
      print('error in signuop is $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> logIn(
      String email,
      String password,
      BuildContext context,
      ) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/login'),
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      print('response headers are : ${response.headers}');
      final String cookies =  response.headers['set-cookie'] ?? '';
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('cookie', cookies);

      print('login request body is  : ${jsonDecode(response.body)}');
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged in succesfully')));
        Navigator.pushReplacementNamed(context, '/home');
        currentEmail = email;
        currentUser = jsonDecode(response.body)['user']['username'];
        print(jsonDecode(response.body));
        print('after login currentuser and currentemail is $currentUser and $currentEmail');
      } else if (response.statusCode == 410) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid Password' , style: TextStyle(color: Colors.pinkAccent),)));
      } else if ( response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong')));
      }
      else if (response.statusCode == 411) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('login function\'s error is ${e.toString()}')));
      print('login function\'s error is ${e.toString()}');
    }
  }

  Future<void> logout(BuildContext context)async{
    // currentEmail = '';
    // currentUser = '';
    SharedPreferences pref =await  SharedPreferences.getInstance();
    pref.remove('cookie');
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<Map> getContacts(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getcontacts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'email' : email,
        },

      );
      print('this is response after getting the contacts ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map<String , dynamic>> saveContact(String email, String contact) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/addcontact'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'email': email,
          'contact': contact,
        }),
      );
      print('this is response after saving the contact ${response.body}');
      if(response.statusCode == 200){
        return {'message' : jsonDecode(response.body)['message'] , 'status' : true};
      }else{
      return {'message' : jsonDecode(response.body)['message'] , 'status' : false};
      }
    } catch (e) {
      print(e);
        return {'message' : 'error' , 'status' : false};
    }
  }

  Future<bool> checkLogin() async {
    try {
      final Map data = await getCurrentUser();
      print('data is $data');
      if (data.isEmpty) {
        return false;
      } else {
        print('returning true');
        return true;
      }
    }
    catch (e) {
      print(e);
      return false;
    }

  }
  Future<Map> getCurrentUser()async{
    try{
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? cookie =  pref.getString('cookie');
      if(cookie != null) {
        final response = await client.get(
          Uri.parse('$baseUrl/getcurrentuser'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': cookie,
          },

        );
        // print('this is response after getting the current user is :  ${response.body} , AND THE cookie is $cookie');
        var data = jsonDecode(response.body);
        var email = data['data']['email'];
        var username = data['data']['username'];
        print('email and username are $email and $username');
        return {'email' : email , 'username' : username};
      }
      else{
        print('cookie is empty');
        return {};
      }
      // print('this is response after getting the current user is :  ${response.body}');

    }catch(e){
      print(e);
      return {};
    }

  }



  Future<void> sendNotificationToContacts(bool isAlert) async {
    try {
      if(isAlert){
        print('sending alert notification');
      }else{
        print('sending safe notification');
      }
      Map currentData = await getCurrentUser();
      String currentEmail1 = currentData['email'];
      Map contacts = await getContacts(currentEmail1);
      var data  = contacts['data'];
      print('contacts found are $data');
      List<String> userIds = [];
      for (var i = 0; i < data.length; i++) {
        userIds.add(data[i]['userId'].toString());
      }
      print('user ids are $userIds');
      Location location = Location();
      Map locationData = await location.getLocation();

      await http.post(Uri.parse('$baseUrl/sendnotification'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<dynamic, dynamic>{
            'userIDs': userIds,
            'lang': locationData['langitude'].toString(),
            'long': locationData['longitude'].toString(),
            'content': !isAlert ? '${currentData['username']} is safe now' : '${currentData['username']}  needs help, click to see ${currentData['username']} \'s location',
          }));
    } catch (e) {
      print(e);
    }
  }
}
