import 'package:file_saver/file_saver.dart';

void saveAsTrack(List<String> list) async {
  for (int i = 0; i < list.length; i++) {
    await FileSaver.instance.saveAs(
      ext: 'm4a',
      mimeType: MimeType.aac,
      name: 'audio',
      filePath: list[i],
    );
  }
}
