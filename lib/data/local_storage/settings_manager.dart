import 'package:hive_flutter/hive_flutter.dart';

class SettingsManager {
  static late Box _settingsBox;
  static const String _boxName = 'app_settings';

  static Future<void> init() async {
    // Pastikan Hive.initFlutter() sudah dipanggil di main.dart
    _settingsBox = await Hive.openBox(_boxName);
  }

  static Future<void> setBool(String key, bool value) async {
    await _settingsBox.put(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _settingsBox.get(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    await _settingsBox.put(key, value);
  }

  static String? getString(String key) {
    return _settingsBox.get(key);
  }

  static Future<void> clearSettings() async {
    await _settingsBox.clear();
  }
}