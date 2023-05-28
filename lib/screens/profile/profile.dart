import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/login/widgets/phone_input_formatter_widget.dart';
import 'package:audio_stories/screens/main_screen.dart';
import 'package:audio_stories/screens/profile/subscription.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/appBar/custom_app_bar.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'package:audio_stories/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: CustomPaint(
          painter: PurplePainter(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const CustomAppBar(
                leading: null,
                title: 'Профіль',
                subTitle: 'Твоя частинка',
                actions: SizedBox(),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/smiley-man-relaxing-outdoors.jpeg',
                  width: 180,
                ),
              ),
              Text('Микола', style: mainTheme.textTheme.labelLarge),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 24, 30, 10),
                height: 59,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: ColorsApp.colorWhite,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(25, 0, 0, 0),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextFormField(
                  readOnly: true,
                  initialValue: '+38 099 333 22 11',
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [PhoneInputFormatter()],
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                    border: InputBorder.none,
                  ),
                  style: mainTheme.textTheme.labelMedium?.copyWith(
                    fontSize: 20,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child:
                    Text('Редагувати', style: mainTheme.textTheme.labelSmall),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    SubscriptionScreen.routeName,
                  );
                },
                child: Text(
                  'Підписка',
                  style: mainTheme.textTheme.labelSmall
                      ?.copyWith(decoration: TextDecoration.underline),
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 250,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 2,
                        color: ColorsApp.colorOriginalBlack,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: double.infinity,
                          width: 250 * 0.3,
                          decoration: const BoxDecoration(
                            color: ColorsApp.colorButtonOrange,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('150/500 мб', style: mainTheme.textTheme.labelSmall),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('Вийти з додатка',
                        style: mainTheme.textTheme.labelSmall),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Видалити акаунт',
                      style: mainTheme.textTheme.labelSmall
                          ?.copyWith(color: ColorsApp.colorLightRed),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
