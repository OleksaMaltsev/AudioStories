import 'package:flutter/material.dart';

class ChangeNamePovider extends ChangeNotifier {
  ValueNotifier valueNotifier = ValueNotifier(0);
  void changeWidgetNotifier(int newValue) {
    valueNotifier.value = newValue;
    notifyListeners();
  }
}

// class ChangeNamePovider extends ChangeNotifier {
//   ValueNotifier valueNotifier = ValueNotifier(false);
//   void changeWidgetNotifier() {
//     valueNotifier.value = !valueNotifier.value;
//     notifyListeners();
//   }
// }

