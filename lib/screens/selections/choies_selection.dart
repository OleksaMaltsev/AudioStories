import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/choise_tracks_provider.dart';
import 'package:audio_stories/providers/sellection_create_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/selection.dart';
import 'package:audio_stories/screens/selections/widgets/track_container_widget.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ChoiceSelectionScreen extends StatefulWidget {
  const ChoiceSelectionScreen({super.key});
  static const String routeName = '/choice-selections';

  @override
  State<ChoiceSelectionScreen> createState() => _ChoiceSelectionScreenState();
}

class _ChoiceSelectionScreenState extends State<ChoiceSelectionScreen> {
  bool choose = false;
  bool playTrack = true;

  Future<QuerySnapshot<Map<String, dynamic>>>? dataStream;
  late Future<ListResult> futureFiles;
  List<Reference> listRef = [];

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

  Future<Map<String, dynamic>> getNameTrackForDb(String docId) async {
    Map<String, dynamic> nameTrack = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tracks')
        .doc(docId)
        .get()
        .then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'trackName': data['trackName'],
          'url': data['url'],
          'duration': data['duration'],
          'id': data['id']
        };
      },
      onError: (e) => print("Error getting document: $e"),
    );
    print(nameTrack);
    return nameTrack;
  }

  Future<List<Map<String, dynamic>>> setTracksInSellection(
      List listWithDocId) async {
    List<Map<String, dynamic>> listMap = [];
    for (String value in listWithDocId) {
      listMap.add(await getNameTrackForDb(value));
    }
    return listMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: GreenPainter(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 50, 15, 10),
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(
                        context,
                        (route) => false,
                      );
                    },
                    child: SvgPicture.asset(AppIcons.back),
                  ),
                  Text(
                    'Вибрати',
                    style: mainTheme.textTheme.titleMedium,
                  ),
                  InkWell(
                    onTap: () async {
                      final list = Provider.of<ChoiseTrackProvider>(context,
                          listen: false);
                      final sellection = Provider.of<SellesticonCreateProvider>(
                          context,
                          listen: false);
                      if (list.getList().isNotEmpty) {
                        final listMapsTracks =
                            await setTracksInSellection(list.getList());
                        FirebaseRepository().saveSellection(
                          sellection.sellectionModel.photo!,
                          sellection.sellectionModel.name!,
                          sellection.sellectionModel.description,
                          listMapsTracks,
                        );
                      } else {
                        FirebaseRepository().saveSellection(
                          sellection.sellectionModel.photo!,
                          sellection.sellectionModel.name!,
                          sellection.sellectionModel.description,
                          null,
                        );
                      }
                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(context,
                            SelectionsScreen.routeName, (route) => false);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text(
                        'Додати',
                        style: mainTheme.textTheme.labelMedium?.copyWith(
                          color: ColorsApp.colorWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 25, 0),
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
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Container(
                      height: 400,
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
                                print(file!.data());
                                return TrackGreenContainer(
                                  data: file.data(),
                                  fileDocId: fileDocId!,
                                  choiceAction: 2,
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
