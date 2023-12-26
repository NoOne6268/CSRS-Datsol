import 'dart:async';
import 'package:flutter/services.dart';

class FloatingWidget {
  static const platform = MethodChannel('datsol.flutter.dev/widget');
  
  Future<void> showWidget() async {
    try{
      final showButton = await platform.invokeMethod<bool>('showWidget');
    } catch (e) {
      print(e);
    }
  }
}
