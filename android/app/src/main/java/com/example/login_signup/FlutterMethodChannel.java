package com.example.login_signup;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

class NativeMethodChannel {
    private static MethodChannel methodChannel;

    static MethodChannel getMethodChannel() {
        return methodChannel;
    }
        static void configureChannel(FlutterEngine flutterEngine) {
            String CHANNEL_NAME = "datsol.flutter.dev/widget";
            methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME);
        }

        // add the following method, it passes a string to flutter
        static void sendNotification() {
            methodChannel.invokeMethod("SendNotification", true);
        }
}