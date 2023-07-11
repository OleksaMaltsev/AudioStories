import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/helpers/audio_helper.dart';
import 'package:audio_stories/models/track_model.dart';
import 'package:audio_stories/providers/change_name_track.dart';
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

class SearchTrackScreen extends StatefulWidget {
  const SearchTrackScreen({super.key});
  static const String routeName = '/search';

  @override
  State<SearchTrackScreen> createState() => _SearchTrackScreenState();
}

class _SearchTrackScreenState extends State<SearchTrackScreen> {
  late Future<ListResult> futureFiles;
  List<Reference> listRef = [];

  AudioPlayer audioPlayer = AudioPlayer();
  Reference firebaseStorage = FirebaseStorage.instance.ref();
  String? filePath;
  int count = 0;

  String dateRef = '';

  List<String> list1 = [];

  Future<QuerySnapshot<Map<String, dynamic>>>? dataStream;
  final dbConnect = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("tracks")
      .snapshots();

  void getAllTrack() {
    final db = FirebaseFirestore.instance;
    dataStream = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tracks")
        .get();
    // .asStream();

    //     .then(
    //   (querySnapshot) {
    //     dataSnap = querySnapshot.docs;
    //     print("Successfully completed");
    //     for (var docSnapshot in querySnapshot.docs) {
    //       print('${docSnapshot.id} => ${docSnapshot.data()}');
    //     }
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );
  }

  void _getPath(String path) async {
    setState(() {});
  }

  late ListResult listResult;

  @override
  void initState() {
    super.initState();
    getAllTrack();
    futureFiles =
        FirebaseStorage.instance.ref('/upload-voice-firebase/').list();
    futureFiles.then((value) {
      listRef = value.items;
    });
    setState(() {});
    print(listRef);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getNameTrackForDb(String docID) async {
    String nameTrack = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tracks')
        .doc(docID)
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
                title: 'Аудіозаписи',
                subTitle: 'Все в одному місці',
                actions: null,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 25, 0),
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: BoxDecoration(
                  color: ColorsApp.colorOriginalWhite,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Пошук',
                    hintStyle: mainTheme.textTheme.labelMedium?.copyWith(
                      fontSize: 20,
                      color: ColorsApp.colorLightOpacityDark,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: SvgPicture.asset(
                      AppIcons.search,
                      width: 30,
                    ),
                    suffixIconConstraints: BoxConstraints.tight(
                      const Size(30, 30),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: dbConnect,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final list = snapshot.data!.docs;
                                final file = list![index];
                                final fileDocId = snapshot.data!.docs[index].id;
                                print(file!.data());
                                print(index);
                                return // Text('${file!.data().toString()} \n');
                                    TrackContainer(
                                  data: file.data(),
                                  fileDocId: fileDocId,
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

  Track? track;
  @override
  void initState() {
    super.initState();
    track = Track(
      title: widget.data['trackName'],
      url: widget.data['url'],
      time: widget.data['duration'],
    );
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
                            trackNameController.text, track!.url);
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
