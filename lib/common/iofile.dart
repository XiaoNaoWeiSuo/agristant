import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  final String filename;
  CounterStorage({required this.filename});
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<Map<String, dynamic>> readCounter() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      return {};
    }
  }

  Future<File> writeCounter(var counter) async {
    final file = await _localFile;
    return file.writeAsString(jsonEncode(counter));
  }
}