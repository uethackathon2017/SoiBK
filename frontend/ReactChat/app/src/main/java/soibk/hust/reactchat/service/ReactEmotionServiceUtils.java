package soibk.hust.reactchat.service;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;

import soibk.hust.reactchat.data.StaticConfig;

/**
 * Created by nguyenbinh on 11/03/2017.
 */

public class ReactEmotionServiceUtils extends ServiceUtils{
    private static ServiceConnection connectionReactEmotionService = null;

    public static void stopReactEmotionService(Context context) {
        if (isServiceRunning(context, ReactEmotionService.class)) {
            Intent intent = new Intent(context, ReactEmotionService.class);
            connectionReactEmotionService = new ServiceConnection() {
                @Override
                public void onServiceConnected(ComponentName className,
                                               IBinder service) {
                    ReactEmotionService.LocalBinder binder = (ReactEmotionService.LocalBinder) service;
                    binder.getService().stopSelf();
                }

                @Override
                public void onServiceDisconnected(ComponentName arg0) {
                }
            };
            context.bindService(intent, connectionReactEmotionService, Context.BIND_NOT_FOREGROUND);
        }
    }

    public static void startReactEmotionService(Context context) {
//        if (!isServiceRunning(context, ReactEmotionService.class)) {
            changeEmotion(context, StaticConfig.VALUE_DEFAULT_EMOTION, null);
//        }
    }

    public static void changeEmotion(Context context, final int id, final String url){
        if (!isServiceRunning(context, ReactEmotionService.class)) {
            Intent myIntent = new Intent(context, ReactEmotionService.class);
            myIntent.putExtra(StaticConfig.KEY_SHOW_EMOTION, id);
            context.startService(myIntent);
        } else {
            connectionReactEmotionService = new ServiceConnection() {
                @Override
                public void onServiceConnected(ComponentName className,
                                               IBinder service) {
                    ReactEmotionService.LocalBinder binder = (ReactEmotionService.LocalBinder) service;
                    binder.getService().showEmotion(id, url);
                }

                @Override
                public void onServiceDisconnected(ComponentName arg0) {
                }
            };
            Intent intent = new Intent(context, ReactEmotionService.class);
            context.bindService(intent, connectionReactEmotionService, Context.BIND_NOT_FOREGROUND);
        }
    }
}
