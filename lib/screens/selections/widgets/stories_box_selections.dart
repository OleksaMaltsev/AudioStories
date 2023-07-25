import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/models/sellection_model.dart';
import 'package:audio_stories/providers/one_sellection_data_provider.dart';
import 'package:audio_stories/providers/sellection_value_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/one_selection.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoriesBoxSelections extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;
  const StoriesBoxSelections({
    required this.data,
    required this.docId,
    super.key,
  });

  @override
  State<StoriesBoxSelections> createState() => _StoriesBoxSelectionsState();
}

class OneSellectionModel {
  final Map<String, dynamic> data;
  final String docId;
  OneSellectionModel({
    required this.data,
    required this.docId,
  });
}

class _StoriesBoxSelectionsState extends State<StoriesBoxSelections> {
  late SellectionModel sellection;
  late OneSellectionModel oneSellectionModel;
  late DateTime dateTime;
  int? countTracks;
  String? allDuration;
  Map<String, dynamic> dataTrack = {};
  Map<String, dynamic> dataSellection = {};
  List? list;
  @override
  void initState() {
    super.initState();
    final db = FirebaseFirestore.instance;
    Map<String, dynamic> data = {};
    final dataStream = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("sellections")
        .doc(widget.docId)
        .get();
    dataStream.then((doc) {
      data = doc.data() as Map<String, dynamic>;
      dataTrack = data;
      list = dataTrack['tracks'];

      dataSellection = data;
      print(dataSellection['sellectionName']);
    });

    sellection = SellectionModel(
        name: widget.data['sellectionName'],
        description: widget.data['description'],
        photo: widget.data['photo'],
        tracks: null);

    oneSellectionModel =
        OneSellectionModel(data: widget.data, docId: widget.docId);
    dateTime = (widget.data['date'] as Timestamp).toDate();

    final listTracks = widget.data['tracks'] as List?;
    countTracks = listTracks?.length;
    if (listTracks != null) {
      int sumDuration = 0;
      for (final value in listTracks) {
        sumDuration += value['duration'] as int;
      }
      allDuration = formatTime(Duration(seconds: sumDuration));
    }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  void getTrackSellection() {
    final db = FirebaseFirestore.instance;
    Map<String, dynamic> data = {};
    final dataStream = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("sellections")
        .doc(widget.docId)
        .get();
    dataStream.then((doc) {
      data = doc.data() as Map<String, dynamic>;
      dataTrack = data;
      list = dataTrack['tracks'];

      dataSellection = data;
      print(dataSellection['sellectionName']);
    });
  }

  @override
  Widget build(BuildContext context) {
    getTrackSellection();
    return InkWell(
      onTap: () {
        Provider.of<OneSellectionDataProvider>(
          context,
          listen: false,
        ).initValue(
          data: widget.data,
          id: widget.docId,
        );
        Navigator.pushNamed(
          context,
          OneSelectionScreen.routeName,
          arguments: {
            'name': widget.data['sellectionName'],
            'description': widget.data['description'],
            'photo': widget.data['photo'],
            'docId': widget.docId,
            'date': dateTime,
            'countTracks': countTracks,
            'duration': allDuration,
            'tracks': widget.data['tracks'],
          },
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(13),
              image: DecorationImage(
                image: NetworkImage(widget.data['photo']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.1,
                  0.6,
                ],
                colors: [
                  Color.fromARGB(50, 0, 0, 0),
                  Color.fromARGB(140, 45, 45, 45),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 60,
                  child: AutoSizeText(
                    widget.data['sellectionName'],
                    style: mainTheme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorsApp.colorWhite,
                    ),
                    maxLines: 5,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${countTracks ?? 0} аудіо',
                      style: mainTheme.textTheme.labelMedium?.copyWith(
                        color: ColorsApp.colorWhite,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      allDuration ?? '00:00',
                      style: mainTheme.textTheme.labelMedium?.copyWith(
                        color: ColorsApp.colorWhite,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
