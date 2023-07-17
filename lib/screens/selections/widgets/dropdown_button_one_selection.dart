import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/providers/sellection_create_provider.dart';
import 'package:audio_stories/providers/sellection_value_provider.dart';
import 'package:audio_stories/providers/track_menu_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/edit_selection.dart';
import 'package:audio_stories/screens/selections/selection.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class DropdownButtonOneSellection extends StatefulWidget {
  final String fileDocId;
  final Map<String, dynamic>? data;
  const DropdownButtonOneSellection({
    required this.fileDocId,
    required this.data,
    super.key,
  });

  @override
  State<DropdownButtonOneSellection> createState() =>
      _DropdownButtonOneSellectionState();
}

class _DropdownButtonOneSellectionState
    extends State<DropdownButtonOneSellection> {
  @override
  void initState() {
    super.initState();
  }

  void sharePressed() {
    String message = 'Share audio stories';
    // Share.shareXFiles([XFile(widget.pathTrack)]);
  }

  final List<String> items = [
    'Редагувати',
    'Вибрати декілька',
    'Видалити підбірку',
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
            case 'Редагувати':
              Navigator.pushNamed(
                context,
                EditSelectionScreen.routeName,
                arguments: widget.data,
              );
              if (Provider.of<SellectionValueProvider>(context, listen: false)
                      .name ==
                  null) {
                Provider.of<SellectionValueProvider>(context, listen: false)
                    .setValues(
                  name: widget.data?['name'],
                  description: widget.data?['description'],
                  photo: widget.data?['photo'],
                );
              }

              break;
            case 'Вибрати декілька':
              //sharePressed();
              break;
            case 'Видалити підбірку':
              FirebaseRepository().deleteSellections([widget.fileDocId]);
              Navigator.pushReplacementNamed(
                context,
                SelectionsScreen.routeName,
              );
              break;
            case 'Поділитись':
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
