package com.manifest.soul

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.manifest.soul/home_widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "updateWidget" -> {
                        SoulHomeWidgetProvider.updateAllWidgets(applicationContext)
                        result.success(true)
                    }
                    "requestPinWidget" -> {
                        SoulHomeWidgetProvider.updateAllWidgets(applicationContext)
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            val appWidgetManager = AppWidgetManager.getInstance(applicationContext)
                            val provider = ComponentName(
                                applicationContext,
                                SoulHomeWidgetProvider::class.java
                            )
                            if (appWidgetManager.isRequestPinAppWidgetSupported) {
                                val pinned = appWidgetManager.requestPinAppWidget(
                                    provider,
                                    null,
                                    null
                                )
                                result.success(pinned)
                            } else {
                                result.success(false)
                            }
                        } else {
                            result.success(false)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
