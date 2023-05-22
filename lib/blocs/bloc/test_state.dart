// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'test_bloc.dart';

class TestState {
  final String strValue;
  TestState({
    this.strValue = 'Добірки',
  });

  TestState copyWith({
    String? strValue,
  }) {
    return TestState(
      strValue: strValue ?? this.strValue,
    );
  }
}
