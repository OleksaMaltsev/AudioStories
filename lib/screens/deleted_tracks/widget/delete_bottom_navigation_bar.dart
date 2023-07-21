import 'package:audio_stories/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/helpers/snack_bar_helper.dart';
import 'package:audio_stories/models/track_and_sellection_id.dart';
import 'package:audio_stories/providers/choise_tracks_provider.dart';
import 'package:audio_stories/providers/choise_tracks_recovery_provider.dart';
import 'package:audio_stories/providers/delete_list_provider.dart';
import 'package:audio_stories/providers/recovery_list_provider.dart';
import 'package:audio_stories/providers/sellection_value_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/deleted_tracks/deleted_tracks.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DeleteBottomNavigationBar extends StatelessWidget {
  const DeleteBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102.h,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: ColorsApp.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            spreadRadius: 5,
            blurRadius: 15,
            offset: Offset(7, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              final List<TrackAndSellectionId> list =
                  Provider.of<ChoiseTrackRecoveryProvider>(context,
                          listen: false)
                      .getList();
              if (list.isNotEmpty) {
                FirebaseRepository().recoveryTracks(tracks: list);
                print(list);
                context.read<NavigationBloc>().add(
                      NavigateTab(
                        tabIndex: 3,
                        route: DeletedTracksScreen.routeName,
                      ),
                    );
              } else {
                SnackBarHelper().getSnackBar(context, 'Виберіть треки');
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.swap,
                ),
                Text(
                  'Відновити все',
                  style: mainTheme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              final List<TrackAndSellectionId> list =
                  Provider.of<ChoiseTrackRecoveryProvider>(context,
                          listen: false)
                      .getList();
              if (list.isNotEmpty) {
                final List<String> listDocId = [];
                final List<String> trackId = [];
                list.forEach((element) {
                  listDocId.add(element.idSellection);
                  trackId.add(element.idTrack);
                });
                FirebaseRepository().deleteTrackAllOver(listDocId, trackId);
                print(list);
                context.read<NavigationBloc>().add(
                      NavigateTab(
                        tabIndex: 3,
                        route: DeletedTracksScreen.routeName,
                      ),
                    );
              } else {
                SnackBarHelper().getSnackBar(context, 'Виберіть треки');
              }
              // final list =
              //     Provider.of<DeleteListProvider>(context, listen: false)
              //         .getList();
              // if (list.isNotEmpty) {
              //   FirebaseRepository()
              //       .deleteTrackAllOver([widget.fileDocId!], [widget.trackId]);
              // }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.delete,
                ),
                Text(
                  'Видалити все',
                  style: mainTheme.textTheme.labelSmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
