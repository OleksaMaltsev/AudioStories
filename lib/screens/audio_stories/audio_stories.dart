import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/appBar/custom_app_bar.dart';
import 'package:audio_stories/widgets/background/background_blue_widget.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioStoriesScreen extends StatefulWidget {
  const AudioStoriesScreen({super.key});
  static const String routeName = '/audio-stories';

  @override
  State<AudioStoriesScreen> createState() => _AudioStoriesScreenState();
}

class _AudioStoriesScreenState extends State<AudioStoriesScreen> {
  bool play = false;
  bool repeat = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BluePainter(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Column(
            children: [
              const CustomAppBar(
                  leading: null,
                  title: 'Аудіозаписи',
                  subTitle: 'Все в одному місці',
                  actions: null),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 25, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1 аудіо',
                          style: mainTheme.textTheme.labelSmall?.copyWith(
                            color: ColorsApp.colorWhite,
                          ),
                        ),
                        Text(
                          '10:30 часов',
                          style: mainTheme.textTheme.labelSmall?.copyWith(
                            color: ColorsApp.colorWhite,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            repeat = !repeat;
                            setState(() {});
                          },
                          child: Container(
                            width: 200,
                            height: 46,
                            decoration: BoxDecoration(
                              color: repeat
                                  ? ColorsApp.colorOpacityWhite
                                  : ColorsApp.colorOpacityBlue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SvgPicture.asset(
                                  repeat
                                      ? AppIcons.fluentArrow
                                      : AppIcons.fluentArrowWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              play = !play;
                            });
                          },
                          child: Container(
                            width: 148,
                            height: 46,
                            padding: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: ColorsApp.colorWhite,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                !play
                                    ? SvgPicture.asset(
                                        AppIcons.play,
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: SvgPicture.asset(
                                          AppIcons.pause,
                                          width: 38,
                                          color: ColorsApp.colorPurple,
                                        ),
                                      ),
                                Text(
                                  'Запустити все',
                                  style:
                                      mainTheme.textTheme.labelSmall?.copyWith(
                                    color: ColorsApp.colorPurple,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
