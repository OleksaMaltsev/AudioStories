import 'package:flutter/foundation.dart';

class AllowToDeleteProvider extends ChangeNotifier {
  bool choiceDelete = false;
  void setChoice(bool choice) {
    choiceDelete = choice;
    notifyListeners();
  }
}
