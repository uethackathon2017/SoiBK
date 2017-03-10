package soibk.hust.reactchat.service;

import android.app.Service;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.Binder;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Toast;

import pl.droidsonroids.gif.GifImageView;
import soibk.hust.reactchat.R;
import soibk.hust.reactchat.data.StaticConfig;

public class ReactEmotionService extends Service {
    private static String TAG = "ReactEmotionService";
    // Binder given to clients
    public final IBinder mBinder = new ReactEmotionService.LocalBinder();
    private WindowManager windowManager = null;
    private GifImageView chatHead = null;
    private WindowManager.LayoutParams params = null;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "OnStartService");
        if (windowManager == null || chatHead == null || params == null) {
            prepareShowGif();
        }
        if (intent != null) {
            showEmotion(intent.getIntExtra(StaticConfig.KEY_SHOW_EMOTION, StaticConfig.VALUE_STOP_EMOTION));
        }
        return START_STICKY;
    }

    /**
     * Hien emotion theo id
     *
     * @param id
     */
    public void showEmotion(int id) {
        if (id == StaticConfig.VALUE_STOP_EMOTION) {
            invisibleEmotion();
        } else {
            switch (id) {
                default:
                    //Change chatHead
                    Toast.makeText(this, "" + id, Toast.LENGTH_SHORT).show();
            }
            try {
                windowManager.addView(chatHead, params);
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * An Emotion
     */
    public void invisibleEmotion() {
        try {
            windowManager.removeView(chatHead);
        } catch (Exception ignored) {
        }
    }


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return mBinder;
    }

    public class LocalBinder extends Binder {
        public ReactEmotionService getService() {
            // Return this instance of LocalService so clients can call public methods
            return ReactEmotionService.this;
        }
    }

    private void prepareShowGif() {
        windowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        params = new WindowManager.LayoutParams(
                300,
                300,
                WindowManager.LayoutParams.TYPE_PHONE,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);

        params.gravity = Gravity.TOP | Gravity.START;
        params.x = 0;
        params.y = 0;
        chatHead = new GifImageView(this);
        chatHead.setImageResource(R.drawable.dog);

        chatHead.setOnTouchListener(new View.OnTouchListener() {
            private int initialX;
            private int initialY;
            private float initialTouchX;
            private float initialTouchY;

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        initialX = params.x;
                        initialY = params.y;
                        initialTouchX = event.getRawX();
                        initialTouchY = event.getRawY();
                        return false;
                    case MotionEvent.ACTION_UP:
                        return false;
                    case MotionEvent.ACTION_MOVE:
                        params.x = initialX
                                + (int) (event.getRawX() - initialTouchX);
                        params.y = initialY
                                + (int) (event.getRawY() - initialTouchY);
                        windowManager.updateViewLayout(chatHead, params);
                        return false;
                }
                return false;
            }
        });
    }
}
