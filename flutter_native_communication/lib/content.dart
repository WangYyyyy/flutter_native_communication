import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessagerPage extends StatelessWidget {
  const MessagerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final messageChannel = BasicMessageChannel("Test_BasicMessageChannel", StandardMessageCodec());
    final methodChannel = MethodChannel("Test_MethodChannel");
    final eventChannel = EventChannel("Test_EventChannel");

    //BasicMessageChannel 回调函数
    messageChannel.setMessageHandler((dynamic value) {
      print(value);
      return null;
    });

    //MethodChannel 回调函数
    Future<dynamic> platformCallHandler(MethodCall call) async {
      if (call.method == 'adcallback') {
        print(call.arguments);
      }
    }
    //MethodChannel 设置回调
    methodChannel.setMethodCallHandler(platformCallHandler);

    //EventChannel 回调
    void _onEvent(Object event) {
      // 正常数据流
      print(event);
    }
    void _onError(Object error) {
      // 失败数据流
      print(error);
    }
    //EventChannel 订阅的对象
    StreamSubscription<dynamic> streamSubscription = eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);

    return Scaffold(
      appBar: AppBar(
        title: Text("原生通讯"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 100),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                messageChannel.send({"p1": "value", "p2": 1234});
              },
              child: Text("BasicMessageChannel  --send args"),
            ),
            RaisedButton(
              onPressed: () {
                messageChannel.send("callback");
              },
              child: Text("BasicMessageChannel  --callback"),
            ),
            RaisedButton(
              onPressed: () async {
                final res = await methodChannel.invokeMethod("args", {"p1": "1", "p2": 2});
                print(res);
              },
              child: Text("MethodChannel  --args"),
            ),
            RaisedButton(
              onPressed: () async {
                try {
                  methodChannel.invokeMethod("error");  
                } catch (e) {
                  print(e);
                }
                
              },
              child: Text("MethodChannel  --error"),
            ),
            RaisedButton(
              onPressed: () async {
                try {
                  methodChannel.invokeMethod("notImplemented");
                } catch (e) {
                  print(e);
                }
              },
              child: Text("MethodChannel  --notImplemented"),
            ),
            RaisedButton(
              onPressed: () async {
                final res = await methodChannel.invokeMethod("callback");
                print(res);
              },
              child: Text("MethodChannel  --callback"),
            ),
            RaisedButton(
              onPressed: () {
                streamSubscription.cancel();
              },
              child: Text("取消 EventChannel 订阅"),
            ),
          ],
        ),
      ),
    );
  }
}