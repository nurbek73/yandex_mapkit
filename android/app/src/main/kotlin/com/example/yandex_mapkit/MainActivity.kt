package com.example.yandex_mapkit

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    MapKitFactory.setApiKey("be68b20f-3e58-4ded-84ad-b8d41fbc7ee5") // Your generated API key
    super.configureFlutterEngine(flutterEngine)
  }
}