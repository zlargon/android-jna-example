package com.zlargon.hello.hellosdk;

import com.sun.jna.Native;

public class HelloNative {
    static {
        Native.register(HelloNative.class, "hello");
    }

    static native int sayHello();
    static native int add(int a, int b);
    static native int sub(int a, int b);
}
