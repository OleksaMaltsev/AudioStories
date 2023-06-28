import 'dart:io';

import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/login/widgets/phone_input_formatter_widget.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/screens/profile/subscription.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/appBar/custom_app_bar.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});
  static const String routeName = '/profile-edit';

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final nameTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final verifIdFieldController = TextEditingController();
  TextEditingController smsController = TextEditingController();
  final String? oldPhone = FirebaseAuth.instance.currentUser?.phoneNumber;

  void saveChanges() async {
    if (FirebaseAuth.instance.currentUser != null &&
        nameTextController.text.isNotEmpty) {
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(nameTextController.text);
      if (phoneTextController.text.isEmpty) {
        if (mounted) {
          Navigator.popAndPushNamed(context, ProfileScreen.routeName);
        }
      }
    }
    if (phoneTextController.text.isNotEmpty) {
      changePhone();
    }
  }

  void changePhone() async {
    //await FirebaseRepository().refreshToken();
    //await FirebaseAuth.instance.currentUser?.getIdToken(true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneTextController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        //await FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        print(e.credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        setState(() {});
        await smsAcceptDialog(context);
        String smsCode = smsController.text;
        Future.delayed(const Duration(seconds: 8));
        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);
        FirebaseRepository().initValues(phoneTextController.text);
      },
    );
  }

  // displayDialog(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('TextField AlertDemo'),
  //         content: TextField(
  //           controller: verifIdFieldController,
  //           decoration: InputDecoration(hintText: "TextField in Dialog"),
  //         ),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             child: Text('SUBMIT'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  smsAcceptDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          contentPadding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
          title: const Text(
            'Введіть смс код для підтведження',
            textAlign: TextAlign.center,
          ),
          actionsPadding: const EdgeInsets.only(bottom: 24),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsApp.colorWhite,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 1,
                        color: ColorsApp.colorPurple,
                      ),
                    ),
                    child: Text(
                      'Ок',
                      style: mainTheme.textTheme.labelMedium
                          ?.copyWith(color: ColorsApp.colorPurple),
                    ),
                  ),
                ),
              ],
            ),
          ],
          content: TextFormField(
            cursorColor: ColorsApp.colorLightOpacityDark,
            keyboardType: TextInputType.number,
            controller: smsController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: ColorsApp.colorLightDark),
                borderRadius: BorderRadius.circular(50.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: ColorsApp.colorLightDark),
                borderRadius: BorderRadius.circular(50.0),
              ),
              contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
            ),
            style: mainTheme.textTheme.labelMedium?.copyWith(
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }

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
              CustomAppBar(
                contextScreen: context,
                leading: InkWell(
                  onTap: () {
                    FirebaseRepository().defaultPhoto();
                    Navigator.pop(
                      context,
                      (route) => false,
                    );
                  },
                  child: SvgPicture.asset(AppIcons.back),
                ),
                title: 'Профіль',
                subTitle: 'Твоя частинка',
                actions: SizedBox(),
              ),
              // user photo
              InkWell(
                onTap: () async {
                  if (await Permission.photosAddOnly.request().isGranted) {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      File file = File(result.files.single.path!);
                      print('path:${file.path}');
                      FirebaseRepository().changePhoto(file);
                    }
                  }
                },
                child: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.userChanges(),
                    builder: (context, snapshot) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Image.network(
                              FirebaseAuth.instance.currentUser?.photoURL ??
                                  'https://static.vecteezy.com/system/resources/thumbnails/005/545/335/small/user-sign-icon-person-symbol-human-avatar-isolated-on-white-backogrund-vector.jpg',
                              width: 180,
                              color: Colors.black45.withOpacity(0.4),
                              colorBlendMode: BlendMode.darken,
                            ),
                            Positioned(
                              left: 60,
                              top: 60,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.5,
                                    color: ColorsApp.colorWhite,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.camera,
                                  width: 50,
                                  color: ColorsApp.colorWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              // user name
              SizedBox(
                width: 200,
                child: TextField(
                  controller: nameTextController,
                  textAlign: TextAlign.center,
                  style: mainTheme.textTheme.labelLarge,
                  decoration: const InputDecoration(
                    hintText: 'Введіть своє імʼя',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsApp.colorLightDark),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsApp.colorLightDark),
                    ),
                  ),
                  cursorColor: ColorsApp.colorLightOpacityDark,
                  cursorHeight: 25,
                  cursorWidth: 1,
                ),
              ),
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
                // user phone
                child: TextFormField(
                  controller: phoneTextController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [PhoneInputFormatter()],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                    border: InputBorder.none,
                    hintText:
                        FirebaseAuth.instance.currentUser?.phoneNumber ?? '',
                  ),
                  style: mainTheme.textTheme.labelMedium?.copyWith(
                    fontSize: 20,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  saveChanges();

                  FirebaseRepository()
                      .setValuesInDB(nameTextController.text.trim());
                  FirebaseAuth.instance.userChanges().listen((user) {
                    if (user != null && user.phoneNumber != oldPhone) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, ProfileScreen.routeName, (route) => false);
                    }
                  });
                },
                child: Text('Зберегти', style: mainTheme.textTheme.labelMedium),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
