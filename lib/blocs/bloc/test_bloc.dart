import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestState()) {
    on<TestEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<StringEvent>((event, emit) {
      // TODO: implement event handler
      String myStr = event.str;
      print(myStr);
      myStr = 'seg';
      emit(state.copyWith(strValue: myStr));
    });
  }
}
