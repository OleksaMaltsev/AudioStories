import 'package:flutter/material.dart';

class ChangeChooseProvider extends ChangeNotifier {
  List<bool> chooses = [true, false];

  void changeChoose(int index) {
    for (int i = 0; i < chooses.length; i++) {
      chooses[i] = false;
    }
    chooses[index] = true;
    notifyListeners();
  }
}
