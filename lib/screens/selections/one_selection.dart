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
import 'package:flutter/material.dart';

class OneSelectionScreen extends StatefulWidget {
  const OneSelectionScreen({super.key});
  static const String routeName = '/one-selections';

  @override
  State<OneSelectionScreen> createState() => _OneSelectionScreenState();
}

class _OneSelectionScreenState extends State<OneSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
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
                actions: DropdownButtonOneSelection(
                  colorIcon: ColorsApp.colorWhite,
                ),
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
                  TextButton(
                    onPressed: () {},
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
                        height: MediaQuery.of(context).size.height * 0.32,
                        child:
                            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          future: FirebaseRepository().getAllTrack(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return ListView.builder(
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  final file = snapshot.data?.docs[index];
                                  final fileDocId =
                                      snapshot.data?.docs[index].id;
                                  print(file!.data());
                                  return TrackGreenContainer(
                                    data: file.data(),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
