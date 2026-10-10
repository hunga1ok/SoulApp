package com.manifest.soul

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.widget.RemoteViews

class SoulHomeWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        private const val PREFS_NAME = "FlutterSharedPreferences"

        fun updateAllWidgets(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val componentName = ComponentName(context, SoulHomeWidgetProvider::class.java)
            val ids = manager.getAppWidgetIds(componentName)
            if (ids.isNotEmpty()) {
                for (id in ids) {
                    updateWidget(context, manager, id)
                }
            }
        }

        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val preferredName = prefs.getString("flutter.preferred_name", null)?.trim()
            val defaultTitle = if (!preferredName.isNullOrEmpty()) {
                "Soul • $preferredName"
            } else {
                "A Little World Where You Feel Safe"
            }

            val badge = prefs.getString("flutter.widget_badge", null)
                ?: "SOUL • TẦM NHÌN & BIẾT ƠN"
            val title = prefs.getString("flutter.widget_title", null)
                ?: defaultTitle
            val body = prefs.getString("flutter.widget_body", null)
                ?: "Mỗi ngày của tôi được lấp đầy bởi sự bình an, lòng biết ơn và những điều dịu dàng."
            val footer = prefs.getString("flutter.widget_footer", null)
                ?: "Chạm để mở Soul ✦"
            val theme = prefs.getString("flutter.widget_theme", null) ?: "plum"

            val views = RemoteViews(context.packageName, R.layout.soul_home_widget)

            val musicTrack = prefs.getString("flutter.widget_music_track", null)
            val frequency = prefs.getString("flutter.widget_frequency", null)

            when (theme) {
                "paper" -> {
                    views.setInt(
                        R.id.soul_widget_root,
                        "setBackgroundResource",
                        R.drawable.bg_soul_widget_paper
                    )
                    views.setTextColor(R.id.soul_widget_badge, Color.parseColor("#7A4E6D"))
                    views.setTextColor(R.id.soul_widget_title, Color.parseColor("#3E2438"))
                    views.setTextColor(R.id.soul_widget_body, Color.parseColor("#2E1A29"))
                    views.setTextColor(R.id.soul_widget_footer, Color.parseColor("#8A6B80"))
                    views.setTextColor(R.id.soul_widget_music_title, Color.parseColor("#3E2438"))
                    views.setTextColor(R.id.soul_widget_music_subtitle, Color.parseColor("#7A4E6D"))
                }
                "rose" -> {
                    views.setInt(
                        R.id.soul_widget_root,
                        "setBackgroundResource",
                        R.drawable.bg_soul_widget_rose
                    )
                    views.setTextColor(R.id.soul_widget_badge, Color.parseColor("#6D3D5E"))
                    views.setTextColor(R.id.soul_widget_title, Color.parseColor("#3A1F33"))
                    views.setTextColor(R.id.soul_widget_body, Color.parseColor("#2B1626"))
                    views.setTextColor(R.id.soul_widget_footer, Color.parseColor("#764D69"))
                    views.setTextColor(R.id.soul_widget_music_title, Color.parseColor("#3A1F33"))
                    views.setTextColor(R.id.soul_widget_music_subtitle, Color.parseColor("#6D3D5E"))
                }
                else -> {
                    views.setInt(
                        R.id.soul_widget_root,
                        "setBackgroundResource",
                        R.drawable.bg_soul_widget_plum
                    )
                    views.setTextColor(R.id.soul_widget_badge, Color.parseColor("#E8D2E1"))
                    views.setTextColor(R.id.soul_widget_title, Color.parseColor("#FFF9F5"))
                    views.setTextColor(R.id.soul_widget_body, Color.parseColor("#FFF9F5"))
                    views.setTextColor(R.id.soul_widget_footer, Color.parseColor("#D9C0D1"))
                    views.setTextColor(R.id.soul_widget_music_title, Color.parseColor("#FFF9F5"))
                    views.setTextColor(R.id.soul_widget_music_subtitle, Color.parseColor("#D9C0D1"))
                }
            }

            views.setTextViewText(R.id.soul_widget_badge, badge)
            views.setTextViewText(R.id.soul_widget_title, title)
            views.setTextViewText(R.id.soul_widget_body, body)
            views.setTextViewText(R.id.soul_widget_footer, footer)

            if (!musicTrack.isNullOrEmpty()) {
                views.setViewVisibility(R.id.soul_widget_player_bar, android.view.View.VISIBLE)
                views.setTextViewText(R.id.soul_widget_music_title, musicTrack)
                views.setTextViewText(
                    R.id.soul_widget_music_subtitle,
                    if (!frequency.isNullOrEmpty()) "Tần số $frequency • Chữa lành tâm hồn" else "Soul Healing Frequency"
                )
            } else {
                views.setViewVisibility(R.id.soul_widget_player_bar, android.view.View.GONE)
            }

            val launchIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                appWidgetId,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.soul_widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
