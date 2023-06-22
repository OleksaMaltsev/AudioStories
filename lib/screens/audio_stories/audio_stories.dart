import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/appBar/custom_app_bar.dart';
import 'package:audio_stories/widgets/background/background_blue_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioStoriesScreen extends StatefulWidget {
  const AudioStoriesScreen({super.key});
  static const String routeName = '/audio-stories';

  @override
  State<AudioStoriesScreen> createState() => _AudioStoriesScreenState();
}

class _AudioStoriesScreenState extends State<AudioStoriesScreen> {
  late Future<ListResult> futureFiles;

  AudioPlayer audioPlayer = AudioPlayer();
  Reference firebaseStorage = FirebaseStorage.instance.ref();
  String? filePath;
  int count = 0;

  // final storageRef =
  //     FirebaseStorage.instance.ref('upload-voice-firebase/recording.m4a');

  //Reference storageRef = FirebaseStorage.instance.ref(filePath);

  String dateRef = '';

  //future = _asyncmethodCall();
  List<String> list1 = [];
  void _refresh() {
    print('refresh');
    setState(() {});
  }

  void _getPath(String path) async {
    // String fullPath = 'e';
    // var futureFiles2 = FirebaseStorage.instance.ref(path);
    // await futureFiles2.getDownloadURL().then((value) {
    //   dateRef = value;
    // });

    // await futureFiles2.getDownloadURL().then((value) {
    //   list1.add(value);
    // });
    // треки міняються місттами
    setState(() {});
    //print(list1);
    //return fullPath;

    //setState(() {});
  }

  Future<void> _initData() async {
    Track track = await FirebaseRepository().getTrack();
    setState(() {
      //listRef.add(track);
    });
  }

  //late Future<ListResult> _futureDate;
  late ListResult listResult;

  List<Reference> listRef = [];
  @override
  void initState() {
    super.initState();

    futureFiles =
        FirebaseStorage.instance.ref('/upload-voice-firebase/').list();
    futureFiles.then((value) {
      listRef = value.items;
    });
    setState(() {});
    print(listRef);

    // storageRef.getDownloadURL().then((String res) => {
    //       setState(() {
    //         dateRef = res;
    //       }),
    //       print(dateRef),
    //     });
    //futureFiles.then((value) => {listResult = value});
  }

  @override
  void dispose() {
    super.dispose();
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
                      height: 400,
                      child: ListView.builder(
                        itemCount: listRef.length,
                        itemBuilder: (context, index) {
                          final file = listRef[index];
                          //_getPath(file.fullPath);
                          count = listRef.length;
                          // Future.delayed(Duration.zero, () async {
                          //   _refresh();
                          // });

                          return TrackContainer(
                            name: file.name,
                            urlTrack: file,
                          );
                        },
                      ),
                    ),
                    // todo: edit it and delete
                    // Container(
                    //   height: 400,
                    //   child: FutureBuilder(
                    //     future: futureFiles,
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasData) {
                    //         final files = snapshot.data!.items;
                    //         return ListView.builder(
                    //           itemCount: files.length,
                    //           itemBuilder: (context, index) {
                    //             final file = files[index];
                    //             String fileUrl = '';
                    //             Reference storageReference =
                    //                 FirebaseStorage.instance.ref(file.fullPath);
                    //             storageReference.getDownloadURL().then((value) {
                    //               dateRef = value;
                    //               //setState(() {});
                    //               pathsTracks.add(value);
                    //               print(dateRef);
                    //               print(pathsTracks[index]);
                    //               if (index == (files.length - 1)) {
                    //                 setState(() {});
                    //               }
                    //               //setState(() {});
                    //             });
                    //             //Future.delayed(Duration(seconds: 3));

                    //             return TrackContainer(
                    //               name: file.name,
                    //               urlTrack: pathsTracks[index],
                    //             );
                    //             // return ListTile(
                    //             //   title: Text(file.name),
                    //             //   subtitle: Text(dateRef),
                    //             //   // subtitle: Text(
                    //             //   //     'https://firebasestorage.googleapis.com/v0/b/audiostories-eb9d8.appspot.com/o/' +
                    //             //   //         file.fullPath),
                    //             //   trailing: ElevatedButton(
                    //             //       // onPressed: () {
                    //             //       //   audioPlayer.play(UrlSource(dateRef));
                    //             //       // },
                    //             //       onPressed: () {
                    //             //         audioPlayer.play(
                    //             //             UrlSource(pathsTracks[index]));
                    //             //       },
                    //             //       child: Text('play')),
                    //             // );

                    //           },
                    //         );
                    //       } else if (snapshot.hasError) {
                    //         return const Center(
                    //           child: Text('some error'),
                    //         );
                    //       } else {
                    //         return const Center(
                    //           child: CircularProgressIndicator.adaptive(),
                    //         );
                    //       }
                    //     },
                    //   ),
                    // ),
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

class TrackContainer extends StatefulWidget {
  const TrackContainer({super.key, required this.name, required this.urlTrack});

  final String name;
  final Reference urlTrack;

  @override
  State<TrackContainer> createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool playTrack = false;
  String path = '';
  @override
  void initState() {
    //audioPlayer.setSourceUrl(widget.urlTrack);

    _getPath();
    setState(() {});

    super.initState();
  }

  void _getPath() async {
    path = await widget.urlTrack.getDownloadURL();
    print(path + 'ff');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: double.infinity,
      //height: 60,
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
                  setState(() {});
                  audioPlayer.play(UrlSource(path));

                  //audioPlayer.stop();

                  playTrack = !playTrack;
                },
                child: SvgPicture.asset(
                  playTrack ? AppIcons.pause50 : AppIcons.play50,
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
                    widget.name ?? 'Track',
                    style: mainTheme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '30 хвилин ${path}',
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
    );
  }
}
