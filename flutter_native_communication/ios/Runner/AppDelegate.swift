import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let root = self.window.rootViewController as! FlutterViewController
    
    //BasicMessageChannel
    let messageChannel = FlutterBasicMessageChannel.init(name: "Test_BasicMessageChannel", binaryMessenger:root.binaryMessenger , codec: FlutterStandardMessageCodec.sharedInstance())
    messageChannel.setMessageHandler { (message, reply) in
        if message as? String == "callback" {
            messageChannel.sendMessage("来自iOS  BasicMessageChannel回调信息")
        }else {
            NSLog("来自Flutter BasicMessageChannel的消息\n%@", (String(describing: message!)))
        }
    }
    
    //MethodChannel
    let methodChannel = FlutterMethodChannel.init(name: "Test_MethodChannel", binaryMessenger: root.binaryMessenger)
    methodChannel.setMethodCallHandler { (call, result) in
        if call.method == "args" {
            NSLog("来自Flutter MethodChannel的参数")
            NSLog("\(call.arguments ?? "空参数")")
            result("来自iOS的返回信息")
        }else if call.method == "error" {
            result(FlutterError.init(code: "500", message: "iOS的错误信息", details: "details"))
        }else if call.method == "notImplemented" {
            result(FlutterMethodNotImplemented)
        }else if call.method == "callback" {
            result("iOS callback send")
            methodChannel.invokeMethod("adcallback", arguments: "来自iOS  MethodChannel回调信息")
        }
    }
    
    //EventChannel
    let eventChannel = FlutterEventChannel.init(name: "Test_EventChannel", binaryMessenger: root.binaryMessenger)
    eventChannel.setStreamHandler(self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func sendEvent() {
        NSLog("sendEvent")
        self.events?("来自iOS的error event消息")
    }
    
    var events:FlutterEventSink?;
    
    //MARK: FlutterStreamHandler
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.events = events;
        return nil;
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NSLog("Flutter 取消了 event的订阅!")
        return nil;
    }
}
