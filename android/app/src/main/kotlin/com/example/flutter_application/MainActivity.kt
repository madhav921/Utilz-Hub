package com.example.flutter_application

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Typeface
import android.os.Build
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.utilzhub/shortcuts"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isSupported" -> {
                        result.success(
                            ShortcutManagerCompat.isRequestPinShortcutSupported(this)
                        )
                    }
                    "getInitialToolId" -> {
                        val toolId = intent?.getStringExtra("tool_id")
                        result.success(toolId ?: "")
                    }
                    "pinShortcut" -> {
                        val id = call.argument<String>("id") ?: ""
                        val label = call.argument<String>("label") ?: "Tool"

                        // Create a simple letter-icon bitmap
                        val bmp = createLetterBitmap(label)
                        val icon = IconCompat.createWithBitmap(bmp)

                        val intent = Intent(this, MainActivity::class.java).apply {
                            action = Intent.ACTION_VIEW
                            putExtra("tool_id", id)
                        }

                        val shortcut = ShortcutInfoCompat.Builder(this, "tool_$id")
                            .setShortLabel(label)
                            .setLongLabel(label)
                            .setIcon(icon)
                            .setIntent(intent)
                            .build()

                        val pinned = ShortcutManagerCompat.requestPinShortcut(
                            this, shortcut, null
                        )
                        result.success(pinned)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /** Creates a 96×96 bitmap with the first letter of the tool name. */
    private fun createLetterBitmap(label: String): Bitmap {
        val size = 96
        val bmp = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bmp)

        // Background circle
        val bgPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = 0xFF6366F1.toInt() // Indigo accent
            style = Paint.Style.FILL
        }
        canvas.drawCircle(size / 2f, size / 2f, size / 2f, bgPaint)

        // Letter
        val textPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = 0xFFFFFFFF.toInt()
            textSize = 48f
            typeface = Typeface.DEFAULT_BOLD
            textAlign = Paint.Align.CENTER
        }
        val letter = label.firstOrNull()?.uppercase() ?: "U"
        val yPos = size / 2f - (textPaint.descent() + textPaint.ascent()) / 2f
        canvas.drawText(letter, size / 2f, yPos, textPaint)

        return bmp
    }
}
