import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/helpers/audio_helper.dart';
import 'package:audio_stories/models/track_model.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/providers/choise_tracks_provider.dart';
import 'package:audio_stories/providers/track_menu_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/audio_stories/widgets/dropdown_button_one_track.dart';
import 'package:audio_stories/screens/selections/widgets/dropdown_button_track_selection.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

//ChangeNameGreenPovider gappValueNotifier = ChangeNameGreenPovider();

class TrackGreenContainer extends StatefulWidget {
  const TrackGreenContainer({
    super.key,
    required this.data,
    required this.fileDocId,
    required this.choiceAction,
  });

  final Map<String, dynamic> data;
  final String fileDocId;
  final int? choiceAction;

  @override
  State<TrackGreenContainer> createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackGreenContainer> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool playTrack = false;
  bool choose = false;

  //ChangeNameGreenPovider appValueNotifier = ChangeNameGreenPovider();
  TrackMenuProvider trackNameNotifier = TrackMenuProvider();

  TextEditingController trackNameController = TextEditingController();
  final _validationKey = GlobalKey<FormState>();
  FocusNode trackFocus = FocusNode();
  String? trackDocId = '';

  List<String> listTracks = [];

  Track? track;
  @override
  void initState() {
    final duration = widget.data['duration'];

    setState(() {});

    super.initState();
    track = Track(
      title: widget.data['trackName'],
      url: widget.data['url'],
      time: widget.data['duration'],
    );

    if (widget.choiceAction != null) {
      gappChangeProvider.changeWidgetNotifier(2);
    }
    // getNameTrackForDb();
  }

  // delete
  Future<String> getNameTrackForDb() async {
    String nameTrack = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tracks')
        .doc(widget.fileDocId)
        .get()
        .then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['trackName'];
      },
      onError: (e) => print("Error getting document: $e"),
    );
    print(nameTrack);
    return nameTrack;
  }

  // String formatTime(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   final minutes = twoDigits(duration.inMinutes.remainder(60));
  //   final seconds = twoDigits(duration.inSeconds.remainder(60));

  //   return [
  //     minutes,
  //     seconds,
  //   ].join(':');
  // }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: ColorsApp.colorSlimOpacityDark,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                audioPlayer.play(UrlSource(widget.data['url']));

                //audioPlayer.stop();

                playTrack = !playTrack;
              },
              child: SvgPicture.asset(
                playTrack ? AppIcons.pause50 : AppIcons.play50,
                color: ColorsApp.colorLightGreen,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data['trackName'],
                    //track?.title ?? 'Track',
                    style: mainTheme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    AudioHelper.formatTime(
                        duration: Duration(seconds: track!.time)),
                    style: mainTheme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ValueListenableBuilder(
              valueListenable: gappChangeProvider.valueNotifier,
              builder: (context, value, child) {
                if (value == 1) {
                  return InkWell(
                    onTap: () async {
                      if (trackNameController.text.isNotEmpty) {
                        // await FirebaseRepository()
                        //     .setNewTrackName(trackNameController.text);
                        FirebaseRepository().setNewTrackName(
                            trackNameController.text, widget.data['url']);
                        gappChangeProvider.changeWidgetNotifier(0);
                      } else {
                        final snackBar = SnackBar(
                          content: Text(
                            'Введіть назву трека',
                            style: mainTheme.textTheme.labelLarge?.copyWith(
                              color: ColorsApp.colorWhite,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: (ColorsApp.colorLightOpacityDark),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: ColorsApp.colorPurple,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          'ОК',
                          style: mainTheme.textTheme.labelMedium,
                        ),
                      ),
                    ),
                  );
                } else if (value == 2) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: InkWell(
                      onTap: () => setState(() {
                        final list = Provider.of<ChoiseTrackProvider>(context,
                            listen: false);
                        choose = !choose;
                        if (choose && !list.getList().contains(track!.url)) {
                          //list.addToList(widget.fileDocId);
                          list.addToList(widget.data['id']);

                          list.printList();
                        }
                        if (!choose) {
                          list.removeItem(widget.fileDocId);
                          list.printList();
                        }
                        print(list);
                      }),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 2,
                            color: ColorsApp.colorLightDark,
                          ),
                        ),
                        child: choose
                            ? SvgPicture.asset(AppIcons.tickSquare)
                            : const SizedBox(),
                      ),
                    ),
                  );
                } else {
                  return DropdownButtonOneTrackMenuSellection(
                    pathTrack: widget.data['url'],
                    providerName: gappChangeProvider,
                    trackData: widget.data,
                    fileDocId: widget.fileDocId,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
