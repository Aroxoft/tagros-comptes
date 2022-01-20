import 'package:flutter/services.dart';

class HalfDecimalInputFormatter extends TextInputFormatter {
  RegExp _exp;

  HalfDecimalInputFormatter() : _exp = RegExp(r"^([0-9]+(\.[05]?)?)?$");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
