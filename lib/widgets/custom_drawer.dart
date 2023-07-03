import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/screens/deleted_tracks/deleted_tracks.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/screens/profile/subscription.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                    routePath: HomeScreen.routeName,
                  ),
                  CustomListTile(
                    title: 'Профіль',
                    icon: AppIcons.profile,
                    navigatorKey: navigatorKey,
                    routePath: ProfileScreen.routeName,
                  ),
                  CustomListTile(
                    title: 'Добірки',
                    icon: AppIcons.category,
                    navigatorKey: navigatorKey,
                    routePath: ProfileScreen.routeName,
                  ),
                  CustomListTile(
                    title: 'Всі аудіофайли',
                    icon: AppIcons.paper,
                    navigatorKey: navigatorKey,
                    routePath: ProfileScreen.routeName,
                  ),
                  CustomListTile(
                    title: 'Пошук',
                    icon: AppIcons.search,
                    navigatorKey: navigatorKey,
                    routePath: ProfileScreen.routeName,
                  ),
                  CustomListTile(
                    title: 'Нещодавно видалені',
                    icon: AppIcons.delete,
                    navigatorKey: navigatorKey,
                    routePath: DeletedTracksScreen.routeName,
                  ),
                  SizedBox(height: 20),
                  CustomListTile(
                    title: 'Підписка',
                    icon: AppIcons.wallet,
                    navigatorKey: navigatorKey,
                    routePath: SubscriptionScreen.routeName,
                  ),
                  SizedBox(height: 20),
                  CustomListTile(
                    title: 'Написати в підтримку',
                    icon: AppIcons.edit,
                    navigatorKey: navigatorKey,
                    routePath: ProfileScreen.routeName,
                  ),
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
  const CustomListTile({
    required this.title,
    required this.icon,
    required this.routePath,
    required this.navigatorKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 10, 0, 5),
      child: InkWell(
        onTap: () {
          Scaffold.of(context).openEndDrawer();
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            routePath,
            (route) => false,
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
