import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/providers/one_sellection_data_provider.dart';
import 'package:audio_stories/providers/sellection_value_provider.dart';
import 'package:audio_stories/screens/selections/widgets/big_stories_box_selections.dart';
import 'package:audio_stories/screens/selections/widgets/custom_app_bar_selections.dart';
import 'package:audio_stories/screens/selections/widgets/dropdown_button_one_selection_choice.dart';
import 'package:audio_stories/screens/selections/widgets/track_container_widget.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TracksChoiceScreen extends StatefulWidget {
  const TracksChoiceScreen({super.key});
  static const String routeName = '/tracks-choice';

  @override
  State<TracksChoiceScreen> createState() => _TracksChoiceScreenState();
}

class _TracksChoiceScreenState extends State<TracksChoiceScreen> {
  Map<String, dynamic>? allData;
  String? docsId;
  List<dynamic>? listTracks = [];
  int duration = 0;

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

  @override
  void initState() {
    super.initState();
    allData =
        Provider.of<OneSellectionDataProvider>(context, listen: false).data;
    docsId = Provider.of<OneSellectionDataProvider>(context, listen: false).id;
    listTracks = allData?['tracks'];
    listTracks?.map((e) {
      final num n = e['duration'];
      duration += n.toInt();
    });
    print(allData);
    print(docsId);
    print('fr');
  }

  final dbConnect = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("sellections");

  @override
  Widget build(BuildContext context) {
    // final arg =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // if (arg['docId'] == null) return SizedBox();
    // getTrackSellection(arg['docId']);
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
                    actions: DropdownButtonOneSellectionChoice(
                      fileDocId: docsId!,
                      data: allData,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Provider.of<SellectionValueProvider>(context).name ??
                              allData?['sellectionName'],
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
                            allData?['photo'],
                        dateTime: (allData?['date'] as Timestamp).toDate(),
                        countTracks: listTracks?.length,
                        duration: duration.toString(),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.37,
                            child: StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              stream: dbConnect.doc(docsId).snapshots(),
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
                                        fileDocId: docsId!,
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
