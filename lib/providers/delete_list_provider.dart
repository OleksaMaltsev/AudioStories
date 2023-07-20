import 'package:flutter/material.dart';

class DeleteListProvider extends ChangeNotifier {
  List _deleteList = [];

  void removeItem(String value) {
    _deleteList.remove(value);
    notifyListeners();
  }

  void addItem(String value) {
    _deleteList.add(value);
    notifyListeners();
  }

  List getList() {
    return _deleteList;
  }
}
