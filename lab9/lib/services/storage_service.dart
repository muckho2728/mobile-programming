import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/data.json');
  }

  Future<List> readData() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        await file.writeAsString(jsonEncode([]));
      }
      String content = await file.readAsString();
      return jsonDecode(content);
    } catch (e) {
      return [];
    }
  }

  Future<void> writeData(List data) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(data));
  }
}