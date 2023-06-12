import 'dart:io';

import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/audio/record_wave.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_saver/file_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  static const String routeName = '/player';

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<Reference>? references;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late Duration currentPostion;
  Duration newPosition = const Duration(seconds: 0);

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    initPlayer();
    _onUploadComplete();
  }

  Future<void> _onUploadComplete() async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult =
        await firebaseStorage.ref().child('upload_voice_firebase').list();
    setState(() {
      references = listResult.items;
    });
  }

  Future<void> _onFileUpload() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      _isUploading = true;
    });
    try {
      await firebaseStorage
          .ref('upload-voice-firebase')
          .child(globalPath.substring(
              globalPath.lastIndexOf('/'), globalPath.length))
          .putFile(File(globalPath));
      _onUploadComplete();
      print(firebaseStorage);
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occured while uplaoding'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void initPlayer() {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    // setAudio();
    audioPlayer.setSource(DeviceFileSource(globalPath));

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      print('Max duration: $newDuration');

      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (newPosition == duration) {
        audioPlayer.stop();
      }

      setState(() {
        position = newPosition;
        currentPostion = position;
      });
    });
  }

  // todo: change 2 sec on 15 sec
  void _rewindUp() async {
    await audioPlayer.seek(currentPostion += Duration(seconds: 2));
    print(position);
  }

  void _rewindDown() async {
    await audioPlayer.seek(currentPostion -= Duration(seconds: 2));
    print(position);
  }

  void saveAs() async {
    await FileSaver.instance.saveAs(
      ext: 'm4a',
      mimeType: MimeType.aac,
      name: 'audio',
      filePath: globalPath,
    );
  }

  void sharePressed() {
    String message = 'Share audio stories';

    Share.shareXFiles([XFile(globalPath)]);
  }

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
            Expanded(
              flex: 1,
              child: SizedBox(
                child: ListView(
                  children: [Text(references.toString())],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.fromLTRB(5, 30, 5, 0),
                padding: const EdgeInsets.fromLTRB(17, 20, 17, 20),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            sharePressed();
                          },
                          child: SvgPicture.asset(
                            'assets/svg/Upload.svg',
                            height: 30,
                          ),
                        ),
                        const SizedBox(width: 30),
                        InkWell(
                          onTap: () {
                            saveAs();
                          },
                          child: SvgPicture.asset(
                            'assets/svg/PaperDownload.svg',
                            height: 30,
                          ),
                        ),
                        const SizedBox(width: 30),
                        InkWell(
                          onTap: () {
                            //todo: trable with setState
                            // Navigator.pushNamedAndRemoveUntil(
                            //   context,
                            //   HomeScreen.routeName,
                            //   (route) => false,
                            // );
                          },
                          child: SvgPicture.asset(
                            'assets/svg/Delete.svg',
                            height: 30,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            _onFileUpload();
                          },
                          child: const Text('Зберегти'),
                        ),
                      ],
                    ),
                    Text(
                      'Аудіозапис 1',
                      style: mainTheme.textTheme.labelLarge,
                    ),
                    Column(
                      children: [
                        Slider(
                          activeColor: ColorsApp.colorLightDark,
                          inactiveColor: ColorsApp.colorLightDark,
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await audioPlayer.seek(position);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatTime(position)),
                            Text(formatTime(duration)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _rewindDown();
                            });

                            print(position);
                            print('fe');
                          },
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
                                // String apiEndpoint =
                                //     'https://archive.org/download/IGM-V7/IGM%20-%20Vol.%207/25%20Diablo%20-%20Tristram%20%28Blizzard%29.mp3';
                                await audioPlayer.play(
                                  DeviceFileSource(
                                    globalPath,
                                  ),
                                );
                                print(audioPlayer.getDuration().toString());
                              }
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _rewindUp();
                            });
                          },
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
      extendBody: true,
    );
  }
}
