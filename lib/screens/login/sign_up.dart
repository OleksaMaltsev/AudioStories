import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/screens/home_screen.dart';
import 'package:audio_stories/screens/login/sign_up_sms.dart';
import 'package:audio_stories/screens/main_page.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:audio_stories/widgets/buttons/orange_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'widgets/description_sing_up_widget.dart';
import 'widgets/phone_input_formatter_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String routeName = '/sign_up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController phoneController = TextEditingController();
  TextEditingController smsController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? _verificationCode;

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
                              keyboardType: TextInputType.number,
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
                          //todo: remove sms verif
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
                              keyboardType: TextInputType.number,
                              controller: smsController,
                              textAlign: TextAlign.center,
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
                        ],
                      ),
                      const SizedBox(height: 50),
                      OrangeButton(
                        text: 'Продовжити',
                        function: () async {
                          _verifyPhone();
                          // try {
                          //   await FirebaseAuth.instance
                          //       .signInWithCredential(
                          //           PhoneAuthProvider.credential(
                          //               verificationId:
                          //                   _verificationCode ?? '000000',
                          //               smsCode: smsController.text))
                          //       .then((value) async {
                          //     if (value.user != null) {
                          //       Navigator.pushNamed(
                          //         context,
                          //         SignUpSmsScreen.routeName,
                          //       );
                          //     }
                          //     print(value.user);
                          //   });
                          // } catch (e) {
                          //   FocusScope.of(context).unfocus();
                          //   print('invalid OTP');
                          //   print(e);
                          // }
                        },
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            SignUpSmsScreen.routeName,
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

  _verifyPhone() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        //phoneNumber: '+380 99 391 1133',
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
            try {
              FirebaseAuth.instance
                  .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _verificationCode ?? '000000',
                      smsCode: smsController.text))
                  .then((value) async {
                if (value.user != null) {
                  Navigator.pushNamed(
                    context,
                    SignUpSmsScreen.routeName,
                  );
                }
                print(value.user);
              });
            } catch (e) {
              FocusScope.of(context).unfocus();
              print('invalid OTP');
              print(e);
            }
          });
        },
        codeAutoRetrievalTimeout: (String verficationID) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        timeout: const Duration(seconds: 120),
      );
    } on FirebaseAuthException catch (e) {
      print('fe');
      print(e.code);
    }
  }
}
