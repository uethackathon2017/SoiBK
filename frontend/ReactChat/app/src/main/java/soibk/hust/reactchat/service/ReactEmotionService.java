package soibk.hust.reactchat.service;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.graphics.drawable.BitmapDrawable;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Binder;
import android.os.CountDownTimer;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.support.v4.app.NotificationCompat;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Toast;

import java.io.IOException;

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
    private MediaPlayer mediaPlayer;
    private CountDownTimer countDownTimer;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "OnStartService");
        if (windowManager == null || chatHead == null || params == null) {
            prepareShowGif();
        }
        if (intent != null) {
            showEmotion(intent.getIntExtra(StaticConfig.KEY_SHOW_EMOTION, StaticConfig.VALUE_STOP_EMOTION), null);
        }
        return START_STICKY;
    }

    /**
     * Hien emotion theo id
     *
     * @param id
     */
    public void showEmotion(int id, String urlAudio) {
        countDownTimer.cancel();
        if (id == StaticConfig.VALUE_STOP_EMOTION) {
            invisibleEmotion();
        } else {
            chatHead.setImageDrawable(null);
            if (id != StaticConfig.VALUE_DEFAULT_EMOTION && id != StaticConfig.VALUE_PLAY_MUSIC_EMOTION) {
                countDownTimer.start();
            } else if (id == StaticConfig.VALUE_PLAY_MUSIC_EMOTION && urlAudio != null) {
                startStreamMusic(urlAudio);
            }
            try {
                windowManager.removeView(chatHead);
            } catch (Exception ignored) {
            }
            chatHead.setImageResource(id);
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
        countDownTimer = new CountDownTimer(10000, 10000) {
            @Override
            public void onTick(long l) {
            }

            @Override
            public void onFinish() {
                showEmotion(StaticConfig.VALUE_DEFAULT_EMOTION, null);
            }
        };

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
        chatHead.setImageResource(R.drawable.x);

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
                        float endX = event.getRawX();
                        float endY = event.getRawY();
                        if (isAClick(initialTouchX, endX, initialTouchY, endY)) {
                            stopStreamMusic();
//                            headNotify();
//                            showEmotion(StaticConfig.MAP_EMOTION.get("ac"), null);
//                            startStreamMusic("http://320.s1.mp3.zdn.vn/65f714fdfbb912e74ba8/3957087340509527650?key=qCzD2liBoUMPMHJvU0Wv-A&expires=1489303215");
                        }
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

    private boolean isAClick(float startX, float endX, float startY, float endY) {
        float differenceX = Math.abs(startX - endX);
        float differenceY = Math.abs(startY - endY);
        if (differenceX > StaticConfig.CLICK_ACTION_THRESHHOLD || differenceY > StaticConfig.CLICK_ACTION_THRESHHOLD) {
            return false;
        }
        return true;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        try {
            windowManager.removeView(chatHead);
        } catch (Exception ignored) {
        }
    }

    /**
     * Tắt nhạc khi nhấn vào emotion chơi nhacj
     */
    public void stopStreamMusic() {
        if (mediaPlayer != null) {
            if (mediaPlayer.isPlaying()) {
                mediaPlayer.stop();
            }
            mediaPlayer.release();
            showEmotion(StaticConfig.VALUE_DEFAULT_EMOTION, null);
        }
        mediaPlayer = null;
    }

    /**
     * Chơi nhạc khi hiển thị emotion chơi nhạc
     *
     * @param url
     */
    private void startStreamMusic(final String url) {
        new Thread() {
            @Override
            public void run() {
                if (mediaPlayer == null) {
                    mediaPlayer = new MediaPlayer();
                }
                mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
                mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                    @Override
                    public void onCompletion(MediaPlayer mediaPlayer) {
                        stopStreamMusic();
                        showEmotion(StaticConfig.VALUE_DEFAULT_EMOTION, null);
                    }
                });
                try {
                    mediaPlayer.setDataSource(url);
                    mediaPlayer.prepare(); // might take long! (for buffering, etc)
                    mediaPlayer.start();
                } catch (Exception e) {
                    e.printStackTrace();
                    mediaPlayer = null;
                }
            }
        }.start();
    }
}
