package com.example.flutter_native_communication;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import org.jetbrains.annotations.NotNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;

public class ChannelsHandler implements EventChannel.StreamHandler {

    ChannelsHandler(@NonNull FlutterEngine flutterEngine) {

        //BasicMessageChannel
        BasicMessageChannel messageChannel = new BasicMessageChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "Test_BasicMessageChannel", StandardMessageCodec.INSTANCE);
        messageChannel.setMessageHandler(new BasicMessageChannel.MessageHandler() {

            @Override
            public void onMessage(Object message, @NotNull BasicMessageChannel.Reply reply) {
                if (message.equals("callback")) {
                    messageChannel.send("来自Android  BasicMessageChannel回调信息");
                }else {
                    System.out.println("来自Flutter BasicMessageChannel的消息");
                    System.out.println(message);
                }
            }
        });

        //MethodChannel
        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "Test_MethodChannel");
        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {

            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if (call.method.equals("args")) {
                    System.out.println("来自Flutter MethodChannel的参数");
                    System.out.println(call.arguments);
                    result.success("来自Android的返回信息");
                }else if (call.method.equals("error")) {
                    result.error("500", "来自Android的错误信息", "details");
                }else if (call.method.equals("notImplemented")) {
                    result.notImplemented();
                }else if (call.method.equals("callback")) {
                    result.success("Android callback send");
                    methodChannel.invokeMethod("adcallback", "来自Android  MethodChannel回调信息");
                }
            }
        });


        //EventChannel
        EventChannel eventChannel = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "Test_EventChannel");
        eventChannel.setStreamHandler(this);

    }

    private EventChannel.EventSink events;

    public void sendEvent() {
        if (events != null) {
            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> events.success("来自Android的event消息"));
        }

    }

    public void sendEventError() {
        events.error("6666", "来自Android的error event消息", null);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.events = events;
    }

    @Override
    public void onCancel(Object arguments) {
        System.out.println("Flutter 取消了 event的订阅!");
    }
}
