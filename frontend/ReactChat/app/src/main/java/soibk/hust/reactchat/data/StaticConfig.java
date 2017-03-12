package soibk.hust.reactchat.data;


import java.util.HashMap;
import java.util.Map;

import soibk.hust.reactchat.R;

public class StaticConfig {
    public static int REQUEST_CODE_REGISTER = 2000;
    public static String STR_EXTRA_ACTION_LOGIN = "login";
    public static String STR_EXTRA_ACTION_RESET = "resetpass";
    public static String STR_EXTRA_ACTION = "action";
    public static String STR_EXTRA_USERNAME = "username";
    public static String STR_EXTRA_PASSWORD = "password";
    public static String STR_DEFAULT_BASE64 = "default";
    public static String UID = "";
    //TODO only use this UID for debug mode
//    public static String UID = "6kU0SbJPF5QJKZTfvW1BqKolrx22";
    public static String INTENT_KEY_CHAT_FRIEND = "friendname";
    public static String INTENT_KEY_CHAT_AVATA = "friendavata";
    public static String INTENT_KEY_CHAT_ID = "friendid";
    public static String INTENT_KEY_CHAT_ROOM_ID = "roomid";
    public static long TIME_TO_REFRESH = 10 * 1000;
    public static long TIME_TO_OFFLINE = 2 * 60 * 1000;
    public static int  CLICK_ACTION_THRESHHOLD =5;
    public static String KEY_SHOW_EMOTION = "id";
    public static int VALUE_STOP_EMOTION = -1;
    public static int VALUE_DEFAULT_EMOTION = R.drawable.x;
    public static int VALUE_PLAY_MUSIC_EMOTION = R.drawable.ac;
    public static String DEFAULT_HOST_API = "http://10.10.215.51:8080";

    public static Map<String, Integer> MAP_EMOTION = new HashMap<>();

    static {
        MAP_EMOTION.put("a", R.drawable.a);
        MAP_EMOTION.put("ab", R.drawable.ab);
        MAP_EMOTION.put("ac", R.drawable.ac);
        MAP_EMOTION.put("ad", R.drawable.ad);
        MAP_EMOTION.put("b", R.drawable.b);
        MAP_EMOTION.put("c", R.drawable.c);
        MAP_EMOTION.put("d", R.drawable.d);
        MAP_EMOTION.put("e", R.drawable.e);
        MAP_EMOTION.put("f", R.drawable.f);
        MAP_EMOTION.put("g", R.drawable.g);
        MAP_EMOTION.put("h", R.drawable.h);
        MAP_EMOTION.put("i", R.drawable.i);
        MAP_EMOTION.put("j", R.drawable.j);
        MAP_EMOTION.put("k", R.drawable.k);
        MAP_EMOTION.put("l", R.drawable.l);
        MAP_EMOTION.put("m", R.drawable.m);
        MAP_EMOTION.put("n", R.drawable.n);
        MAP_EMOTION.put("o", R.drawable.o);
        MAP_EMOTION.put("p", R.drawable.p);
        MAP_EMOTION.put("t", R.drawable.t);
        MAP_EMOTION.put("s", R.drawable.s);
        MAP_EMOTION.put("v", R.drawable.v);
        MAP_EMOTION.put("x", R.drawable.x);
        MAP_EMOTION.put("y", R.drawable.y);
        MAP_EMOTION.put("w", R.drawable.w);
        MAP_EMOTION.put("z", R.drawable.z);
    }

}
