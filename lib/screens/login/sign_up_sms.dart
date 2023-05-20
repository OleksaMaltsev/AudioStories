import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/login/sign_up_thanks.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audio_stories/widgets/buttons/orange_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/description_sing_up_widget.dart';
import 'widgets/phone_input_formatter_widget.dart';
import 'widgets/sms_input_formatter_widget.dart';

class SignUpSmsScreen extends StatefulWidget {
  const SignUpSmsScreen({super.key});

  static const String routeName = '/sign_up_sms';

  @override
  State<SignUpSmsScreen> createState() => _SignUpSmsScreenState();
}

class _SignUpSmsScreenState extends State<SignUpSmsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: CustomPaint(
          painter: PurplePainter(),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Реєстрація',
                    style:
                        mainTheme.textTheme.titleLarge?.copyWith(fontSize: 48),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 150, 50, 0),
                    child: Column(
                      children: [
                        Text(
                          'Введи код із смс, щоб ми тебе запам\'ятали',
                          style: mainTheme.textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
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
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [SmsInputFormatter()],
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(15, 15, 15, 5),
                              border: InputBorder.none,
                            ),
                            style: mainTheme.textTheme.labelMedium?.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        OrangeButton(
                          text: 'Продовжити',
                          function: () {
                            Navigator.pushNamed(
                              context,
                              SignUpThanksScreen.routeName,
                            );
                          },
                        ),
                        const SizedBox(height: 60),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ColorsApp.colorWhite,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(25, 0, 0, 0),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const DescriptionISingUpWidget(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
