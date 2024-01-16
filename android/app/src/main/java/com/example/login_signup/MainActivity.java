package com.example.login_signup;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Settings;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
public class MainActivity extends FlutterActivity{
    private static final String CHANNEL = "datsol.flutter.dev/widget";

    public void getPermission() {
        if (!Settings.canDrawOverlays(this)) {
            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:" + getPackageName()));
            startActivityForResult(intent, 1);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data){
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == 1){
            if (!Settings.canDrawOverlays(MainActivity.this)) {
                Toast.makeText(this, "Permission denied by User.", Toast.LENGTH_SHORT).show();
            } else {
                Intent intent = new Intent(MainActivity.this, WidgetService.class);
                startService(intent);
            }
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
        super.configureFlutterEngine(flutterEngine);
        NativeMethodChannel.configureChannel(flutterEngine);
        NativeMethodChannel.getMethodChannel().setMethodCallHandler(((call, result) -> {
            if(call.method.equals("showWidget")){
                if(!Settings.canDrawOverlays(MainActivity.this)){
                    getPermission();
                } else {
                    Intent intent = new Intent(MainActivity.this, WidgetService.class);
                    startService(intent);

                }
                result.notImplemented();
            }
        }));
    }

 }
