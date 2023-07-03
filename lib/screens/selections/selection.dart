import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/choies_selection.dart';
import 'package:audio_stories/screens/selections/widgets/custom_selections_app_bar.dart';
import 'package:audio_stories/screens/selections/widgets/dropdown_button_selection.dart';
import 'package:audio_stories/screens/selections/widgets/stories_box_selections.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectionsScreen extends StatefulWidget {
  const SelectionsScreen({super.key});
  static const String routeName = '/selections';

  @override
  State<SelectionsScreen> createState() => _SelectionsScreenState();
}

class _SelectionsScreenState extends State<SelectionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                actions: DropdownButtonSelection(),
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
    );
  }
}

            // Column(
            //   children: [
            //     const CustomSelectionsAppBar(
            //       leading: null,
            //       title: 'Добірки',
            //       subTitle: 'Все в одному місці',
            //       actions: DropdownButtonSelection(),
            //     ),
            //     const SizedBox(height: 30),
            //     const Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: [
            //             StoriesBoxSelections(
            //               imagePath: 'assets/icons/Rectangle382.png',
            //               storiesName: 'Казка про малюка Коккі',
            //             ),
            //             StoriesBoxSelections(
            //               imagePath: 'assets/icons/Rectangle3822.png',
            //               storiesName: 'Казка про Тараса',
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //     //TODO: delete button
            //     ElevatedButton(
            //       onPressed: () {
            //         Navigator.pushNamed(context, ChoiceSelectionScreen.routeName);
            //       },
            //       child: Text('choice_selection'),
            //     ),
            //   ],
            // ),