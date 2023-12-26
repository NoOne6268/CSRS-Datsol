package com.datsol.csrs;

import android.app.Service;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.Build;
import android.os.IBinder;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;

public class WidgetService extends Service {
//    private WindowManager mWindowManager;
//    private View mFloatingWidget;
//    ImageView imageClose;
//    int LAYOUT_FLAG;
//    public WidgetService() {
//    }
//    @Override
//    public IBinder onBind(Intent intent) {
//        return null;
//    }
//    @Override
//    public void onCreate() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            LAYOUT_FLAG = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY;
//        } else {
//            LAYOUT_FLAG = WindowManager.LayoutParams.TYPE_PHONE;
//        }
//
//        super.onCreate();
//        mFloatingWidget = LayoutInflater.from(this).inflate(R.layout.layout_widget, null);
//
//        // sos button
//        final WindowManager.LayoutParams sosButtonparams = new WindowManager.LayoutParams(
//                WindowManager.LayoutParams.WRAP_CONTENT,
//                WindowManager.LayoutParams.WRAP_CONTENT,
//                LAYOUT_FLAG,
//                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
//                PixelFormat.TRANSLUCENT
//        );
//        sosButtonparams.gravity = Gravity.TOP | Gravity.LEFT;
//        sosButtonparams.x = 0;
//        sosButtonparams.y = 100;
//
//        //close button
//        final WindowManager.LayoutParams closeparams = new WindowManager.LayoutParams(140, 140,
//                LAYOUT_FLAG,
//                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
//                PixelFormat.TRANSLUCENT);
//        closeparams.gravity = Gravity.BOTTOM|Gravity.CENTER;
//        closeparams.y = 100;
//
//        mWindowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
//        imageClose = new ImageView(this);
//        imageClose.setImageResource(R.drawable.x);
//        imageClose.setVisibility(View.INVISIBLE);
//        mFloatingWidget.setVisibility(View.VISIBLE);
//        mWindowManager.addView(mFloatingWidget, sosButtonparams);
//        mWindowManager.addView(imageClose, closeparams);
//
//        final View collapsedView = mFloatingWidget.findViewById(R.id.collapse_view);
//        final View expandedView = mFloatingWidget.findViewById(R.id.expanded_container);
//        ImageView closeButtonCollapsed = (ImageView) mFloatingWidget.findViewById(R.id.close_btn);
//        closeButtonCollapsed.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                stopSelf();
//            }
//        });
//        TextView closeButton = (TextView) mFloatingWidget.findViewById(R.id.close_button);
//        closeButton.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                collapsedView.setVisibility(View.VISIBLE);
//                expandedView.setVisibility(View.GONE);
//            }
//        });
//        mFloatingWidget.findViewById(R.id.root_container)
//                .setOnTouchListener(new View.OnTouchListener() {
//            private int initialX, initialY;
//            private float initialTouchX, initialTouchY;
//
//            public boolean onTouch(View v, MotionEvent event) {
//                switch (event.getAction()) {
//                    case MotionEvent.ACTION_DOWN:
//                        imageClose.setVisibility(View.VISIBLE);
//
//                        initialX = sosButtonparams.x;
//                        initialY = sosButtonparams.y;
//
//                        initialTouchX = event.getRawX();
//                        initialTouchY = event.getRawY();
//
//                        return true;
//                    case MotionEvent.ACTION_UP:
//                        imageClose.setVisibility(View.GONE);
//
//                        sosButtonparams.x = initialX + (int)(initialTouchX - event.getRawX());
//                        sosButtonparams.y = initialY + (int)(event.getRawY() - initialTouchY);
//
//                        if(sosButtonparams.y > height*0.6){
//
//                        }
//
//                        int Xdiff = (int) (event.getRawX() - initialTouchX);
//                        int Ydiff = (int) (event.getRawY() - initialTouchY);
//                        if (Xdiff < 10 && Ydiff < 10) {
//                                imageClose.setVisibility(View.GONE);
//                                expandedView.setVisibility(View.VISIBLE);
//                        }
//                        return true;
//                    case MotionEvent.ACTION_MOVE:
//                        sosButtonparams.x = initialX + (int) (event.getRawX() - initialTouchX);
//                        sosButtonparams.y = initialY + (int) (event.getRawY() - initialTouchY);
//                        mWindowManager.updateViewLayout(mFloatingWidget, sosButtonparams);
//                        return true;
//                }
//                return false;
//            }
//        });
//    }
//    @Override
//    public void onDestroy() {
//        super.onDestroy();
//        if (mFloatingWidget != null) mWindowManager.removeView(mFloatingWidget);
//    }

    private WindowManager mWindowManager;
    private View mFloatingWidget;
    int LAYOUT_FLAG;
    public WidgetService() {
    }
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
    @Override
    public void onCreate() {
        super.onCreate();
        mFloatingWidget = LayoutInflater.from(this).inflate(R.layout.layout_widget, null);

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            LAYOUT_FLAG = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY;
        } else {
            LAYOUT_FLAG = WindowManager.LayoutParams.TYPE_PHONE;
        }

        final WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                LAYOUT_FLAG,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
        );
        params.gravity = Gravity.TOP | Gravity.START;
        params.x = 0;
        params.y = 100;
        mWindowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        mWindowManager.addView(mFloatingWidget, params);

        final View collapsedView = mFloatingWidget.findViewById(R.id.collapse_view);
        ImageView closeButton = (ImageView) mFloatingWidget.findViewById(R.id.close_btn);
        closeButton.setOnClickListener(view -> collapsedView.setVisibility(View.VISIBLE));
        mFloatingWidget.findViewById(R.id.root_container).setOnTouchListener(new View.OnTouchListener() {
            private int initialX;
            private int initialY;
            private float initialTouchX;
            private float initialTouchY;
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        initialX = params.x;
                        initialY = params.y;
                        initialTouchX = event.getRawX();
                        initialTouchY = event.getRawY();
                        return true;
                    case MotionEvent.ACTION_UP:
                        int Xdiff = (int) (event.getRawX() - initialTouchX);
                        int Ydiff = (int) (event.getRawY() - initialTouchY);
                        if (Xdiff < 10 && Ydiff < 10) {
                            if (isViewCollapsed()) {
                                collapsedView.setVisibility(View.GONE);
                            }
                        }
                        return true;
                    case MotionEvent.ACTION_MOVE:
                        params.x = initialX + (int) (event.getRawX() - initialTouchX);
                        params.y = initialY + (int) (event.getRawY() - initialTouchY);
                        mWindowManager.updateViewLayout(mFloatingWidget, params);
                        return true;
                }
                return false;
            }
        });
    }
    private boolean isViewCollapsed() {
        return mFloatingWidget == null || mFloatingWidget.findViewById(R.id.collapse_view).getVisibility() == View.VISIBLE;
    }
    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mFloatingWidget != null) mWindowManager.removeView(mFloatingWidget);
    }
}