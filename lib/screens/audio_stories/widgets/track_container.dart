import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/helpers/audio_helper.dart';
import 'package:audio_stories/models/track_model.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/providers/track_menu_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/audio_stories/widgets/dropdown_button_one_track.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/mini_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrackContainer extends StatefulWidget {
  const TrackContainer({
    super.key,
    required this.data,
    required this.fileDocId,
  });

  final Map<String, dynamic> data;
  final String fileDocId;

  @override
  State<TrackContainer> createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool playTrack = false;

  ChangeNamePovider appValueNotifier = ChangeNamePovider();
  TrackMenuProvider trackNameNotifier = TrackMenuProvider();

  TextEditingController trackNameController = TextEditingController();
  final _validationKey = GlobalKey<FormState>();
  FocusNode trackFocus = FocusNode();
  String? trackDocId = '';

  @override
  void initState() {
    super.initState();
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
                if (!playTrack) {
                  audioPlayer.play(UrlSource(widget.data['url']));
                  playTrack = true;
                } else {
                  audioPlayer.pause();
                  playTrack = false;
                }

                setState(() {});
              },
              child: SvgPicture.asset(
                playTrack ? AppIcons.pause50 : AppIcons.play50,
                color: ColorsApp.colorBlue,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ValueListenableBuilder(
                valueListenable: appValueNotifier.valueNotifier,
                builder: (context, value, child) {
                  if (value == 1) {
                    return Form(
                      key: _validationKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 160,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                              cursorHeight: 25,
                              cursorColor: ColorsApp.colorLightOpacityDark,
                              controller: trackNameController,
                              textAlign: TextAlign.center,
                              focusNode: trackFocus,
                              decoration: InputDecoration(
                                hintText: 'Введіть назву',
                                hintStyle: mainTheme.textTheme.bodyMedium,
                                focusColor: ColorsApp.colorLightDark,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: ColorsApp.colorLightOpacityDark),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3,
                                      color: ColorsApp.colorLightDark),
                                ),
                                errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: ColorsApp.colorLightRed),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data['trackName'],
                          // track?.title ?? 'Track',
                          style: mainTheme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          AudioHelper.formatTime(
                              duration:
                                  Duration(seconds: widget.data['duration'])),
                          style: mainTheme.textTheme.labelSmall,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ValueListenableBuilder(
              valueListenable: appValueNotifier.valueNotifier,
              builder: (context, value, child) {
                if (value == 1) {
                  return InkWell(
                    onTap: () async {
                      if (trackNameController.text.isNotEmpty) {
                        // await FirebaseRepository()
                        //     .setNewTrackName(trackNameController.text);
                        FirebaseRepository().setNewTrackName(
                            trackNameController.text, widget.data['url']);
                        appValueNotifier.changeWidgetNotifier(0);
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
                } else {
                  return DropdownButtonOneTrackMenu(
                    pathTrack: widget.data['url'],
                    providerName: appValueNotifier,
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
