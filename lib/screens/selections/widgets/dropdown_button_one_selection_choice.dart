import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/helpers/allow_dialog_helper.dart';
import 'package:audio_stories/helpers/audio_save_helper.dart';
import 'package:audio_stories/providers/allow_to_delete_provider.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/providers/choise_tracks_provider.dart';
import 'package:audio_stories/providers/sellection_create_provider.dart';
import 'package:audio_stories/providers/sellection_value_provider.dart';
import 'package:audio_stories/providers/track_menu_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/choice_some_selection.dart';
import 'package:audio_stories/screens/selections/edit_selection.dart';
import 'package:audio_stories/screens/selections/one_selection_choice.dart';
import 'package:audio_stories/screens/selections/selection.dart';
import 'package:audio_stories/screens/selections/widgets/track_container_widget.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class DropdownButtonOneSellectionChoice extends StatefulWidget {
  final String fileDocId;
  final Map<String, dynamic>? data;
  const DropdownButtonOneSellectionChoice({
    required this.fileDocId,
    required this.data,
    super.key,
  });

  @override
  State<DropdownButtonOneSellectionChoice> createState() =>
      _DropdownButtonOneSellectionChoiceState();
}

class _DropdownButtonOneSellectionChoiceState
    extends State<DropdownButtonOneSellectionChoice> {
  //ChangeNameGreenPovider appValueNotifier = ChangeNameGreenPovider();
  @override
  void initState() {
    super.initState();
  }

  void sharePressed() {
    final tracks =
        Provider.of<ChoiseTrackProvider>(context, listen: false).getList();
    print(tracks);
    print(widget.data);
    if (tracks.isNotEmpty) {
      String message = 'Share audio stories';
      List<XFile> pathList = [];
      final List listTracks = widget.data?['tracks'];
      for (int i = 0; i < tracks.length; i++) {
        //int index = listTracks.indexOf(tracks[i]);
        final Map<String, dynamic> value = listTracks[i];
        pathList.add(XFile(value['url']));
      }
      // tracks.map((e) {
      //   // if (e == listTracks .contains(e)) {
      //   int index = listTracks.indexOf(e);
      //   final Map<String, dynamic> value = listTracks[index];
      //   pathList.add(XFile(value['url']));
      //   // }
      // });
      // tracks.forEach((element) {
      //   pathList.add(XFile(element['url']));
      // });
      Share.shareXFiles(pathList);
    }

    //[XFile(widget.data?['tracks'])];
  }

  final List<String> items = [
    'Відмінити вибір',
    'Додати в підбірку',
    'Поділитись',
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
              // print(gappChangeProvider.valueNotifier);
              break;
            case 'Поділитись':
              sharePressed();
              break;
            case 'Видалити':
              FirebaseRepository().deleteSeveralTrackInSellection(
                  widget.fileDocId,
                  Provider.of<ChoiseTrackProvider>(context, listen: false)
                      .getList());
              gappChangeProvider.changeWidgetNotifier(0);
              Navigator.pop(context);

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
