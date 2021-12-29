import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/user.dart';
import 'package:final_exam/services/register_services.dart';

class RegisterBloC extends BaseBloC {
  static final RegisterBloC _instance = RegisterBloC._();
  RegisterBloC._() {
    _registerServices = RegisterServices();
  }

  static RegisterBloC getInstance() {
    return _instance;
  }

  late RegisterServices _registerServices;

  late User _registerUserInformation;
  late String _confirmPassword;
  StreamController<bool> _registerButtonController =
      StreamController<bool>.broadcast();

  Stream<bool> get registerButtonState => _registerButtonController.stream;

  set userName(String value) {
    _registerUserInformation.userName = value.trim();
    _registerButtonController.sink.add(
        _registerUserInformation.isFullInformation() &&
            _confirmPassword.length > 0);
  }

  set password(String value) {
    _registerUserInformation.password = value.trim();
    _registerButtonController.sink.add(
        _registerUserInformation.isFullInformation() &&
            _confirmPassword.length > 0);
  }

  set fullName(String value) {
    _registerUserInformation.fullName = value.trim();
    _registerButtonController.sink.add(
        _registerUserInformation.isFullInformation() &&
            _confirmPassword.length > 0);
  }

  set address(String value) {
    _registerUserInformation.address = value.trim();
    _registerButtonController.sink.add(
        _registerUserInformation.isFullInformation() &&
            _confirmPassword.length > 0);
  }

  set email(String value) {
    _registerUserInformation.email = value.trim();
    _registerButtonController.sink.add(
        _registerUserInformation.isFullInformation() &&
            _confirmPassword.length > 0);
  }

  set confirmPassword(String value) {
    _confirmPassword = value.trim();
    _registerButtonController.sink.add(
        _registerUserInformation.isFullInformation() &&
            _confirmPassword.length > 0);
  }

  Future<bool> register() async {
    showLoading();
    if (_registerUserInformation.password != _confirmPassword) {
      hideLoading();
      throw Exception('Nhập lại mật khẩu không đúng.');
    }
    bool isSuccess = await _registerServices.register(_registerUserInformation);
    hideLoading();
    return isSuccess;
  }

  @override
  void dispose() {
    _registerButtonController.close();
    super.dispose();
  }

  @override
  void clearData() {
    _registerUserInformation = User();
    _confirmPassword = '';
    _registerButtonController.sink.add(false);
  }
}
