import 'package:flutter/material.dart';
import 'package:dating/api/services/currency_service.dart'; // Perhatikan 'dating', bukan 'dating'
import 'package:dating/api/models/currency_model.dart'; // Perhatikan 'dating', bukan 'dating'
import 'package:dating/data/repositories/user_repository.dart'; // Menggunakan repository
import 'package:dating/core/providers/auth_provider.dart'; // Menggunakan provider
import 'package:dating/core/providers/user_provider.dart'; // Menggunakan provider
import 'package:dating/config/app_constants.dart'; // Menggunakan constants
import 'package:dating/core/utils/app_utils.dart'; // Menggunakan utilitas

class CurrencyConverterViewModel extends ChangeNotifier {
  // Hapus inisialisasi langsung karena akan diinjeksikan melalui konstruktor
  final CurrencyService _currencyService;
  final UserRepository _userRepository;
  final AuthProvider _authProvider;
  final UserProvider? _userProvider; // Opsional

  CurrencyExchangeRate? _exchangeRates;
  bool _isLoading = false;
  String? _errorMessage;
  double _userBalance = 0.0;
  final String _selectedBaseCurrency = 'IDR';
  String _selectedTargetCurrency = 'USD';

  CurrencyExchangeRate? get exchangeRates => _exchangeRates;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get userBalance => _userBalance;
  String get selectedBaseCurrency => _selectedBaseCurrency;
  String get selectedTargetCurrency => _selectedTargetCurrency;

  List<String> get availableCurrencies => AppConstants.supportedCurrencies;
  List<String> get availableTimezones => AppConstants.supportedTimezones;

  // Konstruktor yang diperbarui untuk menerima dependensi
  CurrencyConverterViewModel(
    this._currencyService,
    this._userRepository,
    this._authProvider, {
    UserProvider? userProvider, // Parameter bernama opsional
  }) : _userProvider = userProvider {
    // Tambahkan listener untuk AuthProvider dan UserProvider
    _authProvider.addListener(_onAuthChanged);
    _userProvider?.addListener(
      _onUserBalanceChanged,
    ); // Gunakan null-safe operator

    // Panggil fetch rates awal
    fetchExchangeRates(_selectedBaseCurrency);
  }

  // Listener untuk AuthProvider
  void _onAuthChanged() {
    if (_authProvider.isAuthenticated) {
      if (_authProvider.currentUserId != null) {
        fetchUserBalance(_authProvider.currentUserId!);
      }
    } else {
      _userBalance = 0.0; // Clear balance on logout
      notifyListeners();
    }
  }

  // Listener untuk UserProvider
  void _onUserBalanceChanged() {
    if (_userProvider?.currentUser != null) {
      _userBalance = _userProvider!.currentUser!.balance;
      notifyListeners();
    }
  }

  Future<void> fetchUserBalance(String userId) async {
    try {
      final user = await _userRepository.getUserById(userId);
      if (user != null) {
        _userBalance = user.balance;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user balance in CurrencyConverterViewModel: $e');
      _errorMessage = 'Failed to load balance.';
      notifyListeners();
    }
  }

  Future<void> fetchExchangeRates(String baseCurrency) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _exchangeRates = await _currencyService.getExchangeRates(baseCurrency);
      if (_exchangeRates == null) {
        _errorMessage = 'Failed to load exchange rates from API.';
      }
    } catch (e) {
      _errorMessage = 'Error fetching exchange rates: ${e.toString()}';
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
    if (_exchangeRates == null ||
        !_exchangeRates!.rates.containsKey(targetCurrency)) {
      AppUtils.showToast('Exchange rates not available for $targetCurrency.');
      return 0.0;
    }

    if (_selectedBaseCurrency == _exchangeRates!.baseCurrency) {
      return amount * _exchangeRates!.rates[targetCurrency]!;
    } else {
      // Implementasi konversi jika base API bukan mata uang dasar saldo
      final double amountInApiBase =
          amount / (_exchangeRates!.rates[_selectedBaseCurrency] ?? 1.0);
      return amountInApiBase * _exchangeRates!.rates[targetCurrency]!;
    }
  }

  String convertTime(DateTime dateTime, String timezoneIdentifier) {
    return _currencyService.convertTimeToZone(dateTime, timezoneIdentifier);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    _userProvider?.removeListener(
      _onUserBalanceChanged,
    ); // Hapus listener dengan null-safe
    super.dispose();
  }
}
