import 'package:audio_stories/blocs/bloc/test_bloc.dart';
import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/audio/record.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bloc/bloc.dart';

import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  //static const String routeName = '/main';
  static const String routeName = '/';
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestBloc(),
      child: BlocBuilder<TestBloc, TestState>(
        builder: (context, state) {
          return Scaffold(
            body: CustomPaint(
              painter: PurplePainter(),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              //'Добірки',
                              state.strValue,
                              style: mainTheme.textTheme.labelLarge?.copyWith(
                                color: ColorsApp.colorWhite,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read<TestBloc>()
                                    .add(StringEvent('new'));
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
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 240,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(200, 113, 165, 159),
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
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: 112,
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
                                  Container(
                                    height: 112,
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
                            ),
                          ],
                        ),
                      ],
                    ),
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
                              // InkWell(
                              //   onTap: () {
                              //     // showModalBottomSheet(
                              //     //     context: context,
                              //     //     builder: (context) {
                              //     //       return Scaffold(
                              //     //         body: Container(),
                              //     //       );
                              //     //     });
                              //     setState(() {});
                              //   },
                              //   child: RecordTrack(),
                              //   // child: Text(
                              //   //   'Відкрити все',
                              //   //   style: mainTheme.textTheme.labelSmall,
                              //   // ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Text(
                            'Щойно ти запишеш \nаудіо, вона з\'явиться тут.',
                            style: mainTheme.textTheme.labelMedium?.copyWith(
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
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const BottomNavBarWidget(
              recordItem: false,
            ),
            extendBody: true,
          );
        },
      ),
    );
  }
}

class BottomMenuIcons extends InheritedWidget {
  const BottomMenuIcons({super.key, required this.child}) : super(child: child);

  final Widget child;

  static BottomMenuIcons? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BottomMenuIcons>();
  }

  @override
  bool updateShouldNotify(BottomMenuIcons oldWidget) {
    return true;
  }
}

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
                  decoration: BoxDecoration(
                    color: Colors.amber,
                  ),
                );
              });
        },
        child: Text('ef'));
  }
}
