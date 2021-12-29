import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/user.dart';
import 'package:final_exam/services/login_services.dart';

class LoginBloC extends BaseBloC {
  static final LoginBloC _instance = LoginBloC._();
  LoginBloC._() {
    _loginServices = LoginServices();
  }

  static LoginBloC getInstance() {
    return _instance;
  }

  late LoginServices _loginServices;

  String? _userName;
  String? _password;
  StreamController<bool> _loginButtonController =
      StreamController<bool>.broadcast();
  StreamController<bool> _hidePasswordController =
      StreamController<bool>.broadcast();

  Stream<bool> get hidePasswordState => _hidePasswordController.stream;
  Stream<bool> get loginButtonState => _loginButtonController.stream;

  set hidePassword(bool value) => _hidePasswordController.sink.add(value);

  set userName(String value) {
    _userName = value.trim();
    _loginButtonController.sink
        .add(_userName!.length > 0 && _password!.length > 0);
  }

  set password(String value) {
    _password = value.trim();
    _loginButtonController.sink
        .add(_userName!.length > 0 && _password!.length > 0);
  }

  Future<User> login() async {
    showLoading();
    User user = await _loginServices.login(_userName!, _password!);
    hideLoading();
    return user;
  }

  @override
  void dispose() {
    _hidePasswordController.close();
    _loginButtonController.close();
    super.dispose();
  }

  @override
  void clearData() {
    _userName = '';
    _password = '';
    _hidePasswordController.sink.add(true);
    _loginButtonController.sink.add(false);
  }
}
