import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/login/widgets/phone_input_formatter_widget.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audio_stories/widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import 'package:flutter/material.dart';

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Builder(
                      builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: ColorsApp.colorWhite,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          'Профіль',
                          style: mainTheme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Твоя частинка',
                          style: mainTheme.textTheme.labelMedium?.copyWith(
                            color: ColorsApp.colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
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
                onPressed: () {},
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
      drawer: Drawer(),
      bottomNavigationBar: const BottomNavBarWidget(recordItem: false),
    );
  }
}
