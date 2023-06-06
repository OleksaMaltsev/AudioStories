import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/providers/user_sign_up_provider.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/login/sign_up_sms.dart';
import 'package:audio_stories/screens/main_page.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audio_stories/widgets/buttons/orange_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/description_sing_up_widget.dart';
import 'widgets/phone_input_formatter_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String routeName = '/sign_up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();

    super.dispose();
  }

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
                        'Введи номер телефона',
                        style: mainTheme.textTheme.labelMedium,
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: [
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
                              //initialValue: '+38 ',
                              keyboardType: TextInputType.phone,
                              controller: phoneController,
                              textAlign: TextAlign.center,
                              //inputFormatters: [PhoneInputFormatter()],
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
                          const SizedBox(height: 24),
                        ],
                      ),
                      const SizedBox(height: 50),
                      OrangeButton(
                        text: 'Продовжити',
                        function: () async {
                          userGlobal = phoneController.text;
                          Navigator.pushNamed(
                              context, SignUpSmsScreen.routeName);
                        },
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpSmsScreen(),
                            ),
                          );
                        },
                        //+380 99 391 1133
                        child: Text(
                          'Пропустити',
                          style: mainTheme.textTheme.labelLarge,
                        ),
                      ),
                      const SizedBox(height: 30),
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
