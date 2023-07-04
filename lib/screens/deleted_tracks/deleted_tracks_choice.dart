import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/models/track_model.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/providers/choise_tracks_provider.dart';
import 'package:audio_stories/providers/track_menu_provider.dart';
import 'package:audio_stories/providers/track_path_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/audio/widgets/dropdown_button.dart';
import 'package:audio_stories/screens/audio_stories/widgets/dropdown_button_one_track.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/appBar/custom_app_bar.dart';
import 'package:audio_stories/widgets/background/background_blue_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class DeletedTracksChoiceScreen extends StatefulWidget {
  const DeletedTracksChoiceScreen({super.key});
  static const String routeName = '/deleted-tracks';

  @override
  State<DeletedTracksChoiceScreen> createState() =>
      _DeletedTracksChoiceScreenState();
}

class _DeletedTracksChoiceScreenState extends State<DeletedTracksChoiceScreen> {
  late Future<ListResult> futureFiles;
  List<Reference> listRef = [];

  AudioPlayer audioPlayer = AudioPlayer();
  Reference firebaseStorage = FirebaseStorage.instance.ref();
  String? filePath;
  int count = 0;

  String dateRef = '';

  List<String> list1 = [];

  Future<QuerySnapshot<Map<String, dynamic>>>? dataStream;

  late ListResult listResult;

  @override
  void initState() {
    super.initState();
    dataStream = FirebaseRepository().getAllTrack();
    // futureFiles =
    //     FirebaseStorage.instance.ref('/upload-voice-firebase/').list();
    // futureFiles.then((value) {
    //   listRef = value.items;
    // });
    // setState(() {});
    // print(listRef);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<String> getNameTrackForDb(String docID) async {
  //   String nameTrack = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection('tracks')
  //       .doc(docID)
  //       .get()
  //       .then(
  //     (DocumentSnapshot doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return data['trackName'];
  //     },
  //     onError: (e) => print("Error getting document: $e"),
  //   );
  //   print(nameTrack);
  //   return nameTrack;
  // }

  bool play = false;
  bool repeat = false;

  bool playTrack = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BluePainter(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Column(
            children: [
              CustomAppBar(
                contextScreen: context,
                leading: null,
                title: 'Нещодавно видалені',
                subTitle: null,
                actions: null,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.622,
                      child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: dataStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                final file = snapshot.data?.docs[index];
                                final fileDocId = snapshot.data?.docs[index].id;
                                //print(file!.data());
                                return DeletedTrackContainer(
                                  data: file!.data(),
                                  fileDocId: fileDocId!,
                                );
                              },
                            );
                          }

                          if (snapshot.hasError) {
                            return const Text("Something went wrong");
                          }

                          return const CircularProgressIndicator.adaptive();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeletedTrackContainer extends StatefulWidget {
  const DeletedTrackContainer({
    super.key,
    required this.data,
    required this.fileDocId,
  });

  final Map<String, dynamic> data;
  final String fileDocId;

  @override
  State<DeletedTrackContainer> createState() => _DeletedTrackContainerState();
}

class _DeletedTrackContainerState extends State<DeletedTrackContainer> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool playTrack = false;

  bool choose = false;

  ChangeNamePovider appValueNotifier = ChangeNamePovider();
  TrackMenuProvider trackNameNotifier = TrackMenuProvider();

  TextEditingController trackNameController = TextEditingController();
  final _validationKey = GlobalKey<FormState>();
  FocusNode trackFocus = FocusNode();
  String? trackDocId = '';

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

    getNameTrackForDb();
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

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      minutes,
      seconds,
    ].join(':');
  }

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
                if (!playTrack) {
                  audioPlayer.play(UrlSource(track?.url ?? ''));
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
                          track?.title ?? 'Track',
                          style: mainTheme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          formatTime(Duration(seconds: track!.time)),
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
            child: InkWell(
              onTap: () => setState(
                () {
                  choose = !choose;
                  final list =
                      Provider.of<ChoiseTrackProvider>(context, listen: false);

                  if (choose && !list.getList().contains(track!.url)) {
                    list.addToList(widget.fileDocId);
                    list.printList();
                  }
                  if (!choose) {
                    list.removeItem(widget.fileDocId);
                    list.printList();
                  }
                },
              ),
              child: Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(
                  right: 5,
                ),
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
            // InkWell(
            //   onTap: () {},
            //   child: SvgPicture.asset(
            //     AppIcons.delete,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
