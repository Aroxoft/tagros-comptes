import 'package:flutter/services.dart';

class HalfDecimalInputFormatter extends TextInputFormatter {
  RegExp _exp;

  HalfDecimalInputFormatter() {
    String regex = r"^([0-9]+(\.[05]?)?)?$";
    _exp = RegExp(regex);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
