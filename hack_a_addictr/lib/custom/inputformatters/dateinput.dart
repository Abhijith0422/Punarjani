import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow only digits and dashes
    if (!RegExp(r'^\d{0,2}-?\d{0,2}-?\d{0,4}$').hasMatch(text)) {
      return oldValue;
    }

    // Automatically add dashes
    String newText = text;
    if (text.length == 2 || text.length == 5) {
      if (!text.endsWith('-')) {
        newText = '$text-';
      }
    }

    // Ensure the format is dd-MM-yyyy
    if (text.length > 10) {
      return oldValue;
    }

    // Ensure day and month are in their desired range
    final parts = newText.split('-');
    if (parts.length > 1) {
      final day = int.tryParse(parts[0]);
      if (day != null && (day < 1 || day > 31)) {
        return oldValue;
      }
      if (parts[0].length == 1) {
        parts[0] = '0${parts[0]}';
        newText = parts.join('-');
      }
    }
    if (parts.length > 2) {
      final month = int.tryParse(parts[1]);
      if (month != null && (month < 1 || month > 12)) {
        return oldValue;
      }
      if (parts[1].length == 1) {
        parts[1] = '0${parts[1]}';
        newText = parts.join('-');
      }
    }
    if (parts.length > 3) {
      final year = int.tryParse(parts[2]);
      final currentYear = DateTime.now().year;
      if (year != null && (year > currentYear || year < currentYear - 10)) {
        return oldValue;
      }
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
