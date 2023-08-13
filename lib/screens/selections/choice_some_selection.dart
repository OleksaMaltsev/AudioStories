import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/providers/choise_tracks_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/choies_selection.dart';
import 'package:audio_stories/screens/selections/selection.dart';
import 'package:audio_stories/screens/selections/widgets/custom_selections_app_bar.dart';
import 'package:audio_stories/screens/selections/widgets/dropdown_button_selection.dart';
import 'package:audio_stories/screens/selections/widgets/stories_box_selections.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
  List<String> listSellections = [];
  Map<String, bool> mapChoose = {};
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
              CustomSelectionsAppBar(
                leading: null,
                title: 'Добірки',
                subTitle: 'Все в одному місці',
                actions: TextButton(
                  onPressed: () {
                    mapChoose.forEach((key, value) {
                      if (value == true) {
                        listSellections.add(key);
                      }
                    });
                    print(listSellections);
                    if (gappChangeProvider.valueNotifier.value == 2) {
                      final list = Provider.of<ChoiseTrackProvider>(context,
                              listen: false)
                          .getList();
                      print(list);
                      FirebaseRepository().addTracksInSellection(
                          listSellectionId: listSellections,
                          listTracksId: list);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        SelectionsScreen.routeName,
                        (route) => false,
                      );
                    } else {
                      FirebaseRepository().deleteSellections(listSellections);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        SelectionsScreen.routeName,
                        (route) => false,
                      );
                    }
                    gappChangeProvider.changeWidgetNotifier(0);
                  },
                  child: ValueListenableBuilder(
                    valueListenable: gappChangeProvider.valueNotifier,
                    builder: (context, value, child) {
                      if (value == 2) {
                        return AutoSizeText(
                          'Додати',
                          style: mainTheme.textTheme.labelSmall?.copyWith(
                            fontSize: 8,
                            color: ColorsApp.colorWhite,
                          ),
                        );
                      } else {
                        return AutoSizeText(
                          'Видалити',
                          style: mainTheme.textTheme.labelSmall?.copyWith(
                            fontSize: 8,
                            color: ColorsApp.colorWhite,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: MediaQuery.of(context).size.height * 0.753,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseRepository().getSellectionSnapshot(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
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
                          if (fileDocId != null &&
                              mapChoose[fileDocId] != true) {
                            mapChoose[fileDocId] = false;
                          }

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
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    if (mapChoose[fileDocId] == true) {
                                      mapChoose[fileDocId] = false;
                                    } else {
                                      mapChoose[fileDocId] = true;
                                    }
                                    print(listSellections);
                                    print(mapChoose);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        width: 2,
                                        color: ColorsApp.colorWhite,
                                      ),
                                    ),
                                    child: mapChoose[fileDocId]!
                                        ? SvgPicture.asset(
                                            AppIcons.tickSquare,
                                            color: ColorsApp.colorWhite,
                                          )
                                        : const SizedBox(),
                                  ),
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
