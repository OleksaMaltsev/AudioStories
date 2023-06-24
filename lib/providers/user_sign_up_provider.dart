import 'package:flutter/material.dart';

class UserSignUpProvider extends ChangeNotifier {
  String userPhone = '';
  void changeUserPhone(String number) {
    userPhone = number;
    notifyListeners();
  }
}
