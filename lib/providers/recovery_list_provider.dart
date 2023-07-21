import 'package:flutter/material.dart';

class RecoveryListProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _recoveryList = [];

  void removeItem(Map<String, dynamic> value) {
    _recoveryList.remove(value);
    notifyListeners();
  }

  void addItem(Map<String, dynamic> value) {
    _recoveryList.add(value);
    notifyListeners();
  }

  List<Map<String, dynamic>> getList() {
    return _recoveryList;
  }
}
