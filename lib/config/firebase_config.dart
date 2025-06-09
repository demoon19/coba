// lib/config/firebase_config.dart
import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    // Firebase.initializeApp() sudah dipanggil di main.dart
    // Anda bisa menambahkan konfigurasi spesifik lainnya di sini jika diperlukan
    // Misalnya, pengaturan untuk Firebase Crashlytics atau Performance Monitoring
    // if (kDebugMode) {
    //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    // }
  }
}