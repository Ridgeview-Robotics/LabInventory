# Retain QR code functionality
-keep class com.google.zxing.** { *; }
-dontwarn com.google.zxing.**

# Keep database models
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}
