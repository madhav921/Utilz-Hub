# ── Flutter / Dart ─────────────────────────────────────────
# Keep Flutter engine & plugin entry points
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# ── Kotlin metadata (needed for reflection-free Kotlin code) ──
-dontwarn kotlin.**
-keep class kotlin.Metadata { *; }

# ── AndroidX / Jetpack ───────────────────────────────────
-dontwarn androidx.**
-keep class androidx.core.content.pm.ShortcutManagerCompat { *; }
-keep class androidx.core.content.pm.ShortcutInfoCompat** { *; }
-keep class androidx.core.graphics.drawable.IconCompat { *; }

# ── R8 full mode ──────────────────────────────────────────
-allowaccessmodification
-repackageclasses
