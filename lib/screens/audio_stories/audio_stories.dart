import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/screens/audio_stories/widgets/dropdown_button_tracks.dart';
import 'package:audio_stories/screens/audio_stories/widgets/track_container.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/appBar/custom_app_bar.dart';
import 'package:audio_stories/widgets/background/background_blue_widget.dart';
import 'package:audio_stories/widgets/mini_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioStoriesScreen extends StatefulWidget {
  const AudioStoriesScreen({super.key});
  static const String routeName = '/audio-stories';

  @override
  State<AudioStoriesScreen> createState() => _AudioStoriesScreenState();
}

class _AudioStoriesScreenState extends State<AudioStoriesScreen> {
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
    //print(nameTrack);
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
                actions: DropdownButtonTracks(
                    // fileDocId: arg['docId'],
                    // data: arg,
                    ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 25, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1 аудіо',
                          style: mainTheme.textTheme.labelSmall?.copyWith(
                            color: ColorsApp.colorWhite,
                          ),
                        ),
                        Text(
                          '30 хвилин',
                          style: mainTheme.textTheme.labelSmall?.copyWith(
                            color: ColorsApp.colorWhite,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            repeat = !repeat;

                            setState(() {});
                          },
                          child: Container(
                            width: 200,
                            height: 46,
                            decoration: BoxDecoration(
                              color: repeat
                                  ? ColorsApp.colorOpacityWhite
                                  : ColorsApp.colorOpacityBlue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SvgPicture.asset(
                                  repeat
                                      ? AppIcons.fluentArrow
                                      : AppIcons.fluentArrowWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              play = !play;
                            });
                          },
                          child: Container(
                            width: 148,
                            height: 46,
                            padding: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: ColorsApp.colorWhite,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                !play
                                    ? SvgPicture.asset(
                                        AppIcons.play,
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: SvgPicture.asset(
                                          AppIcons.pause,
                                          width: 38,
                                          color: ColorsApp.colorPurple,
                                        ),
                                      ),
                                Text(
                                  'Запустити все',
                                  style:
                                      mainTheme.textTheme.labelSmall?.copyWith(
                                    color: ColorsApp.colorPurple,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                                final file = list[index];
                                final fileDocId = snapshot.data!.docs[index].id;

                                return TrackContainer(
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
