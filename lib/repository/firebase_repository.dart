class FirebaseRepository {
  Future<Track> getTrack() async {
    return Track('ff', '/');
  }
}

class Track {
  final String title;
  final String url;

  Track(this.title, this.url);
}
