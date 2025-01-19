import 'package:flutter/services.dart';

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.toUpperCase();

    // Allow only digits, colons, spaces, and AM/PM
    if (!RegExp(r'^\d{0,2}:?\d{0,2} ?[APM]{0,2}$').hasMatch(text)) {
      return oldValue;
    }

    // Automatically add colons
    String newText = text;
    if (text.length == 2 && !text.contains(':')) {
      newText = '$text:';
    }

    // Ensure the format is HH:mm AM/PM and valid 12-hour time
    if (text.length > 8) {
      return oldValue;
    }

    final parts = newText.split(':');
    if (parts.length > 0 && parts[0].isNotEmpty) {
      final hour = int.tryParse(parts[0]);
      if (hour == null || hour < 1 || hour > 12) {
        return oldValue;
      }
      if (parts[0].length == 1 && parts[0] != '0' && newText.length > 1) {
        parts[0] = '0${parts[0]}';
        newText = parts.join(':');
      }
    }
    if (parts.length > 1 && parts[1].isNotEmpty) {
      final minutePart = parts[1].split(' ')[0];
      final minute = int.tryParse(minutePart);
      if (minute == null || minute < 0 || minute > 59) {
        return oldValue;
      }
      if (minutePart.length == 1 && minutePart != '0' && newText.length > 4) {
        parts[1] = '0${minutePart}${parts[1].substring(minutePart.length)}';
        newText = parts.join(':');
      }
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
