import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk FilteringTextInputFormatter

class CurrencyInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const CurrencyInputField({
    super.key,
    required this.controller,
    this.labelText = 'Amount',
    this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), // Hanya angka dan 2 desimal
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}