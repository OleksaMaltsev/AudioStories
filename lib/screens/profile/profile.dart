import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/login/widgets/phone_input_formatter_widget.dart';
import 'package:audio_stories/screens/profile/profile_edit.dart';
import 'package:audio_stories/screens/profile/subscription.dart';
import 'package:audio_stories/screens/splash/splash.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/appBar/custom_app_bar.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

abstract class Kolesa {}

class Car extends Kolesa {}

class Bike extends Kolesa {}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController smsController = TextEditingController();
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        SplashScreen.routeName,
        (_) => false,
      );
    }
  }

  void deleteAccount() async {
    //await FirebaseRepository().refreshToken();
    //await FirebaseAuth.instance.currentUser?.getIdToken(true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: FirebaseAuth.instance.currentUser?.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        setState(() {});
        await smsAcceptDialog(context);

        String smsCode = smsController.text;
        Future.delayed(const Duration(seconds: 5));
        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await FirebaseAuth.instance.signInWithCredential(credential);

        FirebaseRepository().deleteUserDB();
        await FirebaseAuth.instance.currentUser?.delete();

        if (FirebaseAuth.instance.currentUser == null) {
          if (mounted) {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              SplashScreen.routeName,
              (_) => false,
            );
          }
        }
      },
    );
  }

  void efef() {}

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
                    //allowDeleteDialog(context);
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

  allowDeleteDialog(BuildContext contexScreen) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          contentPadding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
          title: const Text('Точно видалити акаунт?'),
          content: const Text(
              'Всі аудіофайли зникнуть та відновити акаунт буде неможливо'),
          actionsPadding: const EdgeInsets.only(bottom: 24),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    deleteAccount();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsApp.colorLightRed,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Видалити',
                      style: mainTheme.textTheme.labelMedium
                          ?.copyWith(color: ColorsApp.colorWhite),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
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
                      'Ні',
                      style: mainTheme.textTheme.labelMedium
                          ?.copyWith(color: ColorsApp.colorPurple),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
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
                      leading: null,
                      title: 'Профіль',
                      subTitle: 'Твоя частинка',
                      actions: SizedBox(),
                    ),
                    // user photo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        FirebaseAuth.instance.currentUser?.photoURL ??
                            'https://static.vecteezy.com/system/resources/thumbnails/005/545/335/small/user-sign-icon-person-symbol-human-avatar-isolated-on-white-backogrund-vector.jpg',
                        width: 180,
                      ),
                    ),
                    // user name
                    Text(
                        FirebaseAuth.instance.currentUser?.displayName ??
                            'Користувач',
                        style: mainTheme.textTheme.labelLarge),
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
                        readOnly: true,
                        initialValue:
                            FirebaseAuth.instance.currentUser?.phoneNumber ??
                                '',
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
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ProfileEditScreen.routeName);
                      },
                      child: Text('Редагувати',
                          style: mainTheme.textTheme.labelSmall),
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
                        Text('150/500 мб',
                            style: mainTheme.textTheme.labelSmall),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () async {
                            signOut();
                          },
                          child: Text('Вийти з додатка',
                              style: mainTheme.textTheme.labelSmall),
                        ),
                        TextButton(
                          onPressed: () {
                            allowDeleteDialog(context);
                          },
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
          );
        });
  }
}
