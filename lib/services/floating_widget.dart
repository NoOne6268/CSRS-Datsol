import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FloatingWidget {
  static const platform = MethodChannel('datsol.flutter.dev/widget');

  Future<void> showWidget(BuildContext context) async {
    try{
      final response = await platform.invokeMethod<String>('showWidget');
      // if(response == 'SendNotification'){
      //
      //
      // }
    } catch (e) {
      print(e);
    }

    platform.setMethodCallHandler((call) async {
      if(call.method == 'SendNotification'){
        // Location().getLocation();
        // fetchContacts();
        Navigator.pushReplacementNamed(context, '/sos');
      }
    });
  }
}


