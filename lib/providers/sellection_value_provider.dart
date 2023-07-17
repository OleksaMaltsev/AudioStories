import 'package:flutter/material.dart';

class SellectionValueProvider extends ChangeNotifier {
  String? name;
  String? description;
  String? photo;
  // String? docId;
  // DateTime? dateTime;
  // int? countTracks;
  // int? allDuration;
  // List<Map<String, dynamic>>? tracks;

  void setValues({
    required String? name,
    required String? description,
    required String? photo,
  }) {
    this.name = name;
    this.description = description;
    this.photo = photo;
    notifyListeners();
  }
}
