import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dating/api/models/currency_model.dart'; // Pastikan ini diimpor

class CurrencyService {
  // Ganti dengan API key dan URL API konversi mata uang Anda yang sebenarnya
  // Contoh menggunakan ExchangeRate-API (Free plan mungkin terbatas)
  // Daftar di https://www.exchangerate-api.com/
  static const String _apiKey = 'YOUR_EXCHANGE_RATE_API_KEY'; // GANTI INI!
  static const String _baseUrl =
      'https://v6.exchangerate-api.com/v6/$_apiKey/latest/';

  Future<CurrencyExchangeRate?> getExchangeRates(String baseCurrency) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$baseCurrency'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CurrencyExchangeRate.fromJson(data);
      } else {
        print('Failed to load exchange rates: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching exchange rates: $e');
      return null;
    }
  }

  // Fungsi konversi waktu (lokal)
  String convertTimeToZone(DateTime dateTime, String timezoneIdentifier) {
    // Implementasi konversi zona waktu
    // Contoh sederhana, Anda perlu library yang lebih kuat untuk zona waktu yang kompleks
    // atau gunakan package seperti 'timezone'
    switch (timezoneIdentifier.toUpperCase()) {
      case 'WIB': // Western Indonesia Time (UTC+7)
        return dateTime
            .add(const Duration(hours: 7) - dateTime.timeZoneOffset)
            .toIso8601String();
      case 'WITA': // Central Indonesia Time (UTC+8)
        return dateTime
            .add(const Duration(hours: 8) - dateTime.timeZoneOffset)
            .toIso8601String();
      case 'WIT': // Eastern Indonesia Time (UTC+9)
        return dateTime
            .add(const Duration(hours: 9) - dateTime.timeZoneOffset)
            .toIso8601String();
      case 'LONDON': // GMT/UTC (tergantung DST)
        return dateTime.toUtc().toIso8601String(); // Contoh paling dasar
      default:
        return dateTime.toIso8601String();
    }
  }
}
