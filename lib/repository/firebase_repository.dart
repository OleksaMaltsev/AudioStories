import 'package:audio_stories/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  final db = FirebaseFirestore.instance;

  void initValues() {
    if (FirebaseAuth.instance.currentUser != null) {
      UserApp user = UserApp(
        uid: FirebaseAuth.instance.currentUser?.uid,
        phoneNumber: '',
        name: 'Введіть імʼя',
      );
      Map<String, String?> data;
      if (user.phoneNumber != null) {
        data = {
          "phone": user.phoneNumber,
        };
        db.collection("users").doc(user.uid).set(data, SetOptions(merge: true));
      }
    }
  }

  Future<Track> getTrack() async {
    return Track('ff', '/');
  }
}

class Track {
  final String title;
  final String url;

  Track(this.title, this.url);
}
