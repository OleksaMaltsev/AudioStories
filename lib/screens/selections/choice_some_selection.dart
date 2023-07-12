import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/choise_tracks_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/choies_selection.dart';
import 'package:audio_stories/screens/selections/widgets/custom_selections_app_bar.dart';
import 'package:audio_stories/screens/selections/widgets/dropdown_button_selection.dart';
import 'package:audio_stories/screens/selections/widgets/stories_box_selections.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ChoiceSomeSelectionsScreen extends StatefulWidget {
  const ChoiceSomeSelectionsScreen({super.key});
  static const String routeName = '/some-selections';

  @override
  State<ChoiceSomeSelectionsScreen> createState() =>
      _ChoiceSomeSelectionsScreenState();
}

class _ChoiceSomeSelectionsScreenState
    extends State<ChoiceSomeSelectionsScreen> {
  List<String> listTracks = [];
  bool choose = false;
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

                          return Stack(
                            children: [
                              StoriesBoxSelections(
                                data: file!.data(),
                                docId: fileDocId!,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [
                                      0.1,
                                      0.6,
                                    ],
                                    colors: [
                                      Color.fromARGB(50, 0, 0, 0),
                                      Color.fromARGB(140, 45, 45, 45),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() {
                                  final list = Provider.of<ChoiseTrackProvider>(
                                      context,
                                      listen: false);
                                  choose = !choose;
                                  // if (choose &&
                                  //     !list.getList().contains(track!.url)) {
                                  //   list.addToList(widget.fileDocId);
                                  //   list.printList();
                                  // }
                                  // if (!choose) {
                                  //   list.removeItem(widget.fileDocId);
                                  //   list.printList();
                                  // }
                                }),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      width: 2,
                                      color: ColorsApp.colorLightDark,
                                    ),
                                  ),
                                  child: choose
                                      ? SvgPicture.asset(AppIcons.tickSquare)
                                      : const SizedBox(),
                                ),
                              ),
                            ],
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
