import 'package:audio_stories/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/change_name_track.dart';
import 'package:audio_stories/providers/sellection_value_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/deleted_tracks/deleted_tracks.dart';
import 'package:audio_stories/screens/deleted_tracks/deleted_tracks_choice.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DropdownDeleteMenu extends StatefulWidget {
  final List<String> items;
  const DropdownDeleteMenu({
    required this.items,
    super.key,
  });

  @override
  State<DropdownDeleteMenu> createState() => _DropdownDeleteMenuState();
}

class _DropdownDeleteMenuState extends State<DropdownDeleteMenu> {
  ChangeNamePovider appValueNotifier = ChangeNamePovider();

  // final List<String> items = [
  //   'Вибрати декілька',
  //   'Видалити все',
  //   'Відновити все',
  // ];

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
        items: widget.items
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
              // Navigator.pushNamedAndRemoveUntil(
              //   context,
              //   DeletedTracksChoiceScreen.routeName,
              //   (route) => false,
              // );
              if (context.read<NavigationBloc>().state.currentIndex != 5) {
                context.read<NavigationBloc>().add(
                      NavigateTab(
                        tabIndex: 5,
                        route: DeletedTracksChoiceScreen.routeName,
                      ),
                    );
              }
              break;
            case 'Видалити все':

              //widget.providerName.changeWidgetNotifier(1);
              FirebaseRepository().deleteTrackAllOver(null, null);
              context.read<NavigationBloc>().add(
                    NavigateTab(
                      tabIndex: 3,
                      route: DeletedTracksScreen.routeName,
                    ),
                  );
              break;
            case 'Відновити все':
              FirebaseRepository().recoveryTracks(tracks: null);
              context.read<NavigationBloc>().add(
                    NavigateTab(
                      tabIndex: 3,
                      route: DeletedTracksScreen.routeName,
                    ),
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
            ...List<double>.filled(widget.items.length, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}
