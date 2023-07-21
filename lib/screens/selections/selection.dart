import 'package:audio_stories/providers/choise_tracks_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/choies_selection.dart';
import 'package:audio_stories/screens/selections/widgets/custom_selections_app_bar.dart';
import 'package:audio_stories/screens/selections/widgets/dropdown_button_selection.dart';
import 'package:audio_stories/screens/selections/widgets/stories_box_selections.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectionsScreen extends StatefulWidget {
  const SelectionsScreen({super.key});
  static const String routeName = '/selections';

  @override
  State<SelectionsScreen> createState() => _SelectionsScreenState();
}

class _SelectionsScreenState extends State<SelectionsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ChoiseTrackProvider>(context, listen: false).clearList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: CustomPaint(
          painter: GreenPainter(),
          child: Container(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                const CustomSelectionsAppBar(
                  leading: null,
                  title: 'Добірки',
                  subTitle: 'Все в одному місці',
                  actions: DropdownButtonSellection(),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: MediaQuery.of(context).size.height * 0.753,
                  child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: FirebaseRepository().getAllSellections(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            final file = snapshot.data?.docs[index];
                            final fileDocId = snapshot.data?.docs[index].id;

                            return StoriesBoxSelections(
                              data: file!.data(),
                              docId: fileDocId!,
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
        ),
      ),
    );
  }
}
