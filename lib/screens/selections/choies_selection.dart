import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/helpers/audio_helper.dart';
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

  late Future<ListResult> futureFiles;
  List<Reference> listRef = [];

  @override
  void initState() {
    super.initState();
    futureFiles =
        FirebaseStorage.instance.ref('/upload-voice-firebase/').list();
    futureFiles.then((value) {
      listRef = value.items;
    });
    setState(() {});
  }

  TextEditingController _searchController = TextEditingController();
  CollectionReference allNoteCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("tracks");
  List<DocumentSnapshot> documents = [];

  String searchText = '';

  final dbConnect = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("tracks")
      .snapshots();
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
                            await AudioHelper.setTracksInSellection(
                                list.getList());
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
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
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
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream:
                            dbConnect, //FirebaseRepository().getTrackSnapshot(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            documents = snapshot.data!.docs;
                          }
                          if (searchText.length > 0) {
                            documents = documents.where((element) {
                              return element
                                  .get('trackName')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase());
                            }).toList();
                          }

                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                print(documents[index].data());
                                print('ddd');
                                final file = documents[index];
                                final fileDocId = documents[index].id;
                                return TrackGreenContainer(
                                  data: (file.data() as Map<String, dynamic>),
                                  fileDocId: fileDocId,
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
