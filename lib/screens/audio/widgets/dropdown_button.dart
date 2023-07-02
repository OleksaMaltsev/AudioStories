import 'dart:io';
import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/track_path_provider.dart';
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

class DropdownButtonTrackMenu extends StatefulWidget {
  final String pathTrack;
  const DropdownButtonTrackMenu({
    super.key,
    required this.pathTrack,
  });

  @override
  State<DropdownButtonTrackMenu> createState() =>
      _DropdownButtonTrackMenuState();
}

class _DropdownButtonTrackMenuState extends State<DropdownButtonTrackMenu> {
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
    'Додати в добірку',
    'Поділитись',
    'Скачати',
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
            color: ColorsApp.colorLightDark,
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
            case 'Додати в добірку':
              print('ono');
              break;
            case 'Поділитись':
              sharePressed();
              break;
            case 'Скачати':
              saveAs();
              break;
            case 'Видалити':
              await File(widget.pathTrack).delete();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (route) => false);
              }
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

class TrackFunctionality {
  static void saveAs() async {
    await FileSaver.instance.saveAs(
      ext: 'm4a',
      mimeType: MimeType.aac,
      name: 'audio',
      filePath: globPath,
    );
  }

  static void sharePressed() {
    String message = 'Share audio stories';
    Share.shareXFiles([XFile(globPath)]);
  }
}
