class AppConstants {
  static const String appName = 'DatingApp';
  static const String appVersion = '1.0.0';

  // Biaya swipe/lihat detail profil
  static const double profileViewCost = 100.0; // Misalnya, 100 koin/saldo

  // Default values
  static const double defaultInitialBalance = 50000.0; // Saldo awal untuk user baru

  // Durasi animasi, dll.
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Daftar mata uang yang didukung
  static const List<String> supportedCurrencies = ['IDR', 'USD', 'EUR', 'GBP', 'JPY'];

  // Daftar zona waktu yang didukung
  static const List<String> supportedTimezones = ['WIB', 'WITA', 'WIT', 'LONDON', 'UTC', 'NYC'];
}