import 'dart:io';

void main() {
  final file = File('android/sha.txt');
  // the file is written in UTF-16LE, let's just read bytes and filter out null bytes
  final bytes = file.readAsBytesSync();
  final fixedBytes = bytes.where((b) => b != 0).toList();
  final text = String.fromCharCodes(fixedBytes);

  var out = '';
  for (var line in text.split('\n')) {
    if (line.contains('SHA')) {
      out += line.trim() + '\n';
    }
  }
  File('keys.txt').writeAsStringSync(out);
}
