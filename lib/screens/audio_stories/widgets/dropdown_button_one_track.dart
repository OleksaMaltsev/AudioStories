import 'dart:io';
import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/providers/track_menu_provider.dart';
import 'package:audio_stories/providers/track_path_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/main_page.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

String globPath = '';

class DropdownButtonOneTrackMenu extends StatefulWidget {
  final String pathTrack;
  final ChangeNamePovider providerName;
  TrackMenuProvider trackNameNotifier = TrackMenuProvider();
  DropdownButtonOneTrackMenu({
    super.key,
    required this.pathTrack,
    required this.providerName,
  });

  @override
  State<DropdownButtonOneTrackMenu> createState() =>
      _DropdownButtonOneTrackMenuState();
}

class _DropdownButtonOneTrackMenuState
    extends State<DropdownButtonOneTrackMenu> {
  ChangeNamePovider appValueNotifier = ChangeNamePovider();
  @override
  void initState() {
    super.initState();
    globPath = widget.pathTrack;
  }

  void saveAs() async {
    await FileSaver.instance.saveAs(
      ext: 'm4a',
      mimeType: MimeType.aac,
      name: 'audio',
      filePath: widget.pathTrack,
    );
  }

  void sharePressed() {
    String message = 'Share audio stories';
    Share.shareXFiles([XFile(widget.pathTrack)]);
  }

  final List<String> items = [
    'Перейменувати',
    'Додати в добірку',
    'Видалити',
    'Поділитись',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: SvgPicture.asset(
          AppIcons.dots,
          color: ColorsApp.colorLightDark,
          width: 20,
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
            case 'Додати в добірку':
              widget.providerName.changeWidgetNotifier(2);
              print('ono');
              break;
            case 'Поділитись':
              sharePressed();
              break;
            case 'Перейменувати':
              setState(() {});
              widget.providerName.changeWidgetNotifier(1);
              //FirebaseRepository().setNewTrackName('name');
              break;
            case 'Видалити':
              print('delete non');
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
            ...List<double>.filled(4, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}
