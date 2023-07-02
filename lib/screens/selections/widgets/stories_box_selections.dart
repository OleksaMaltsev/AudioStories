import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/models/sellection_model.dart';
import 'package:audio_stories/screens/selections/one_selection.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
                image: NetworkImage(sellection.photo!),
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
                    sellection.name!,
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
