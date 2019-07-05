package com.zlargon.hello.hellosdk;

public final class HelloSDK {

    public static void sayHello () {
        HelloNative.sayHello();
    }

    public static int add (int a, int b) {
        return HelloNative.add(a, b);
    }

    public static int sub (int a, int b) {
        return HelloNative.sub(a, b);
    }
}
