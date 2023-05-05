package com.example.nfc_intent

import android.nfc.NfcAdapter
import android.nfc.NfcAdapter.*
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
       private val CHANNEL = "com.example.flutter_app/nfc"
       private val METHOD_HANDLE_NFC = "handleNFC"
       // private var isStartedFromNFC = false

       override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
              super.configureFlutterEngine(flutterEngine)
              MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                            .setMethodCallHandler { call, result ->
                                   if (call.method == METHOD_HANDLE_NFC) {
                                          if (intent?.action == NfcAdapter.ACTION_NDEF_DISCOVERED) {
                                                 result.success("from nfc")
                                          } else if (intent?.action ==
                                                                      NfcAdapter.ACTION_TAG_DISCOVERED
                                          ) {
                                                 result.success("from nfc")
                                          } else if (intent?.action ==
                                                                      NfcAdapter.ACTION_TECH_DISCOVERED
                                          ) {

                                                 result.success("from nfc")
                                          } else {
                                                 result.success("not from nfc " + intent?.action)
                                          }
                                   } else {
                                          result.notImplemented()
                                   }
                            }
       }
}
