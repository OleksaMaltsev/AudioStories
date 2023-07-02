import 'dart:developer';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:audio_stories/models/user_model.dart';
import 'package:audio_stories/providers/user_sign_up_provider.dart';
import 'package:audio_stories/screens/login/sign_up_thanks.dart';
import 'package:audio_stories/screens/main_page.dart';
import 'package:audio_stories/screens/splash/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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

  void setNewTrackName(String name, String trackUrl) async {
    String trackId = '';
    await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tracks")
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          if (data['url'] == trackUrl) {
            trackId = docSnapshot.id;
          }
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //set phone,name in db
      Map<String, String?> data = {
        "trackName": name,
      };
      db
          .collection("users")
          .doc(
            user.uid,
          )
          .collection('tracks')
          .doc(trackId)
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

  void saveTrack(Duration duration, String path, String name, String track) {
    if (FirebaseAuth.instance.currentUser != null) {
      final db = FirebaseFirestore.instance;
      final dataTrack = <String, dynamic>{
        'trackName': name,
        'url': track,
        'duration': duration.inSeconds,
        'date': Timestamp.now(),
      };
      db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('tracks')
          .add(dataTrack);
    }
  }

  void saveSellection(String photo, String name, String? description,
      List<Map<String, dynamic>>? tracks) {
    if (FirebaseAuth.instance.currentUser != null) {
      final String descriptionSellection = description ?? '';
      final db = FirebaseFirestore.instance;
      if (tracks != null) {
        final dataSellection = <String, dynamic>{
          'sellectionName': name,
          'description': descriptionSellection,
          'photo': photo,
          'date': Timestamp.now(),
          'tracks': tracks,
        };
        db
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('sellections')
            .add(dataSellection);
      } else {
        final dataSellection = <String, dynamic>{
          'sellectionName': name,
          'description': descriptionSellection,
          'photo': photo,
          'date': Timestamp.now(),
        };
        db
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('sellections')
            .add(dataSellection);
      }
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllSellections() {
    final db = FirebaseFirestore.instance;
    final dataStream = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("sellections")
        .get();
    return dataStream;
  }

  Future<Map<String, dynamic>> getTrackForDb(String docId) async {
    Map<String, dynamic> nameTrack = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tracks')
        .doc(docId)
        .get()
        .then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'trackName': data['trackName'],
          'url': data['url'],
          'duration': data['duration'],
        };
      },
      onError: (e) => print("Error getting document: $e"),
    );
    print(nameTrack);
    return nameTrack;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTrack() {
    final db = FirebaseFirestore.instance;
    final dataStream = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tracks")
        .get();
    return dataStream;
  }

  Future<String> saveImageInStorage(File file) async {
    final uuid = Uuid();
    Reference fbStoragePhotoSellection =
        FirebaseStorage.instance.ref('/image-firebase/${uuid.v1()}.jpg');
    try {
      await fbStoragePhotoSellection.putFile(file);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
    return await fbStoragePhotoSellection.getDownloadURL();
  }

  Future<String?> getTrackDocID(String trackUrl) async {
    await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tracks")
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          if (data['url'] == trackUrl) {
            return docSnapshot.id;
          }
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
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