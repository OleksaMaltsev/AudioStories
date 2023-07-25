import 'package:flutter/material.dart';

class OneSellectionDataProvider extends ChangeNotifier {
  Map<String, dynamic>? data;
  String? id;
  void initValue({
    required Map<String, dynamic> data,
    required String id,
  }) {
    this.data = data;
    this.id = id;
  }
}
