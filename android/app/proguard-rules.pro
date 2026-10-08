# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**

# Dio / OkHttp
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# OneSignal
-keep class com.onesignal.** { *; }
-dontwarn com.onesignal.**

# GetX
-keep class * extends io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }

# Keep model classes (JSON serialization ke liye — fromJson/toJson tootne se bachne ke liye)
-keep class com.contol.roapp.** { *; }

# General Android
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions