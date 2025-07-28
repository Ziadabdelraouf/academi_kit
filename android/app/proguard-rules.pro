# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }

# Keep keyboard/input classes
-keep class android.view.inputmethod.** { *; }
-keep class androidx.core.view.inputmethod.** { *; }
-keep class * implements android.view.inputmethod.InputConnection
-keep class * implements android.view.inputmethod.InputMethodManager

# Keep TextInput/EditText related classes
-keep class android.widget.EditText { *; }
-keep class android.text.** { *; }
-keep class android.view.inputmethod.InputMethodManager