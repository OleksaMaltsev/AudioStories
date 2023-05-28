import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/audio/record.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});
  static const String routeName = '/player';

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    // setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  // Future setAudio() async {
  //   audioPlayer.setReleaseMode(ReleaseMode.loop);
  //   // String url = '';
  //   // audioPlayer.setSourceUrl(url);
  //   final file = abo;
  // }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioPlayer.stop();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: PurplePainter(),
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.fromLTRB(5, 30, 5, 0),
                padding: const EdgeInsets.fromLTRB(17, 10, 17, 120),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/Upload.svg',
                          height: 30,
                        ),
                        const SizedBox(width: 30),
                        SvgPicture.asset(
                          'assets/svg/PaperDownload.svg',
                          height: 30,
                        ),
                        const SizedBox(width: 30),
                        SvgPicture.asset(
                          'assets/svg/Delete.svg',
                          height: 30,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {},
                          child: Text('Зберегти'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Аудіозапис 1',
                      style: mainTheme.textTheme.labelLarge,
                    ),
                    Slider(
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble(),
                        onChanged: (value) async {
                          final position = Duration(seconds: value.toInt());
                          await audioPlayer.seek(position);

                          await audioPlayer.resume();
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(position)),
                        Text(formatTime(duration)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(
                            'assets/svg/secLeft.svg',
                            height: 38,
                          ),
                        ),
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: ColorsApp.colorButtonOrange,
                          child: IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                            iconSize: 50,
                            color: ColorsApp.colorOriginalWhite,
                            onPressed: () async {
                              if (isPlaying) {
                                await audioPlayer.pause();
                              } else {
                                String apiEndpoint =
                                    'https://archive.org/download/IGM-V7/IGM%20-%20Vol.%207/25%20Diablo%20-%20Tristram%20%28Blizzard%29.mp3';
                                await audioPlayer.play(
                                  DeviceFileSource(
                                    path ?? '',
                                  ),
                                );
                                // await audioPlayer.play(UrlSource(
                                //     '/data/user/0/com.example.memory_box/cache/audio.mp4'));
                                print(
                                    await audioPlayer.getDuration().toString());
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(
                            'assets/svg/secRight.svg',
                            height: 38,
                          ),
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
      bottomNavigationBar: const BottomNavBarWidget(),
      extendBody: true,
    );
  }
}
