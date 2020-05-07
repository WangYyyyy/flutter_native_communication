package com.example.flutter_native_communication

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        var chandler = ChannelsHandler(flutterEngine);


        Thread(Runnable {
            while (true) {
                Thread.sleep(5000)
                chandler.sendEvent();
            }
        }).start()
    }
}
