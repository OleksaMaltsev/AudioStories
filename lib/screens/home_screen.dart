import 'package:audio_stories/blocs/bloc/test_bloc.dart';
import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/audio_stories/audio_stories.dart';
import 'package:audio_stories/screens/audio_stories/widgets/track_container.dart';
import 'package:audio_stories/screens/selections/selection.dart';
import 'package:audio_stories/screens/selections/widgets/stories_box_selections.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/appBar/custom_app_bar.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audio_stories/widgets/custom_stories_box_selections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  //static const String routeName = '/main';
  static const String routeName = 'home_screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  Future<QuerySnapshot<Map<String, dynamic>>>? dataStream;
  Future<QuerySnapshot<Map<String, dynamic>>>? sellectionStream;

  List<Map<String, dynamic>> firstThreeSellect = [];
  List<String> docId = [];
  void getAllTrack() {
    final db = FirebaseFirestore.instance;
    dataStream = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tracks")
        .get();
  }

  void getAllSellection() {
    final db = FirebaseFirestore.instance;
    sellectionStream = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("sellections")
        .get();
  }

  @override
  void initState() {
    super.initState();
    getAllTrack();
    getAllSellection();

    parseList();
  }

  void parseList() async {
    await sellectionStream?.then((value) {
      if (value.docs.length >= 3) {
        print(value.docs.length);
        for (int i = 0; i <= 2; i++) {
          if (i > value.docs.length && value.docs.isNotEmpty) return;
          firstThreeSellect.add(value.docs[i].data());
          docId.add(value.docs[i].id);
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: PurplePainter(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                CustomAppBar(
                  contextScreen: context,
                  leading: null,
                  title: null,
                  subTitle: null,
                  actions: const SizedBox(),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Добірки',
                            style: mainTheme.textTheme.labelLarge?.copyWith(
                              color: ColorsApp.colorWhite,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                SelectionsScreen.routeName,
                                (route) => false,
                              );
                            },
                            child: Text(
                              'Відкрити все',
                              style: mainTheme.textTheme.labelSmall?.copyWith(
                                color: ColorsApp.colorWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          firstThreeSellect.length > 0
                              ? CustomStoriesBoxSelections(
                                  data: firstThreeSellect[0],
                                  docId: docId[0],
                                  heightBox: 240,
                                )
                              : Container(
                                  height: 240,
                                  width: 180.w,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        200, 113, 165, 159),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Тут буде твій набір казок',
                                        style: mainTheme.textTheme.labelMedium
                                            ?.copyWith(
                                          color: ColorsApp.colorWhite,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Додати',
                                          style: mainTheme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: ColorsApp.colorWhite,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          const SizedBox(width: 16),
                          Column(
                            children: [
                              firstThreeSellect.length > 1
                                  ? CustomStoriesBoxSelections(
                                      data: firstThreeSellect[1],
                                      docId: docId[1],
                                      heightBox: 112,
                                    )
                                  : Container(
                                      height: 112,
                                      width: 180.w,
                                      decoration: BoxDecoration(
                                        color: ColorsApp.colorButtonOrange,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Тут',
                                          style: mainTheme.textTheme.labelMedium
                                              ?.copyWith(
                                            color: ColorsApp.colorWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 16),
                              firstThreeSellect.length > 2
                                  ? CustomStoriesBoxSelections(
                                      data: firstThreeSellect[2],
                                      docId: docId[2],
                                      heightBox: 112,
                                    )
                                  : Container(
                                      height: 112,
                                      width: 180.w,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            200, 103, 139, 210),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Та тут',
                                          style: mainTheme.textTheme.labelMedium
                                              ?.copyWith(
                                            color: ColorsApp.colorWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(5, 30, 5, 0),
                padding: const EdgeInsets.fromLTRB(17, 24, 17, 0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: ColorsApp.colorWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(25, 0, 0, 0),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(5, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Аудіозаписи',
                          style: mainTheme.textTheme.labelLarge,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {});
                            Navigator.pushNamed(
                                context, AudioStoriesScreen.routeName);
                          },
                          //child: RecordTrack(),
                          child: Text(
                            'Відкрити все',
                            style: mainTheme.textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    dataStream != null
                        ? Container(
                            //height: MediaQuery.of(context).size.height * 0.32,
                            height: 301.h,
                            child: FutureBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                              future: dataStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return ListView.builder(
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context, index) {
                                      final file = snapshot.data?.docs[index];
                                      final fileDocId =
                                          snapshot.data?.docs[index].id;

                                      return TrackContainer(
                                        data: file!.data(),
                                        fileDocId: fileDocId!,
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
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 50),
                              Text(
                                'Щойно ти запишеш \nаудіо, вона з\'явиться тут.',
                                style:
                                    mainTheme.textTheme.labelMedium?.copyWith(
                                  color: ColorsApp.colorLightOpacityDark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 50),
                              SvgPicture.asset(
                                'assets/svg/ArrowDown.svg',
                                width: 60,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
    );
  }
}

// class BottomMenuIcons extends InheritedWidget {
//   const BottomMenuIcons({super.key, required this.child}) : super(child: child);

//   @override
//   final Widget child;

//   static BottomMenuIcons? of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<BottomMenuIcons>();
//   }

//   @override
//   bool updateShouldNotify(BottomMenuIcons oldWidget) {
//     return true;
//   }
// }

class RecordTrack extends StatefulWidget {
  const RecordTrack({super.key});

  @override
  State<RecordTrack> createState() => _RecordTrackState();
}

class _RecordTrackState extends State<RecordTrack> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          showBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                  ),
                );
              });
        },
        child: const Text('ef'));
  }
}
