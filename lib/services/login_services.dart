import 'package:final_exam/models/user.dart';
import 'package:final_exam/services/user_services.dart';

class LoginServices extends UserServices {
  Future<User> login(String userName, String password) async {
    List<User> listUser = await getListUser();
    int index = listUser.indexWhere((element) =>
        element.userName == userName && element.password == password);
    if (index == -1) {
      throw Exception('Tên đăng nhập hoặc mập khẩu sai.');
    }
    return listUser[index];
  }
}
