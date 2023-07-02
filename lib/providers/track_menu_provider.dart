import 'package:flutter/material.dart';

class TrackMenuProvider extends ChangeNotifier {
  ValueNotifier value = ValueNotifier(false);
  String? itemMenu;
  void choiceItem(String item) {
    itemMenu = item;
    switch (itemMenu) {
      case 'Перейменувати':
        value.value = true;
        break;
    }
    notifyListeners();
  }

  void nameChanged() {
    value.value = false;
    notifyListeners();
  }
}
