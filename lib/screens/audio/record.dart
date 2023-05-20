import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});
  static const String routeName = '/record';

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final recorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();

    initRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    recorder.closeRecorder();

    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    status;
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    setState(() {});
    recorder.setSubscriptionDuration(
      const Duration(microseconds: 100),
    );
  }

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    await recorder.stopRecorder();
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {});
                          },
                          child: Text('Відмінити'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),

                    Text(
                      'Запис',
                      style: mainTheme.textTheme.labelLarge,
                    ),
                    Text(
                      'Аудіозапис №1',
                      style: mainTheme.textTheme.labelLarge,
                    ),
                    StreamBuilder<RecordingDisposition>(
                      stream: recorder.onProgress,
                      builder: (context, snapshot) {
                        final duration = snapshot.hasData
                            ? snapshot.data!.duration
                            : Duration.zero;

                        String twoDigits(int n) => n.toString().padLeft(2, '0');
                        final minutes =
                            twoDigits(duration.inMinutes.remainder(60));
                        final seconds =
                            twoDigits(duration.inSeconds.remainder(60));

                        return Text('$minutes:$seconds');
                        // return Text([
                        //   if (duration.inHours > 0) hours,
                        //   minutes,
                        //   seconds,
                        // ].join(':'));
                      },
                    ),
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
                      child: IconButton(
                        icon: Icon(
                          recorder.isRecording ? Icons.pause : Icons.mic,
                        ),
                        iconSize: 50,
                        onPressed: () async {
                          if (recorder.isRecording) {
                            await stop();
                          } else {
                            await record();
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    // const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: ColorsApp.colorWhite,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(25, 0, 0, 0),
              spreadRadius: 5,
              blurRadius: 15,
              offset: Offset(7, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: BottomNavigationBar(
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: ColorsApp.colorPurple,
            selectedLabelStyle: mainTheme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
            ),
            unselectedLabelStyle: mainTheme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
            ),
            onTap: (value) {
              if (value == 2) {
                setState(() {});
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Головна',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apps),
                label: 'Добірки',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svg/record.svg',
                  width: 40,
                ),
                label: 'Запис',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_rounded),
                label: 'Аудіоказки',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                label: 'Профіль',
              ),
            ],
          ),
        ),
      ),
      extendBody: true,
    );
  }
}
