import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/providers/sellection_value_provider.dart';
import 'package:audio_stories/screens/selections/widgets/big_stories_box_selections.dart';
import 'package:audio_stories/screens/selections/widgets/custom_app_bar_selections.dart';
import 'package:audio_stories/screens/selections/widgets/dropdown_button_one_selection.dart';
import 'package:audio_stories/screens/selections/widgets/track_container_widget.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OneSelectionScreen extends StatefulWidget {
  const OneSelectionScreen({super.key});
  static const String routeName = '/one-selections';

  @override
  State<OneSelectionScreen> createState() => _OneSelectionScreenState();
}

class _OneSelectionScreenState extends State<OneSelectionScreen> {
  int maxLines = 3;
  Map<String, dynamic> dataTrack = {};
  Map<String, dynamic> dataSellection = {};
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
      list = dataTrack['tracks'];

      dataSellection = data;
    });
  }

  final dbConnect = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("sellections");

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (arg['docId'] == null) return SizedBox();
    getTrackSellection(arg['docId']);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: CustomPaint(
          painter: GreenPainter(),
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBarSelections(
                    name: '',
                    actions: DropdownButtonOneSellection(
                      fileDocId: arg['docId'],
                      data: arg,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Provider.of<SellectionValueProvider>(context).name ??
                              arg['name'],
                          style: mainTheme.textTheme.labelLarge?.copyWith(
                            color: ColorsApp.colorWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      BigStoriesBoxSelections(
                        imagePath: Provider.of<SellectionValueProvider>(context)
                                .photo ??
                            arg['photo'],
                        dateTime: arg['date'],
                        countTracks: arg['countTracks'],
                        duration: arg['duration'],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          Provider.of<SellectionValueProvider>(context)
                                  .description ??
                              arg['description'],
                          style: mainTheme.textTheme.labelSmall,
                          textAlign: TextAlign.left,
                          maxLines: maxLines,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (maxLines == 3) {
                            maxLines = 10;
                          } else {
                            maxLines = 3;
                          }
                          setState(() {});
                        },
                        child: Text(
                          'Детальніше',
                          style: mainTheme.textTheme.labelSmall?.copyWith(
                            color: ColorsApp.colorLightOpacityDark,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.37,
                            child: StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              stream: dbConnect.doc(arg['docId']).snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data?.data()?['tracks'] != null) {
                                  final List list =
                                      snapshot.data?.data()?['tracks'];

                                  return ListView.builder(
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      final file = list[index];
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

                                return const CircularProgressIndicator
                                    .adaptive();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
