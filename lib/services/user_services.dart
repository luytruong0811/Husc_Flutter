import 'dart:convert';

import 'package:final_exam/models/user.dart';
import 'package:final_exam/services/file_services.dart';

//ghi các thông tin của user trong file users.json
class UserServices extends FileServices {
  final String fileName = 'users.json';

  Future<List<User>> getListUser() async {
    try {
      String data = await readData(fileName);
      List jsonData = json.decode(data);
      return jsonData.map<User>((e) => User.fromJson(e)).toList();
    } catch (error) {
      return [];
    }
  }
}
