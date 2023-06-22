import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'track_list_event.dart';
part 'track_list_state.dart';

class TrackListBloc extends Bloc<TrackListEvent, TrackListState> {
  TrackListBloc() : super(TrackDataState()) {
    on<TrackListEvent>((event, emit) {});
  }
}
