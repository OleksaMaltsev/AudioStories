import 'dart:io';

import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/providers/track_path_provider.dart';
import 'package:audio_stories/screens/audio/player.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/main_page.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

//TODO: create bloc
//late String globalPath;

class RecordWaveScreen extends StatefulWidget {
  const RecordWaveScreen({super.key});
  static const String routeName = '/wave_record';

  @override
  State<RecordWaveScreen> createState() => _RecordWaveScreenState();
}

class _RecordWaveScreenState extends State<RecordWaveScreen> {
  RecorderController recorderController = RecorderController(); // Initialise
  late Directory appDirectory;
  String? pathAudio;
  bool? isRecordingCompleted;
  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    pathAudio = "${appDirectory.path}/recording02.m4a";
    setState(() {});
  }

  void _initialiseControllers() async {
    isRecorderReady = true;
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
    await Future.delayed(const Duration(milliseconds: 400));
    _startRecord();
  }

  void _startRecord() async {
    await recorderController.record(
        path: pathAudio); // Record (path is optional)
    // Check mic permission (also called during record)
    setState(() {});
  }

  void _stopRecord() async {
    final path = await recorderController.stop();
    if (path != null) {
      isRecordingCompleted = true;
      debugPrint(path);
      debugPrint("Recorded file size: ${File(path).lengthSync()}");
      //globalPath = pathAudio!;
      if (mounted) {
        Provider.of<TrackPathProvider>(context, listen: false)
            .setPath(pathAudio!);
      }
      if (mounted) {
        Navigator.pushNamed(
          context,
          PlayerScreen.routeName,
        );
      }
    }
  }

  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
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
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                      Padding(
                        padding: const EdgeInsets.only(right: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  HomeScreen.routeName,
                                  (route) => false,
                                );
                              },
                              child: Text(
                                'Відмінити',
                                style: mainTheme.textTheme.labelMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //const SizedBox(height: 50),
                      Text(
                        'Запис',
                        style: mainTheme.textTheme.labelLarge,
                      ),
                      AudioWaveforms(
                        backgroundColor: ColorsApp.colorWhite,
                        size: Size(MediaQuery.of(context).size.width, 200.0),
                        recorderController: recorderController,
                        enableGesture: true,
                        waveStyle: const WaveStyle(
                          waveColor: Colors.black,
                          showDurationLabel: false, // активна тайм лінія знизу
                          spacing: 4, // відстань між хвилями
                          showBottom: true, // хвиля посередені
                          extendWaveform: true,
                          showMiddleLine: false,
                          durationLinesHeight: 19,
                          //middleLineThickness: 1,
                          waveThickness: 2, // товщина поділок
                          scaleFactor: 80, // висота поділок
                        ),
                      ),
                      StreamBuilder<Duration>(
                        stream: recorderController.onCurrentDuration,
                        builder: (context, snapshot) {
                          final duration =
                              snapshot.hasData ? snapshot.data! : Duration.zero;
                          print(duration);
                          String twoDigits(int n) =>
                              n.toString().padLeft(2, '0');
                          final hours =
                              twoDigits(duration.inHours.remainder(60));
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
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: ColorsApp.colorButtonOrange,
                        child: IconButton(
                          icon: Icon(
                            isRecorderReady ? Icons.pause : Icons.mic,
                          ),
                          iconSize: 50,
                          color: ColorsApp.colorOriginalWhite,
                          onPressed: () {
                            isRecorderReady = !isRecorderReady;
                            _stopRecord();
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
        // extendBody: true,
      ),
    );
  }
}
