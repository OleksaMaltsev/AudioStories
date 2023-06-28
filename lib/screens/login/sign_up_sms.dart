import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/providers/user_sign_up_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/login/sign_up.dart';
import 'package:audio_stories/screens/login/sign_up_thanks.dart';
import 'package:audio_stories/screens/main_page.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audio_stories/widgets/buttons/orange_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'widgets/description_sing_up_widget.dart';
import 'widgets/sms_input_formatter_widget.dart';

class SignUpSmsScreen extends StatefulWidget {
  const SignUpSmsScreen({
    super.key,
  });

  static const String routeName = '/sign_up_sms';

  @override
  State<SignUpSmsScreen> createState() => _SignUpSmsScreenState();
}

class _SignUpSmsScreenState extends State<SignUpSmsScreen> {
  TextEditingController smsController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String? _verificationCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: CustomPaint(
          painter: PurplePainter(),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  'Реєстрація',
                  style: mainTheme.textTheme.titleLarge?.copyWith(fontSize: 48),
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
                          cursorColor: ColorsApp.colorLightOpacityDark,
                          keyboardType: TextInputType.number,
                          controller: smsController,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 5),
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
                          FirebaseRepository()
                              .verifyPhone(context, smsController.text.trim());
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
    );
  }
}
