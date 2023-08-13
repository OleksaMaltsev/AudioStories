import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AudioHelper {
  const AudioHelper._();

  static String formatTime({required Duration duration}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      minutes,
      seconds,
    ].join(':');
  }

  static Future<Map<String, dynamic>> getNameTrackForDb(String docId) async {
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
          'id': data['id'],
          'storagePath': data['storagePath'],
        };
      },
      onError: (e) => print("Error getting document: $e"),
    );
    print(nameTrack);
    return nameTrack;
  }

  static Future<List<Map<String, dynamic>>> setTracksInSellection(
      List listWithDocId) async {
    List<Map<String, dynamic>> listMap = [];
    for (String value in listWithDocId) {
      listMap.add(await getNameTrackForDb(value));
    }
    return listMap;
  }
}
