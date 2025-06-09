import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static String formatCurrency(double amount, {String symbol = 'Rp'}) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: symbol, decimalDigits: 2);
    return formatCurrency.format(amount);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  // Anda bisa menambahkan fungsi lain seperti validasi email sederhana (jika tidak di validator_utils),
  // fungsi untuk resize gambar, dll.
}
