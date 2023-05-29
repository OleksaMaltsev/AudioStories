import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/change_choose_provider.dart';
import 'package:audio_stories/screens/profile/widgets/custom_box_subscription.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/appBar/custom_app_bar.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'package:audio_stories/widgets/buttons/orange_button.dart';
import 'package:audio_stories/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});
  static const String routeName = '/subscription';

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: PurplePainter(),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Column(
              children: [
                const CustomAppBar(
                  leading: null,
                  title: 'Підписка',
                  subTitle: 'Розширюй можливості',
                  actions: SizedBox(),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorsApp.colorWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(25, 0, 0, 0),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 20,
                        ),
                        child: Text(
                          'Обери підписку',
                          style: mainTheme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          Expanded(
                            child: CustomBoxSubscription(
                              price: '300 грн',
                              time: 'в місяць',
                              choose:
                                  Provider.of<ChangeChooseProvider>(context),
                              index: 0,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomBoxSubscription(
                              price: '1800 грн',
                              time: 'на рік',
                              choose:
                                  Provider.of<ChangeChooseProvider>(context),
                              index: 1,
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(30, 30, 0, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Що дає підписка:',
                              style: mainTheme.textTheme.labelSmall?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.cilInfinity,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Необмежена пам\'ять',
                                    style: mainTheme.textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.cilCloudUpload,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Усі файли знаходяться у хмарі',
                                    style: mainTheme.textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.paperDownload,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Можливість качати без обмежень',
                                    style: mainTheme.textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        child: Provider.of<ChangeChooseProvider>(context)
                                .chooses[0]
                            ? OrangeButton(
                                text: 'Підписатись на місяць',
                                function: () {},
                              )
                            : OrangeButton(
                                text: 'Підписатись на рік',
                                function: () {},
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
