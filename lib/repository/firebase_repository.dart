import 'dart:developer';
import 'dart:io';
import 'package:audio_stories/models/big_track_model.dart';
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
  final currentUser = FirebaseAuth.instance.currentUser?.uid;
  final fbStorageRef = FirebaseStorage.instance.ref();

  final dbConnectSellection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("sellections");

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

  // void setNewTrackNameInSellection(
  //     String name, String trackId, String sellectionId) async {
  //   String trackId = '';
  //   final sellectionResult = await db
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection("sellection")
  //       .doc(sellectionId);
  //   sellectionResult
  //       .get()
  //       .then((value) {
  //         final data = value.data();
  //         if (data != null) {
  //           final List list = data['tracks'];
  //           list.map(
  //             (item) {
  //               if (item['id'] == trackId) {
  //                 item['id'];
  //               }
  //             },
  //           );
  //         }
  //       })
  //       .get()
  //       .then(
  //         (querySnapshot) {
  //           print("Successfully completed");
  //           for (var docSnapshot in querySnapshot.docs) {
  //             final data = docSnapshot.data();
  //             if (data['url'] == trackUrl) {
  //               trackId = docSnapshot.id;
  //             }
  //             //print('${docSnapshot.id} => ${docSnapshot.data()}');
  //           }
  //         },
  //         onError: (e) => print("Error completing: $e"),
  //       );
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     //set phone,name in db
  //     Map<String, String?> data = {
  //       "trackName": name,
  //     };
  //     db
  //         .collection("users")
  //         .doc(
  //           user.uid,
  //         )
  //         .collection('tracks')
  //         .doc(trackId)
  //         .set(data, SetOptions(merge: true));
  //   }
  // }

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

  Map<String, dynamic> saveTrack(Duration duration, String path, String name,
      String track, String storagePath) {
    if (FirebaseAuth.instance.currentUser != null) {
      final db = FirebaseFirestore.instance;
      String docRefId = '';
      final dataTrack = <String, dynamic>{
        'trackName': name,
        'url': track,
        'duration': duration.inSeconds,
        'date': Timestamp.now(),
        'storagePath': storagePath,
      };
      db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('tracks')
          .add(dataTrack)
          .then((docRef) {
        db
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('tracks')
            .doc(docRef.id)
            .set({'id': docRef.id}, SetOptions(merge: true));
      });
      return dataTrack;
    } else {
      return {};
    }
  }

  void deleteTrack(List<String> listDocId) async {
    // for (String id in listIdSellection) {
    //   // delete track with sellection
    //   final sellection = db
    //       .collection('users')
    //       .doc(currentUser)
    //       .collection('sellections')
    //       .doc(id);
    //   await sellection.get().then((value) {
    //     final data = value.data();
    //     final List list = data?['tracks'];
    //     list.map((item) => item['id'] == id ? print('yes') : print('no'));
    //   }); //.update({'idSellection': FieldValue.delete()});
    // }
    for (String id in listDocId) {
      final track =
          db.collection('users').doc(currentUser).collection('tracks').doc(id);

      // delete with db
      await track.delete();
    }
  }

  void deleteTrackInSellection(String sellectionId, String trackId) async {
    final sellectionResult = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("sellections")
        .doc(sellectionId);

    List data;
    sellectionResult.get().then((value) async {
      data = await value.data()?['tracks'];
      // (value.data()?['tracks'] as List)
      //     .removeWhere((element) => element['id'] == trackId);
      // value.data()?['tracks'] = [];
      for (int i = 0; i < data.length; i++) {
        if (data[i]['id'] == trackId) {
          //value.data()?['tracks'][i] = [];
          sellectionResult.set({
            'tracks': FieldValue.arrayRemove(
              [data[i]],
            )
          }, SetOptions(merge: true));
        }
      }
    });
  }

  void deleteTrackAllOver(List<String>? listDocId, List<String> idTrack) async {
    if (listDocId == null) return;
    for (String id in listDocId) {
      final track =
          db.collection('users').doc(currentUser).collection('delete').doc(id);
      //delete with storage
      await track.get().then((value) {
        final data = value.data();
        for (String item in idTrack) {
          if (data?[item] != null) {
            final Map<String, dynamic> currentTrack = data?[item];
            final storageRef = currentTrack?['storagePath'];
            final desertRef = fbStorageRef.child(storageRef);
            desertRef.delete();
            track.update({item: FieldValue.delete()});
          }
        }
      }, onError: (e) => print("Error getting document: $e"));
    }
  }

  Future<void> onTrackUpload({
    required String trackName,
    required String? sellectionName,
    required Duration duration,
    required String pathTrack,
    required String? imagePath,
  }) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final appDirectory = await getApplicationDocumentsDirectory();
    final pathAudio = "${appDirectory.path}/recording.m4a";
    final String storageDerectoryPath = 'upload-voice-firebase/$trackName.m4a';

    try {
      final putFile = await firebaseStorage
          .ref('upload-voice-firebase')
          .child('${trackName}.m4a')
          .putFile(File(pathAudio));

      final trackUrl = await putFile.ref.getDownloadURL();
      final trackMap = FirebaseRepository().saveTrack(
          duration, pathTrack, trackName, trackUrl, storageDerectoryPath);

      if (sellectionName != null &&
          sellectionName.isNotEmpty &&
          imagePath != null) {
        FirebaseRepository()
            .saveSellection(imagePath, sellectionName, null, [trackMap]);
      }
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
    }
  }

  void saveSellection(String photo, String name, String? description,
      List<Map<String, dynamic>>? tracks) async {
    if (FirebaseAuth.instance.currentUser != null) {
      final String descriptionSellection = description ?? '';
      final db = FirebaseFirestore.instance;
      String? docSellectId;
      String id;
      List<String> tracksId = [];
      if (tracks != null) {
        final dataSellection = <String, dynamic>{
          'sellectionName': name,
          'description': descriptionSellection,
          'photo': photo,
          'date': Timestamp.now(),
          'tracks': tracks
        };

        //    final String idTrack = tracks.map((item) => item['id']);
        await db
            .collection('users')
            .doc(currentUser)
            .collection('sellections')
            .add(dataSellection)
            .then((docRef) {
          docSellectId = docRef.id;

          // db
          //     .collection('users')
          //     .doc(currentUser)
          //     .collection('tracks') //.collection('sellections')
          //     .doc()
          //     .set({
          //tracks
          // 'tracks': tracks.map((e) {
          //   final finalData = e;
          //   finalData['idSellection'] = [docRef.id];
          //   return finalData;
          // })
        });
      } else {
        final dataSellection = <String, dynamic>{
          'sellectionName': name,
          'description': descriptionSellection,
          'photo': photo,
          'date': Timestamp.now(),
        };
        db
            .collection('users')
            .doc(currentUser)
            .collection('sellections')
            .add(dataSellection);
      }
    }
  }

  void deleteSellections(List<String> list) {
    for (String id in list) {
      db
          .collection('users')
          .doc(currentUser)
          .collection('sellections')
          .doc(id)
          .delete();
    }
  }

  void transferForDeleteSellection(BigTrackModel track, String date) {
    if (FirebaseAuth.instance.currentUser != null) {
      final db = FirebaseFirestore.instance;
      String docRefId = '';
      final dataTrack = <String, dynamic>{
        'trackName': track.name,
        'url': track.path,
        'duration': track.duration,
        'date': track.dateTime,
        'storagePath': track.storagePath,
        'id': track.id,
      };
      db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('delete')
          .doc(date)
          .set({track.id: dataTrack}, SetOptions(merge: true));
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

  Map<String, dynamic> getTrackSellection(String docId) {
    final db = FirebaseFirestore.instance;
    Map<String, dynamic> data = {};
    final dataStream = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tracks")
        .doc(docId);

    dataStream.get().then((doc) {
      data = doc.data() as Map<String, dynamic>;
      print(data);
    });
    return data;
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getSellectionSnapshot() {
    final dbConnect = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("sellections")
        .snapshots();
    return dbConnect;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTrackSnapshot() {
    final dbConnect = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tracks")
        .snapshots();
    return dbConnect;
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
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Невірний номер телефону або код з смс')));
        },
        codeSent: (String? verficationID, int? resendToken) {
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
          }
          //},);
        },
        codeAutoRetrievalTimeout: (String verficationID) {
          //setState(() {
          _verificationCode = verficationID;
          // });
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print('fef');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Невірний код з смс')));
    }
  }
}
