import 'package:flutter/material.dart';

class TrackPathProvider extends ChangeNotifier {
  String? path;
  void setPath(String pathTrack) {
    path = pathTrack;
    notifyListeners();
  }
}
