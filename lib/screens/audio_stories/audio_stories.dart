import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/appBar/custom_app_bar.dart';
import 'package:audio_stories/widgets/background/background_blue_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioStoriesScreen extends StatefulWidget {
  const AudioStoriesScreen({super.key});
  static const String routeName = '/audio-stories';

  @override
  State<AudioStoriesScreen> createState() => _AudioStoriesScreenState();
}

class _AudioStoriesScreenState extends State<AudioStoriesScreen> {
  late Future<ListResult> futureFiles;

  @override
  void initState() {
    super.initState();

    futureFiles =
        FirebaseStorage.instance.ref('/upload-voice-firebase/').list();
  }

  bool play = false;
  bool repeat = false;

  bool playTrack = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BluePainter(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Column(
            children: [
              CustomAppBar(
                contextScreen: context,
                leading: null,
                title: 'Аудіозаписи',
                subTitle: 'Все в одному місці',
                actions: null,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 25, 40),
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
                          '30 хвилин',
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
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: ColorsApp.colorSlimOpacityDark,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 5,
                                right: 10,
                              ),
                              child: InkWell(
                                onTap: () {
                                  playTrack = !playTrack;
                                  setState(() {});
                                },
                                child: SvgPicture.asset(
                                  playTrack
                                      ? AppIcons.play50
                                      : AppIcons.pause50,
                                  color: ColorsApp.colorBlue,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Track 1',
                                    style: mainTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '30 хвилин',
                                    style: mainTheme.textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SvgPicture.asset(
                              AppIcons.dots,
                              color: ColorsApp.colorLightDark,
                              width: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // todo: edit it and delete
                    Container(
                      height: 400,
                      child: FutureBuilder(
                        future: futureFiles,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final files = snapshot.data!.items;
                            return ListView.builder(
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                final file = files[index];
                                return ListTile(
                                  title: Text(file.name),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text('some error'),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }
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
