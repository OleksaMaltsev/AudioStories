import 'package:audio_stories/models/track_and_sellection_id.dart';
import 'package:flutter/material.dart';

class ChoiseTrackProvider<T> extends ChangeNotifier {
  List<T> _listTracks = [];
  void addToList(T urlTrack) {
    _listTracks.add(urlTrack);
  }

  void clearList() {
    _listTracks.clear();
  }

  void removeItem(T item) {
    if (item is TrackAndSellectionId) {
      for (int i = 0; i < _listTracks.length; i++) {
        final model = _listTracks[i] as TrackAndSellectionId;
        final modelItem = item as TrackAndSellectionId;
        if (model.idTrack == modelItem.idTrack) {
          _listTracks.removeAt(i);
        }
      }
    } else {
      _listTracks.remove(item);
    }
  }

  void printList() async {
    print(await _listTracks);
  }

  List<TrackAndSellectionId> getModalList() {
    return _listTracks as List<TrackAndSellectionId>;
  }

  List<T> getList() {
    return _listTracks;
  }
}
