import 'package:flutter/material.dart';

class SmsCodeProvider extends ChangeNotifier {
  TextEditingController? userPhone;
  void setSmsCode(TextEditingController number) {
    userPhone = number;
    notifyListeners();
  }
}
