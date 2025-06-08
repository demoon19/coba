import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating/features/currency_converter/viewmodels/currency_converter_viewmodel.dart';
import 'package:dating/core/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  String? _selectedTimezone;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUserId != null) {
        Provider.of<CurrencyConverterViewModel>(
          context,
          listen: false,
        ).fetchUserBalance(authProvider.currentUserId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency & Time Converter')),
      body: Consumer<CurrencyConverterViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Current Balance',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp ${viewModel.userBalance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Convert To:',
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButton<String>(
                          value: viewModel.selectedTargetCurrency,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              viewModel.setSelectedTargetCurrency(newValue);
                            }
                          },
                          items: viewModel.availableCurrencies
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Equivalent in ${viewModel.selectedTargetCurrency}: '
                          '${viewModel.selectedTargetCurrency} ${viewModel.convertBalance(viewModel.userBalance, viewModel.selectedTargetCurrency).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Time Converter',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Current Local Time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Convert Current Time To:',
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButton<String>(
                          value: _selectedTimezone,
                          hint: const Text('Select Timezone'),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTimezone = newValue;
                            });
                          },
                          items: viewModel.availableTimezones
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        if (_selectedTimezone != null)
                          Text(
                            'Time in $_selectedTimezone: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(viewModel.convertTime(DateTime.now(), _selectedTimezone!)))}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
