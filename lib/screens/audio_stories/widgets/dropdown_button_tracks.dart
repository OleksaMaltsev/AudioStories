import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/helpers/allow_dialog_helper.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/screens/audio_stories/audio_stories_track_choice.dart';
import 'package:audio_stories/screens/audio_stories/tracks_choice.dart';
import 'package:audio_stories/screens/selections/one_selection_choice.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class DropdownButtonTracks extends StatefulWidget {
  // final String fileDocId;
  // final Map<String, dynamic>? data;
  const DropdownButtonTracks({
    // required this.fileDocId,
    // required this.data,
    super.key,
  });

  @override
  State<DropdownButtonTracks> createState() => _DropdownButtonTracksState();
}

class _DropdownButtonTracksState extends State<DropdownButtonTracks> {
  @override
  void initState() {
    super.initState();
  }

  void sharePressed() {
    // String message = 'Share audio stories';
    // List<XFile> pathList = [];
    // final list = widget.data?['tracks'] as List;
    // list.forEach((element) {
    //   pathList.add(XFile(element['url']));
    // });
    // Share.shareXFiles(pathList);
  }

  final List<String> items = [
    'Вибрати декілька',
    'Видалити декілька',
    'Поділитись',
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
            case 'Вибрати декілька':
              Navigator.pushNamed(
                context,
                AudioStoriesChoiceScreen.routeName,
              );
              gappChangeProvider.changeWidgetNotifier(2);
              break;
            case 'Видалити декілька':
              Navigator.pushNamed(
                context,
                AudioStoriesChoiceScreen.routeName,
              );
              break;
            case 'Поділитись':
              sharePressed();
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
