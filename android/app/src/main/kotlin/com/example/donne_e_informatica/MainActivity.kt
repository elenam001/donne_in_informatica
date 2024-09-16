package com.example.donne_e_informatica

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 100) {
            // Handle permission result
        }
    }

}
