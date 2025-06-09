import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static void showToast(String message, {ToastGravity gravity = ToastGravity.BOTTOM}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

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