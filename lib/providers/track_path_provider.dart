import 'package:flutter/material.dart';

class TrackPathProvider extends ChangeNotifier {
  String? path;
  String? name;
  void setPath(String pathTrack) {
    path = pathTrack;
    notifyListeners();
  }

  void setName(String newName) {
    name = newName;
    notifyListeners();
  }
}
