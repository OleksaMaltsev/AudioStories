import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/providers/choise_tracks_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/choice_some_selection.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class DropdownButtonTracksChoice extends StatefulWidget {
  // final String fileDocId;
  // final Map<String, dynamic>? data;
  const DropdownButtonTracksChoice({
    // required this.fileDocId,
    // required this.data,
    super.key,
  });

  @override
  State<DropdownButtonTracksChoice> createState() =>
      _DropdownButtonTracksChoiceState();
}

class _DropdownButtonTracksChoiceState
    extends State<DropdownButtonTracksChoice> {
  @override
  void initState() {
    super.initState();
  }

  void sharePressed() {
    final tracks =
        Provider.of<ChoiseTrackProvider>(context, listen: false).getList();
    print(tracks);
    // print(widget.data);
    if (tracks.isNotEmpty) {
      // String message = 'Share audio stories';
      // List<XFile> pathList = [];
      // List listTracks = [];
      // // FirebaseFirestore.instance
      // //     .collection('tracks')
      // //     .get()
      // //     .then((value) => print(value));
      // // print(listTracks);
      // for (String item in tracks) {
      //   FirebaseFirestore.instance
      //       .collection('tracks')
      //       .doc(item)
      //       .get()
      //       .then((value) {
      //     final data = value.data();
      //     listTracks.add(data);
      //   });
      // }
      // print(listTracks);
      // for (int i = 0; i < tracks.length; i++) {
      //   final Map<String, dynamic> value = listTracks[i];
      //   pathList.add(XFile(value['url']));
      // }
      // Share.shareXFiles(pathList);
    }
  }

  final List<String> items = [
    'Відмінити вибір',
    'Додати в підбірку',
    'Видалити',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SvgPicture.asset(
            AppIcons.dots,
            color: ColorsApp.colorWhite,
            width: 40,
          ),
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: mainTheme.textTheme.labelSmall,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) async {
          selectedValue = value;
          switch (value) {
            case 'Відмінити вибір':
              Navigator.pop(context);
              break;
            case 'Додати в підбірку':
              Navigator.pushNamed(
                context,
                ChoiceSomeSelectionsScreen.routeName,
              );
              gappChangeProvider.changeWidgetNotifier(2);
              break;
            case 'Видалити':
              gappChangeProvider.changeWidgetNotifier(0);
              Navigator.pop(context);
              FirebaseRepository().deleteTrack(
                  Provider.of<ChoiseTrackProvider>(context, listen: false)
                      .getList());
              Provider.of<ChoiseTrackProvider>(context, listen: false)
                  .clearList();
              break;
          }
        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsApp.colorWhite,
          ),
          elevation: 8,
          offset: const Offset(0, -15),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(3, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}
