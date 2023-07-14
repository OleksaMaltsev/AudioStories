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

class EditSelectionScreen extends StatefulWidget {
  const EditSelectionScreen({super.key});
  static const String routeName = '/edit-selections';

  @override
  State<EditSelectionScreen> createState() => _EditSelectionScreenState();
}

class _EditSelectionScreenState extends State<EditSelectionScreen> {
  String description = '';
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic> ??
            {};
    description = arg['description'];
    print(description.length);
    return Scaffold(
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
                    fileDocId: '',
                    data: arg,
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
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        controller: descriptionController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: description,
                          border: InputBorder.none,
                        ),
                        style: mainTheme.textTheme.labelSmall,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.312,
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseRepository()
                            .dbConnectSellection
                            .doc(arg['docId'])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data?.data()?['tracks'] != null) {
                            final List list = snapshot.data?.data()?['tracks'];

                            return ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final file = list[index];
                                return Opacity(
                                  opacity: 0.5,
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: TrackGreenContainer(
                                      data: file,
                                      fileDocId: arg['docId'],
                                      choiceAction: null,
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
