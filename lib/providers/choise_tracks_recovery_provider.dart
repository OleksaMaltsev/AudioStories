import 'package:audio_stories/models/track_and_sellection_id.dart';
import 'package:flutter/material.dart';

class ChoiseTrackRecoveryProvider extends ChangeNotifier {
  List<TrackAndSellectionId> _listTracks = [];
  void addToList(TrackAndSellectionId urlTrack) {
    _listTracks.add(urlTrack);
  }

  void clearList() {
    _listTracks.clear();
  }

  void removeItem(TrackAndSellectionId item) {
    for (int i = 0; i < _listTracks.length; i++) {
      final model = _listTracks[i] as TrackAndSellectionId;
      final modelItem = item as TrackAndSellectionId;
      if (model.idTrack == modelItem.idTrack) {
        _listTracks.removeAt(i);
      }
    }
  }

  void printList() async {
    print(await _listTracks);
  }

  List<TrackAndSellectionId> getList() {
    return _listTracks;
  }
}
