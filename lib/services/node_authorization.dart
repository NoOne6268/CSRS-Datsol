import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:login_signup/services/location.dart';


class NodeApis {
var currentUser = '';
var currentEmail = '';
  Location location = Location();
  final String baseUrl = 'https://csrs-server-3928af365723.herokuapp.com';
  Future<String> getUserID() async{
    String? userID ;
    try {
      OneSignal.shared.getDeviceState().then((value) {
        if(value!.userId == null){
          userID = 'couldn\'t get userID';
        }else{
          userID = value.userId!;
          userID.toString().isEmpty ? userID = 'couldn\'t get userID' : userID = value.userId;
        }
        print('device state is got in signup function is :  ${value.userId}');
      });
      return userID.toString();
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
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
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
    currentEmail = '';
    currentUser = '';
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
    if (currentEmail == '' && currentUser == '') {
      print('user is not logged in');
      return false;
    } else {
      print('user is logged in');
      return true;
    }
  }
  Future<Map> getCurrentUser()async{
    if(currentEmail == '' && currentUser == ''){
      return {};}
    else{
      return {'email' : currentEmail , 'username' : currentUser};
    }

  }



  Future<void> sendNotificationToContacts() async {
    try {
      Map contacts = await getContacts(currentEmail);



    } catch (e) {
      print(e);
    }
  }
}
