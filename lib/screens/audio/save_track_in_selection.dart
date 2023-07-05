import 'dart:io';

import 'package:audio_stories/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/track_path_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/audio/widgets/dropdown_button.dart';
import 'package:audio_stories/screens/audio/widgets/player_widget.dart';
import 'package:audio_stories/screens/audio_stories/audio_stories.dart';
import 'package:audio_stories/screens/main_page.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class SaveTrackScreen extends StatefulWidget {
  const SaveTrackScreen({super.key});

  static const String routeName = '/save-track';

  @override
  State<SaveTrackScreen> createState() => _SaveTrackScreenState();
}

class _SaveTrackScreenState extends State<SaveTrackScreen> {
  final audioPlayer = AudioPlayer();
  TextEditingController selectionController = TextEditingController();
  TextEditingController trackNameController = TextEditingController();
  Duration duration = Duration.zero;
  final _validationKey = GlobalKey<FormState>();
  FocusNode trackFocus = FocusNode();
  String? imagePath;

  late String pathTrack;
  @override
  void initState() {
    super.initState();
    pathTrack = Provider.of<TrackPathProvider>(context, listen: false).path!;
    audioPlayer.setSource(DeviceFileSource(pathTrack));
    audioPlayer.onDurationChanged.listen((newDuration) {
      print('Max duration: $newDuration');
      duration = newDuration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: PurplePainter(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              if (trackNameController.text.isNotEmpty &&
                                  selectionController.text.isNotEmpty &&
                                  imagePath != null) {
                                FirebaseRepository().onTrackUpload(
                                  trackName: trackNameController.text,
                                  sellectionName: selectionController.text,
                                  duration: duration,
                                  pathTrack: pathTrack,
                                  imagePath: imagePath,
                                );
                                context.read<NavigationBloc>().add(
                                      NavigateTab(
                                        tabIndex: 3,
                                        route: AudioStoriesScreen.routeName,
                                      ),
                                    );
                              } else if (trackNameController.text.isNotEmpty) {
                                FirebaseRepository().onTrackUpload(
                                  trackName: trackNameController.text,
                                  sellectionName: null,
                                  duration: duration,
                                  pathTrack: pathTrack,
                                  imagePath: null,
                                );
                                context.read<NavigationBloc>().add(
                                      NavigateTab(
                                        tabIndex: 3,
                                        route: AudioStoriesScreen.routeName,
                                      ),
                                    );
                              } else {
                                trackFocus.requestFocus();
                                final snackBar = SnackBar(
                                  content: Text(
                                    'Введіть назву трека',
                                    style: mainTheme.textTheme.labelLarge
                                        ?.copyWith(
                                      color: ColorsApp.colorWhite,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor:
                                      (ColorsApp.colorLightOpacityDark),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: SvgPicture.asset(AppIcons.allowCircle),
                          ),
                          DropdownButtonTrackMenu(
                            pathTrack: Provider.of<TrackPathProvider>(context,
                                    listen: false)
                                .path!,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () async {
                            if (await Permission.photosAddOnly
                                .request()
                                .isGranted) {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(type: FileType.any);

                              if (result != null) {
                                File file = File(result.files.single.path!);
                                print('path:${file.path}');
                                imagePath = await FirebaseRepository()
                                    .saveImageInStorage(file);
                              }
                            }
                            setState(() {});
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Image.network(
                                  imagePath ??
                                      'https://www.englishdom.com/dynamicus/blog-post/000/002/403/1640597013_content_700x455.jpg',
                                  width: double.infinity,
                                  color: Colors.black45.withOpacity(0.4),
                                  colorBlendMode: BlendMode.darken,
                                ),
                                Positioned(
                                  left:
                                      MediaQuery.of(context).size.width * 0.35,
                                  top: 85,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1.5,
                                        color: ColorsApp.colorWhite,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: SvgPicture.asset(
                                      AppIcons.camera,
                                      width: 50,
                                      color: ColorsApp.colorWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _validationKey,
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: TextField(
                                cursorHeight: 25,
                                cursorColor: ColorsApp.colorLightOpacityDark,
                                controller: selectionController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'Введіть назву добірки',
                                  hintStyle: mainTheme.textTheme.labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                  focusColor: ColorsApp.colorLightDark,
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: ColorsApp.colorLightOpacityDark),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3,
                                        color: ColorsApp.colorLightDark),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                              child: TextFormField(
                                cursorHeight: 25,
                                cursorColor: ColorsApp.colorLightOpacityDark,
                                controller: trackNameController,
                                textAlign: TextAlign.center,
                                focusNode: trackFocus,
                                decoration: InputDecoration(
                                  hintText: 'Введіть назву аудіозапису',
                                  hintStyle: mainTheme.textTheme.bodyMedium,
                                  focusColor: ColorsApp.colorLightDark,
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: ColorsApp.colorLightOpacityDark),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3,
                                        color: ColorsApp.colorLightDark),
                                  ),
                                  errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3,
                                        color: ColorsApp.colorLightRed),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      PlayerWidget(
                        path: Provider.of<TrackPathProvider>(context,
                                listen: false)
                            .path!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
