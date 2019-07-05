package com.zlargon.hello.example;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import com.zlargon.hello.hellosdk.HelloSDK;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void Hello(View v) {
        HelloSDK.sayHello();
        Log.i("HELLO", "add(1, 2) = " + HelloSDK.add(1, 2));
        Log.i("HELLO", "sub(1, 2) = " + HelloSDK.sub(1, 2));
    }

}
