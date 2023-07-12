import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/widgets/big_stories_box_selections.dart';
import 'package:audio_stories/screens/selections/widgets/custom_app_bar_selections.dart';
import 'package:audio_stories/screens/selections/widgets/dropdown_button_one_selection.dart';
import 'package:audio_stories/screens/selections/widgets/one_track.dart';
import 'package:audio_stories/screens/selections/widgets/track_container_widget.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OneSelectionScreen extends StatefulWidget {
  const OneSelectionScreen({super.key});
  static const String routeName = '/one-selections';

  @override
  State<OneSelectionScreen> createState() => _OneSelectionScreenState();
}

class _OneSelectionScreenState extends State<OneSelectionScreen> {
  Map<String, dynamic> dataTrack = {};
  List? list;
  void getTrackSellection(String docId) {
    final db = FirebaseFirestore.instance;
    Map<String, dynamic> data = {};
    final dataStream = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("sellections")
        .doc(docId)
        .get();
    dataStream.then((doc) {
      data = doc.data() as Map<String, dynamic>;
      dataTrack = data;
      print(dataTrack['tracks']);
      list = dataTrack['tracks'];
    });
  }

  final dbConnect = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("sellections");

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    getTrackSellection(arg['docId']);

    return Scaffold(
      body: CustomPaint(
        painter: GreenPainter(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
          width: double.infinity,
          child: Column(
            children: [
              const CustomAppBarSelections(
                name: '',
                actions: DropdownButtonOneSellection(),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      arg['name'],
                      style: mainTheme.textTheme.labelLarge?.copyWith(
                        color: ColorsApp.colorWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BigStoriesBoxSelections(
                    imagePath: arg['photo'],
                    dateTime: arg['date'],
                    countTracks: arg['countTracks'],
                    duration: arg['duration'],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      arg['description'],
                      style: mainTheme.textTheme.labelSmall,
                      textAlign: TextAlign.left,
                      maxLines: 3,
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: Text(
                  //     'Детальніше',
                  //     style: mainTheme.textTheme.labelSmall?.copyWith(
                  //       color: ColorsApp.colorLightOpacityDark,
                  //     ),
                  //   ),
                  // ),
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.37,
                        child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: dbConnect.doc(arg['docId']).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final List list =
                                  snapshot.data?.data()?['tracks'];
                              return ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  final file = list[index];
                                  print(list);
                                  return TrackGreenContainer(
                                    data: file,
                                    fileDocId: arg['docId'],
                                    choiceAction: null,
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
                      // Container(
                      //   height: MediaQuery.of(context).size.height * 0.378,
                      //   child: ListView.builder(
                      //     itemCount: list.length,
                      //     itemBuilder: (context, index) {
                      //       final Map<String, dynamic> file = list[index];
                      //       print(file);
                      //       return TrackGreenContainer(
                      //         data: file,
                      //         fileDocId: arg['docId'],
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
