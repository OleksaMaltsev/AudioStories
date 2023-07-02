import 'package:flutter/material.dart';

class ChoiseTrackProvider extends ChangeNotifier {
  List<String> _listTracks = [];
  void addToList(String urlTrack) {
    _listTracks.add(urlTrack);
  }

  void clearList() {
    _listTracks.clear();
  }

  void printList() {
    print(_listTracks);
  }

  List<String> getList() {
    return _listTracks;
  }
}
