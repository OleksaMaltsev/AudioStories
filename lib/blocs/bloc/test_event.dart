part of 'test_bloc.dart';

@immutable
abstract class TestEvent {}

class StringEvent extends TestEvent {
  final String str;
  StringEvent(this.str);
}
