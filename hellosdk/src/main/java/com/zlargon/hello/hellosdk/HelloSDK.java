package com.zlargon.hello.hellosdk;

import android.util.Log;

public final class HelloSDK {

    private static final  String TAG = "HelloSDK";

    public static void sayHello () {
        Log.d(TAG,"Hello World");
    }

    public static int add (int a, int b) {
        return a + b;
    }

    public static int sub (int a, int b) {
        return a - b;
    }
}
