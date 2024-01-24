package com.example.login_signup;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.IBinder;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;

import android.os.Handler;
import android.os.Looper;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint;


public class WidgetService extends Service {
    private WindowManager mWindowManager;
    int LAYOUT_FLAG;
    private View mSOSView;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    Handler mainHandler = new Handler(Looper.getMainLooper());
    Runnable myRunnable = () -> {
        FlutterEngine engine = new FlutterEngine(getApplicationContext());
        FlutterLoader flutterLoader = FlutterInjector.instance().flutterLoader();
        if (!flutterLoader.initialized()) {
            flutterLoader.startInitialization(getApplicationContext());
        }
        flutterLoader.ensureInitializationCompleteAsync(getApplicationContext(), null, new Handler(Looper.getMainLooper()), () -> {
            DartEntrypoint entryPoint = new DartEntrypoint(flutterLoader.findAppBundlePath(), "sosServiceCallback");
            engine.getDartExecutor().executeDartEntrypoint(entryPoint);
        });
    };

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        final String CHANNELID = "Foreground Service ID";
        NotificationChannel channel = new NotificationChannel(
                CHANNELID,
                CHANNELID,
                NotificationManager.IMPORTANCE_LOW
        );

        getSystemService(NotificationManager.class).createNotificationChannel(channel);
        Notification.Builder notification = new Notification.Builder(this, CHANNELID)
                .setContentTitle("Floating SOS Button visible.")
                .setContentText("Service is running.")
                .setSmallIcon(R.drawable.icon_flutter);
        startForeground(1001, notification.build());
        return super.onStartCommand(intent, flags, startId);
    }

    @SuppressLint({"ClickableViewAccessibility", "InflateParams"})
    @Override
    public void onCreate() {
        super.onCreate();
        //Inflate the widget layout
        mSOSView = LayoutInflater.from(this).inflate(R.layout.layout_widget, null);

        LAYOUT_FLAG = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY;

        //Add the view to the window.
        final WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                LAYOUT_FLAG,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);

        //Specify the position
        params.gravity = Gravity.TOP | Gravity.START;        //Initially view will be added to top-left corner
        params.x = 0;
        params.y = 100;

        //Add the view to the window
        mWindowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        mWindowManager.addView(mSOSView, params);

        //Set the close button.
        ImageView closeButton = mSOSView.findViewById(R.id.close_btn);
        closeButton.setOnClickListener(v -> {
            //close the service and remove the widget from the window
            stopSelf();
        });

        //Drag and move chat head using user's touch action.
        final ImageView sosImage = mSOSView.findViewById(R.id.sos_btn);
        sosImage.setOnTouchListener(new View.OnTouchListener() {
            private int lastAction;
            private int initialX;
            private int initialY;
            private float initialTouchX;
            private float initialTouchY;

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:

                        //remember the initial position.
                        initialX = params.x;
                        initialY = params.y;

                        //get the touch location
                        initialTouchX = event.getRawX();
                        initialTouchY = event.getRawY();

                        lastAction = event.getAction();
                        return true;
                    case MotionEvent.ACTION_UP:
                        //As we implemented on touch listener with ACTION_MOVE,
                        //we have to check if the previous action was ACTION_DOWN
                        //to identify if the user clicked the view or not.
                        if (lastAction == MotionEvent.ACTION_DOWN) {
                            //Send Notification
                            mainHandler.post(myRunnable);

                            //close the service and remove the chat heads
                        }
                        lastAction = event.getAction();
                        return true;
                    case MotionEvent.ACTION_MOVE:
                        //Calculate the X and Y coordinates of the view.
                        params.x = initialX + (int) (event.getRawX() - initialTouchX);
                        params.y = initialY + (int) (event.getRawY() - initialTouchY);

                        //Update the layout with new X & Y coordinate
                        mWindowManager.updateViewLayout(mSOSView, params);
                        lastAction = event.getAction();
                        return true;
                }
                return false;
            }
        });
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mSOSView != null) mWindowManager.removeView(mSOSView);
    }
}