import 'package:cloud_firestore/cloud_firestore.dart';

class BigTrackModel {
  int duration;
  String path;
  String name;
  String storagePath;
  String id;
  Timestamp dateTime;

  BigTrackModel({
    required this.duration,
    required this.path,
    required this.name,
    required this.storagePath,
    required this.id,
    required this.dateTime,
  });
}
