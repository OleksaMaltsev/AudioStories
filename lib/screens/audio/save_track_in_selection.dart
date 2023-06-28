import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/providers/track_path_provider.dart';
import 'package:audio_stories/screens/audio/widgets/player_widget.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class SaveTrackScreen extends StatefulWidget {
  const SaveTrackScreen({super.key});

  static const String routeName = '/save-track';

  @override
  State<SaveTrackScreen> createState() => _SaveTrackScreenState();
}

class _SaveTrackScreenState extends State<SaveTrackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: PurplePainter(),
        child: Container(
          height: 600,
          width: double.infinity,
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
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        child: PlayerWidget(
                          path: Provider.of<TrackPathProvider>(context,
                                  listen: false)
                              .path!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
