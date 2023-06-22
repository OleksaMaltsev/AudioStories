part of 'track_list_bloc.dart';

@immutable
abstract class TrackListEvent {}

class TrackDonloadingEvent extends TrackListEvent {
  final int itemCount;

  TrackDonloadingEvent(this.itemCount);
}
