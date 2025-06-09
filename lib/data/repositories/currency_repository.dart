import 'package:dating/api/models/currency_model.dart';
import 'package:dating/api/services/currency_service.dart';

class CurrencyRepository {
  final CurrencyService _currencyService;

  // Konstruktornya mengharapkan 1 argumen opsional: CurrencyService
  CurrencyRepository({CurrencyService? currencyService})
    : _currencyService = currencyService ?? CurrencyService();

  Future<CurrencyExchangeRate?> getExchangeRates(String baseCurrency) async {
    return await _currencyService.getExchangeRates(baseCurrency);
  }
}
