import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/services/notification.dart';


class AuthService {
  NotificationServices notificationServices = NotificationServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signUpWithEmailAndPassword(String email, String password,
      String username, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(username);
      User user = userCredential.user!;
      await saveUserInfo(user.uid, email, username);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered succesfully')));
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email Provided already Exists')));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email Provided Is Invalid')));
      }
      if (kDebugMode) {
        print('signup firebase auth exception is ${e.code}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> saveUserInfo(
      String userId, String email, String username) async {

    try {
      final token = await notificationServices.getToken();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'email': email, 'name': username , 'token' : token});
    } catch (e) {
      print("Error saving user info: $e");
    }
  }


  Future<bool> saveContact(String contact, BuildContext context) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Check if the current user is not null
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('Current user is null');
        return false;
      }

      // Query for the user with the specified email
      QuerySnapshot contacts = await users.where('email', isEqualTo: contact).get();
      var token;
      if (contacts.docs.isNotEmpty) {
        var data = contacts.docs[0].data() as Map<String, dynamic>?; // Explicit cast
        if (data != null) {
          token = data['token'];
        } else {
          token = null;
        }
      } else {
        token = null;
      }


      if (contacts.docs.isNotEmpty) {
        print('user found: ${contacts.docs[0].data()}');

        CollectionReference emergencyContacts = FirebaseFirestore.instance.collection('emergency_contacts');

        // Query for the current user's emergency contacts
        QuerySnapshot emergencyContactsQuery =
        await emergencyContacts.where('username', isEqualTo: currentUser.email).get();

        if (emergencyContactsQuery.docs.isNotEmpty) {
          // Update existing document with the new contact
          await FirebaseFirestore.instance
              .collection('emergency_contacts')
              .doc(emergencyContactsQuery.docs[0].id)
              .set({'contacts': FieldValue.arrayUnion([contact]), 'tokens' : FieldValue.arrayUnion([token])}, SetOptions(merge: true));
        } else {
          // Create a new document for the current user with the new contact
          await FirebaseFirestore.instance
              .collection('emergency_contacts')
              .add({'username': currentUser.email, 'contacts': [contact] , 'tokens' : [token] });
        }

        print('contact saved succesfullly');
        return true;
      } else {
        print('No users found with the specified email');
        return false;
      }
    } catch (e) {
      print("Error saving user info: $e");
      return false;
    }
  }




  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('logged in successfully')));
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user Found with this Email')));
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password did not match')));
      }
      else if (e.code == 'network-request-failed') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please check your internet connection')));
      }

      print('Login firebase auth exception is ${e.code}');
    } catch (e) {
      print('Error is : $e');
    }
  }

// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

// Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
