#include "hello.h"
#include <android/log.h>

int sayHello () {
    __android_log_print(ANDROID_LOG_INFO, "HELLO", "Hello World");
    return 0;
}

int add (int a, int b) {
    return a + b;
}

int sub (int a, int b) {
    return a - b;
}
