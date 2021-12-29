import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class FileServices {
  Future<String> readData(String fileName) async {
    String path = await _localPath;
    File file = File('$path/$fileName');
    return file.readAsStringSync(encoding: utf8);
  }

  Future<File> writeData(String fileName, dynamic data) async {
    String path = await _localPath;
    File file = File('$path/$fileName');
    String jsonData = json.encode(data);
    return file.writeAsString(jsonData);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    bool isExist = await directory.exists();
    if (!isExist) {
      throw Exception('File không tồn tại');
    }
    return directory.path;
  }
}
