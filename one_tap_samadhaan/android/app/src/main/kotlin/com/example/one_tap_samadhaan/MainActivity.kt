package com.example.one_tap_samadhaan

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.google.android.gms.maps.MapsInitializer // <-- THIS IS THE FIX

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MapsInitializer.initialize(this)
    }
}