import 'package:flutter/material.dart';
import 'package:dating/api/services/currency_service.dart';
import 'package:dating/api/models/currency_model.dart';
import 'package:dating/api/services/user_service.dart'; // Untuk mendapatkan saldo pengguna

class CurrencyConverterViewModel extends ChangeNotifier {
  final CurrencyService _currencyService = CurrencyService();
  final UserService _userService = UserService();

  CurrencyExchangeRate? _exchangeRates;
  bool _isLoading = false;
  String? _errorMessage;
  double _userBalance = 0.0;
  final String _selectedBaseCurrency = 'IDR'; // Asumsi saldo di Firestore dalam IDR
  String _selectedTargetCurrency = 'USD';

  CurrencyExchangeRate? get exchangeRates => _exchangeRates;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get userBalance => _userBalance;
  String get selectedBaseCurrency => _selectedBaseCurrency;
  String get selectedTargetCurrency => _selectedTargetCurrency;

  List<String> get availableCurrencies => ['IDR', 'USD', 'EUR', 'GBP']; // Contoh
  List<String> get availableTimezones => ['WIB', 'WITA', 'WIT', 'LONDON']; // Contoh

  CurrencyConverterViewModel() {
    // Ambil rates awal saat ViewModel diinisialisasi
    fetchExchangeRates(_selectedBaseCurrency);
  }

  Future<void> fetchUserBalance(String userId) async {
    final user = await _userService.getUser(userId);
    if (user != null) {
      _userBalance = user.balance;
      notifyListeners();
    }
  }

  Future<void> fetchExchangeRates(String baseCurrency) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _exchangeRates = await _currencyService.getExchangeRates(baseCurrency);
    } catch (e) {
      _errorMessage = 'Failed to load exchange rates: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedTargetCurrency(String currency) {
    _selectedTargetCurrency = currency;
    notifyListeners();
  }

  double convertBalance(double amount, String targetCurrency) {
    if (_exchangeRates == null || !_exchangeRates!.rates.containsKey(targetCurrency)) {
      return 0.0; // Tidak dapat mengkonversi
    }
    // Asumsi saldo di Firestore adalah IDR, dan kita ingin mengkonversi dari IDR ke target
    // Jika baseCurrency dari API adalah IDR, maka langsung kalikan
    // Jika baseCurrency dari API adalah USD (misal), maka harus (amount / rate_IDR) * rate_target
    if (_exchangeRates!.baseCurrency == _selectedBaseCurrency) {
      return amount * _exchangeRates!.rates[targetCurrency]!;
    } else {
      // Implementasi konversi jika base API bukan mata uang dasar saldo
      // Ini akan lebih kompleks dan sebaiknya dihandle dengan cermat
      return 0.0; // Placeholder
    }
  }

  String convertTime(DateTime dateTime, String timezoneIdentifier) {
    return _currencyService.convertTimeToZone(dateTime, timezoneIdentifier);
  }
}