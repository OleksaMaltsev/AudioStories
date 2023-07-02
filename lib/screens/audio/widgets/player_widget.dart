import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/screens/audio/widgets/custom_slider_thumb_oval.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class PlayerWidget extends StatefulWidget {
  final String path;
  const PlayerWidget({super.key, required this.path});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late Duration currentPostion;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    // setAudio();
    audioPlayer.setSource(DeviceFileSource(widget.path));

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      print('Max duration: $newDuration');

      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (newPosition == duration) {
        audioPlayer.stop();
      }
      position = newPosition;
      currentPostion = position;

      if (mounted) {
        setState(() {});
      }
    });
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

  // todo: change 2 sec on 15 sec
  void _rewindUp() async {
    await audioPlayer.seek(currentPostion += const Duration(seconds: 2));
  }

  void _rewindDown() async {
    await audioPlayer.seek(currentPostion -= const Duration(seconds: 2));
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    if (mounted) {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: CustomSliderThumbOval(
                    thumbRadius: 15, max: duration.inSeconds, min: 0),
              ),
              child: Slider(
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
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _rewindDown();
                });
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
                    await audioPlayer.play(
                      DeviceFileSource(
                        widget.path,
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
    );
  }
}
