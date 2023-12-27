import 'dart:async';
import 'package:flutter/services.dart';
import 'package:csrs/services/notification.dart';
import 'package:csrs/services/location.dart';

class FloatingWidget {
  static const platform = MethodChannel('datsol.flutter.dev/widget');

  Future<void> showWidget() async {
    try{
      final response = await platform.invokeMethod<String>('showWidget');
      if(response == 'SendNotification'){
        Location().sendLocation();
        sendNotification();
      }
    } catch (e) {
      print(e);
    }

    platform.setMethodCallHandler((call) async {
      if(call.method == 'SendNotification'){
        Location().sendLocation();
      }
    });
  }
}


