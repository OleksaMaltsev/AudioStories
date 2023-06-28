import 'dart:developer';
import 'dart:io';

import 'package:audio_stories/models/user_model.dart';
import 'package:audio_stories/providers/user_sign_up_provider.dart';
import 'package:audio_stories/screens/login/sign_up_thanks.dart';
import 'package:audio_stories/screens/main_page.dart';
import 'package:audio_stories/screens/splash/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseRepository {
  final db = FirebaseFirestore.instance;

  void initValues(String phone) async {
    if (FirebaseAuth.instance.currentUser != null) {
      // set photo
      if (FirebaseAuth.instance.currentUser?.photoURL == null) {
        defaultPhoto();
      }

      //set phone in db
      Map<String, String?> data = {
        "phone": phone,
      };
      db
          .collection("users")
          .doc(
            FirebaseAuth.instance.currentUser?.uid,
          )
          .set(data, SetOptions(merge: true));
    }
  }

  void setValuesInDB(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //set phone,name in db
      Map<String, String?> data = {
        "phone": user.phoneNumber,
        "name": name,
      };
      db
          .collection("users")
          .doc(
            user.uid,
          )
          .set(data, SetOptions(merge: true));
    }
  }

  void deleteUserDB() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var collection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tracks');
      final snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .delete()
          .then(
            (value) => print('User doc delete'),
            onError: (e) => print("Error updating document $e"),
          );
    }
  }

  void changePhoto(File file) async {
    Reference fbStoragePhotoUser =
        FirebaseStorage.instance.ref('/photo-firebase/photo-user.jpg');
    try {
      await fbStoragePhotoUser.putFile(file);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }

    String photoUserPath = await fbStoragePhotoUser.getDownloadURL();
    FirebaseAuth.instance.currentUser?.updatePhotoURL(photoUserPath);
  }

  void defaultPhoto() async {
    Reference fbStoragePhotoUser =
        FirebaseStorage.instance.ref('/photo-firebase/default-user-image.png');
    String photoUserPath = await fbStoragePhotoUser.getDownloadURL();
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(photoUserPath);
  }

  // Future<Track> getTrack() async {
  //   return Track('ff', '/');
  // }

  Future<String> refreshToken() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        IdTokenResult tokenResult = await user.getIdTokenResult();
        String? token = tokenResult.token;

        // // Проверка, истек ли токен
        // if (tokenResult.expirationTime!.isBefore(DateTime.now())) {
        //   // Токен истек или скоро истечет, запросить новый токен
        token = await user.getIdToken(true);
        //}

        return token;
      } catch (e) {
        print('Ошибка обновления токена: $e');
        return '';
      }
    } else {
      return '';
    }
  }

  void saveTrack(Duration duration, String path) {
    if (FirebaseAuth.instance.currentUser != null) {
      final db = FirebaseFirestore.instance;
      final dataTrack = <String, dynamic>{
        'trackName': 'track2',
        'url': path,
        'duration': duration.inSeconds,
      };
      db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('tracks')
          .add(dataTrack);
    }
  }

  // changePhone(String phone, String verifId) async {
  //   try {
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await FirebaseAuth.instance.currentUser
  //             ?.updatePhoneNumber(credential);
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         print(e.message);
  //       },
  //       codeSent: (String verificationId, int? resendToken) async {
  //         String smsCode = '';
  //         final credential = PhoneAuthProvider.credential(
  //             verificationId: verificationId, smsCode: smsCode);
  //         await FirebaseAuth.instance.currentUser
  //             ?.updatePhoneNumber(credential);
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {},
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  void changePhone(String phone, String sms) async {
    //await FirebaseRepository().refreshToken();
    //await FirebaseAuth.instance.currentUser?.getIdToken(true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = sms;

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);
      },
    );
  }

  verifyPhone(BuildContext context, String sms) async {
    String? _verificationCode;
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber:
            Provider.of<UserSignUpProvider>(context, listen: false).userPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushNamedAndRemoveUntil(
                  context, SignUpThanksScreen.routeName, (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          //setState(() {
          _verificationCode = verficationID;
          try {
            FirebaseAuth.instance
                .signInWithCredential(PhoneAuthProvider.credential(
                    verificationId: _verificationCode ?? '123444',
                    smsCode: sms))
                .then((value) async {
              if (value.user != null) {
                FirebaseRepository().initValues(
                    Provider.of<UserSignUpProvider>(context, listen: false)
                        .userPhone);
                Navigator.pushNamed(
                  context,
                  SignUpThanksScreen.routeName,
                );
              }
              print(value.user);
            });
          } catch (e) {
            FocusScope.of(context).unfocus();
            print('invalid OTP');
            print(e);
          }
          //},);
        },
        codeAutoRetrievalTimeout: (String verficationID) {
          //setState(() {
          _verificationCode = verficationID;
          // });
        },
        timeout: const Duration(seconds: 120),
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print('fef');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Невірний код з смс')));
    }
  }
}




// UserApp user = UserApp(
//         uid: FirebaseAuth.instance.currentUser?.uid,
//         phoneNumber: phone,
//         name: 'Введіть імʼя',
//       );
//       Map<String, String?> data;
//       if (user.phoneNumber != null) {
//         data = {
//           "phone": user.phoneNumber,
//         };
//         db.collection("users").doc(user.uid).set(data, SetOptions(merge: true));
//       }