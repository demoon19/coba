import 'package:flutter/material.dart';
import 'package:dating/api/services/currency_service.dart';
import 'package:dating/api/models/currency_model.dart';
import 'package:dating/data/repositories/user_repository.dart';
import 'package:dating/core/providers/auth_provider.dart';
import 'package:dating/core/providers/user_provider.dart';
import 'package:dating/config/app_constants.dart';

class CurrencyConverterViewModel extends ChangeNotifier {
  final CurrencyService _currencyService;
  final UserRepository _userRepository;
  final AuthProvider _authProvider;
  final UserProvider? _userProvider;

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

  CurrencyConverterViewModel(
    this._currencyService,
    this._userRepository,
    this._authProvider, {
    UserProvider? userProvider,
  }) : _userProvider = userProvider {
    _authProvider.addListener(_onAuthChanged);
    _userProvider?.addListener(_onUserBalanceChanged);
    fetchExchangeRates(_selectedBaseCurrency);
  }

  void _onAuthChanged() {
    if (_authProvider.isAuthenticated) {
      if (_authProvider.currentUserId != null) {
        fetchUserBalance(_authProvider.currentUserId!);
      }
    } else {
      _userBalance = 0.0;
      notifyListeners();
    }
  }

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
    final rate = _exchangeRates?.rates[targetCurrency];
    if (rate == null) {
      _errorMessage = 'Exchange rate not available for $targetCurrency.';
      notifyListeners();
      return 0.0;
    }

    if (_selectedBaseCurrency == _exchangeRates!.baseCurrency) {
      return amount * rate;
    } else {
      final double amountInApiBase =
          amount / (_exchangeRates!.rates[_selectedBaseCurrency] ?? 1.0);
      return amountInApiBase * rate;
    }
  }

  String convertTime(DateTime dateTime, String timezoneIdentifier) {
    return _currencyService.convertTimeToZone(dateTime, timezoneIdentifier);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    _userProvider?.removeListener(_onUserBalanceChanged);
    super.dispose();
  }
}
