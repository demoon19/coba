// Ini bisa jadi lebih kompleks jika API memberikan data kurs yang detail
class CurrencyExchangeRate {
  final String baseCurrency;
  final Map<String, double> rates; // Contoh: {'USD': 1.0, 'IDR': 15000.0}
  final DateTime lastUpdated;

  CurrencyExchangeRate({
    required this.baseCurrency,
    required this.rates,
    required this.lastUpdated,
  });

  factory CurrencyExchangeRate.fromJson(Map<String, dynamic> json) {
    // Sesuaikan dengan struktur respons API Anda
    // Contoh sederhana:
    return CurrencyExchangeRate(
      baseCurrency: json['base'],
      rates: Map<String, double>.from(json['rates'].map((key, value) => MapEntry(key, value.toDouble()))),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(json['time_last_update_unix'] * 1000), // Contoh dari ExchangeRate-API
    );
  }
}