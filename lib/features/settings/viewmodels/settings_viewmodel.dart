import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Untuk menyimpan pengaturan lokal

class SettingsViewModel extends ChangeNotifier {
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = true;
  String? _selectedLanguage = 'en'; // Default English

  bool get darkModeEnabled => _darkModeEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  String? get selectedLanguage => _selectedLanguage;

  SettingsViewModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _darkModeEnabled = prefs.getBool('darkModeEnabled') ?? false;
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _darkModeEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkModeEnabled', value);
    notifyListeners();
    // Di sini Anda bisa menambahkan logika untuk mengubah tema aplikasi secara dinamis
    // Misalnya, memanggil `Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value);`
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    notifyListeners();
    // Di sini Anda bisa menambahkan logika untuk mengaktifkan/menonaktifkan FCM subscriptions
  }

  Future<void> changeLanguage(String? languageCode) async {
    _selectedLanguage = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode ?? 'en');
    notifyListeners();
    // Di sini Anda bisa menambahkan logika untuk mengubah lokal aplikasi
  }

  // Metode untuk logout (akan dihandle oleh AuthProvider, tapi bisa dipanggil dari sini)
  // Tidak ada logika logout langsung di ViewModel ini karena AuthProvider yang bertanggung jawab
}