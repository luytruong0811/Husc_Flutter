import 'package:final_exam/models/user.dart';
import 'package:final_exam/services/user_services.dart';

class RegisterServices extends UserServices {
  Future<bool> register(User user) async {
    List<User> listUser = await getListUser();
    int index =
        listUser.indexWhere((element) => element.userName == user.userName);
    if (index != -1) {
      throw Exception('Tài khoản đã tồn tại.');
    }
    listUser.add(user);
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }
}
