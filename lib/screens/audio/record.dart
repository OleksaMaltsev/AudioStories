import 'dart:io';

import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/audio/player.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/menu_bar_items.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';

import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

String abo = '';
late Directory tempDir;
String? path;

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});
  static const String routeName = '/record';

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();

    initRecorder();
    setState(() {});
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    tempDir = await getTemporaryDirectory();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await Permission.storage.request();

    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
    record();
    setState(() {});
  }

  Future record() async {
    if (!isRecorderReady) return;

    await recorder.startRecorder(toFile: 'audio.mp4');
  }

  Future stop() async {
    if (!isRecorderReady) return;
    path = await recorder.stopRecorder() ?? '';
    final audioFile = File(path!);

    print('Recorder audio $audioFile');

    Navigator.pushNamed(
      context,
      PlayerScreen.routeName,
    );
  }

  // player
  // final audioPlayer = AudioPlayer();
  // bool isPlaying = false;
  // Duration duration = Duration.zero;
  // Duration position = Duration.zero;

  // String formatTime(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   final hours = twoDigits(duration.inHours);
  //   final minutes = twoDigits(duration.inMinutes.remainder(60));
  //   final seconds = twoDigits(duration.inSeconds.remainder(60));

  //   return [
  //     if (duration.inHours > 0) hours,
  //     minutes,
  //     seconds,
  //   ].join(':');
  // }

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
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Відмінити'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),

                    Text(
                      'Запис',
                      style: mainTheme.textTheme.labelLarge,
                    ),

                    StreamBuilder<RecordingDisposition>(
                      stream: recorder.onProgress,
                      builder: (context, snapshot) {
                        final duration = snapshot.hasData
                            ? snapshot.data!.duration
                            : Duration.zero;
                        print(duration);
                        String twoDigits(int n) => n.toString().padLeft(2, '0');
                        final hours = twoDigits(duration.inHours.remainder(60));
                        final minutes =
                            twoDigits(duration.inMinutes.remainder(60));
                        final seconds =
                            twoDigits(duration.inSeconds.remainder(60));

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: ColorsApp.colorLightRed,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            Text(' $hours:$minutes:$seconds'),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    // Slider(
                    //     min: 0,
                    //     max: duration.inSeconds.toDouble(),
                    //     value: position.inSeconds.toDouble(),
                    //     onChanged: (value) async {
                    //       final position = Duration(seconds: value.toInt());
                    //       await audioPlayer.seek(position);

                    //       await audioPlayer.resume();
                    //     }),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(formatTime(position)),
                    //     Text(formatTime(duration)),
                    //   ],
                    // ),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: ColorsApp.colorButtonOrange,
                      child: IconButton(
                        icon: Icon(
                          //recorder.isRecording ? Icons.pause : Icons.mic,
                          isRecorderReady ? Icons.pause : Icons.mic,
                        ),
                        iconSize: 50,
                        color: ColorsApp.colorOriginalWhite,
                        onPressed: () async {
                          if (recorder.isRecording) {
                            await stop();
                          }
                          // else {
                          //   await record();
                          // }
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(
        recordItem: true,
      ),
      extendBody: true,
    );
  }
}
