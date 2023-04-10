package com.aroxoft.tagros.points

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

//import io.flutter.plugin.common.MethodChannel
//import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
//    private val CHANNEL = "com.aroxoft.tagros.points/info"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        flutterEngine.plugins.add(GoogleMobileAdsPlugin())
        super.configureFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "myAdFactory", AppNativeAdFactory(layoutInflater))

//        GeneratedPluginRegistrant.registerWith(flutterEngine);
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
//                CHANNEL).setMethodCallHandler { call, result ->
            // NOTE: this method is invoked on the main thread
//            if (call.method == "getMessage") {
//                val message = "TOTO"
//                result.success(message)
//            } else {
//                result.notImplemented()
//            }
//        }
    }
    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(
            flutterEngine,
            "myAdFactory"
        )
    }
}
