import 'package:audio_stories/screens/deleted_tracks/widget/deleted_track_container.dart';
import 'package:audio_stories/screens/deleted_tracks/widget/dropdown_button_one_track.dart';
import 'package:audio_stories/widgets/appBar/custom_app_bar.dart';
import 'package:audio_stories/widgets/background/background_blue_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeletedTracksScreen extends StatefulWidget {
  const DeletedTracksScreen({super.key});
  static const String routeName = '/deleted-tracks';

  @override
  State<DeletedTracksScreen> createState() => _DeletedTracksScreenState();
}

class _DeletedTracksScreenState extends State<DeletedTracksScreen> {
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
      .collection("delete")
      .snapshots();

  @override
  void initState() {
    super.initState();
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
    return nameTrack;
  }

  bool play = false;
  bool repeat = false;

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
                actions: const DropdownDeleteMenu(
                  items: [
                    'Вибрати декілька',
                    'Видалити все',
                    'Відновити все',
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: Column(
                  children: [
                    Container(
                      height: 556.h,
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: dbConnect,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                final file = snapshot.data?.docs[index];
                                final data = file!.data();
                                final List listKeys = data.keys.toList();
                                final String sellectId =
                                    snapshot.data!.docs[index].id;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      Text(sellectId),
                                      const SizedBox(height: 10),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemCount: listKeys.length,
                                        itemBuilder: ((context, index) {
                                          //print(listKeys[index]);
                                          return DeletedTrackContainer(
                                            data: data[listKeys[index]],
                                            fileDocId: sellectId,
                                            trackId: listKeys[index],
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
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
