import 'package:audio_stories/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/screens/audio_stories/audio_stories.dart';
import 'package:audio_stories/screens/deleted_tracks/deleted_tracks.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/screens/profile/subscription.dart';
import 'package:audio_stories/screens/search/search.dart';
import 'package:audio_stories/screens/selections/selection.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const CustomDrawer({
    super.key,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            // title
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    'Аудіоказки',
                    style: mainTheme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Меню',
                    style: mainTheme.textTheme.labelLarge?.copyWith(
                      fontSize: 22,
                      color: ColorsApp.colorLightOpacityDark,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView(
                children: [
                  CustomListTile(
                    title: 'Головна',
                    icon: AppIcons.home,
                    navigatorKey: navigatorKey,
                    index: 0,
                    routePath: HomeScreen.routeName,
                  ),
                  CustomListTile(
                    title: 'Профіль',
                    icon: AppIcons.profile,
                    navigatorKey: navigatorKey,
                    index: 4,
                    routePath: ProfileScreen.routeName,
                  ),
                  CustomListTile(
                    title: 'Добірки',
                    icon: AppIcons.category,
                    navigatorKey: navigatorKey,
                    index: 1,
                    routePath: SelectionsScreen.routeName,
                  ),
                  CustomListTile(
                    title: 'Всі аудіофайли',
                    icon: AppIcons.paper,
                    navigatorKey: navigatorKey,
                    index: 3,
                    routePath: AudioStoriesScreen.routeName,
                  ),
                  CustomListTile(
                    title: 'Пошук',
                    icon: AppIcons.search,
                    navigatorKey: navigatorKey,
                    index: 3,
                    routePath: SearchTrackScreen.routeName,
                  ),
                  CustomListTile(
                    title: 'Нещодавно видалені',
                    icon: AppIcons.delete,
                    navigatorKey: navigatorKey,
                    index: 3,
                    routePath: DeletedTracksScreen.routeName,
                  ),
                  const SizedBox(height: 20),
                  CustomListTile(
                    title: 'Підписка',
                    icon: AppIcons.wallet,
                    navigatorKey: navigatorKey,
                    index: 4,
                    routePath: SubscriptionScreen.routeName,
                  ),
                  InkWell(
                    onTap: () async {
                      // String? encodeQueryParameters(
                      //     Map<String, String> params) {
                      //   return params.entries
                      //       .map((MapEntry<String, String> e) =>
                      //           '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                      //       .join('&');
                      // }

                      // final Uri emailUri = Uri(
                      //   scheme: 'mailto',
                      //   path: 'my.email@gmail.com',
                      //   query: encodeQueryParameters(<String, String>{
                      //     'subject': 'Example Subject & Symbols are allowed!',
                      //   }),
                      // );
                      // if (await canLaunchUrl(emailUri)) {
                      //   launchUrl(emailUri);
                      // } else {
                      //   throw Exception(
                      //       'Невдається відкрити email додаток $emailUri');
                      // }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 30, 0, 5),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.edit,
                            width: 30,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Написати в підтримку',
                            style: mainTheme.textTheme.labelMedium?.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // CustomListTile(
                  //   title: 'Написати в підтримку',
                  //   icon: AppIcons.edit,
                  //   navigatorKey: navigatorKey,
                  //   index: 4,
                  //   routePath: ProfileScreen.routeName,
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final String icon;
  final String routePath;
  final GlobalKey<NavigatorState> navigatorKey;
  final int index;
  const CustomListTile({
    required this.title,
    required this.icon,
    required this.routePath,
    required this.navigatorKey,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 10, 0, 5),
      child: InkWell(
        onTap: () {
          Scaffold.of(context).openEndDrawer();
          // navigatorKey.currentState?.pushNamedAndRemoveUntil(
          //   routePath,
          //   (route) => false,
          // );
          context.read<NavigationBloc>().add(
                NavigateTab(
                  tabIndex: index,
                  route: routePath,
                ),
              );
        },
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 30,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: mainTheme.textTheme.labelMedium?.copyWith(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
