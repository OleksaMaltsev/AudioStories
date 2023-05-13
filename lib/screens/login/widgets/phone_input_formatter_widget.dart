import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d+]+'), '');
    final digitOnlyChars = digitsOnly.split('');
    List<String> newString = [];
    for (int i = 0; i < digitOnlyChars.length; i++) {
      if (i == 3 || i == 6 || i == 9 || i == 11) {
        newString.add(' ');
        newString.add(digitOnlyChars[i]);
      } else if (i >= 13) {
      } else {
        newString.add(digitOnlyChars[i]);
      }
    }
    String resultString = newString.join('');
    return TextEditingValue(
      text: resultString,
      selection: TextSelection.collapsed(offset: resultString.length),
    );
  }
}
