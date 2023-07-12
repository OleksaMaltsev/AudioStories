import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/providers/track_menu_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/add_selection.dart';
import 'package:audio_stories/screens/selections/choice_some_selection.dart';
import 'package:audio_stories/screens/selections/edit_selection.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

String globPath = '';

class DropdownButtonSellection extends StatefulWidget {
  const DropdownButtonSellection({
    super.key,
  });

  @override
  State<DropdownButtonSellection> createState() =>
      _DropdownButtonSellectionState();
}

class _DropdownButtonSellectionState extends State<DropdownButtonSellection> {
  @override
  void initState() {
    super.initState();
  }

  void sharePressed() {
    String message = 'Share audio stories';
    // Share.shareXFiles([XFile(widget.pathTrack)]);
  }

  final List<String> items = [
    'Створити підбірку',
    'Видалити підбірки',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              AppIcons.dots,
              color: ColorsApp.colorWhite,
              width: 40,
            ),
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
            case 'Створити підбірку':
              Navigator.pushNamed(
                context,
                AddSelectionScreen.routeName,
              );
              break;
            case 'Видалити підбірки':
              Navigator.pushNamed(
                context,
                ChoiceSomeSelectionsScreen.routeName,
              );
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
            ...List<double>.filled(2, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}
