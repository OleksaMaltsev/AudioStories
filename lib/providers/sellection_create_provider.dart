import 'package:audio_stories/models/sellection_model.dart';
import 'package:flutter/material.dart';

class SellesticonCreateProvider extends ChangeNotifier {
  SellectionModel sellectionModel =
      SellectionModel(name: null, description: null, photo: null, tracks: null);
  void setValues(String name, String? description, String photo) {
    sellectionModel.name = name;
    sellectionModel.description = description;
    sellectionModel.photo = photo;
  }

  void setTracks(List<Map<String, dynamic>> tracks) {
    sellectionModel.tracks = tracks;
  }
}
