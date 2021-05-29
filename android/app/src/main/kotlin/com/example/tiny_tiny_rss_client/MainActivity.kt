package com.example.tiny_tiny_rss_client

import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onPostResume() {
        super.onPostResume()
        WindowCompat.setDecorFitsSystemWindows(window, false)
        window.navigationBarColor = 0 //for transparent nav bar
        window.statusBarColor = 0 //for transparent status bar
    }
}
