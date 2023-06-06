import 'package:flutter/material.dart';

// todo:  реализовать через блок
String userGlobal = '';

class UserSignUpProvider extends ChangeNotifier {
  final String userPhone;
  UserSignUpProvider({required this.userPhone});
}
