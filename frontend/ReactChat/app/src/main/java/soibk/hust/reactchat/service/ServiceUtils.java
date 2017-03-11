package soibk.hust.reactchat.service;

import android.app.ActivityManager;
import android.content.Context;
import android.net.ConnectivityManager;

/**
 * Created by nguyenbinh on 11/03/2017.
 */

public class ServiceUtils {

    /**
     * Check service running
     *
     * @param context
     * @param serviceClass
     * @return
     */
    static boolean isServiceRunning(Context context, Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check internet connected
     *
     * @param context
     * @return
     */
    static boolean isNetworkConnected(Context context) {
        try {
            ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
            return cm.getActiveNetworkInfo() != null;
        } catch (Exception e) {
            return true;
        }
    }
}
