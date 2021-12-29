import 'package:final_exam/bloc/register_bloc.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  FocusNode _passwordNode = FocusNode();
  FocusNode _confirmPasswordNode = FocusNode();
  FocusNode _fullNameNode = FocusNode();
  FocusNode _addressNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  late RegisterBloC _registerBloC;

  @override
  void initState() {
    _registerBloC = RegisterBloC.getInstance();
    _registerBloC.clearData();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordNode.dispose();
    _confirmPasswordNode.dispose();
    _fullNameNode.dispose();
    _addressNode.dispose();
    _emailNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Stack(
        children: [
          Scaffold(
            appBar: _buildAppBar(context),
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _logo(context),
                        SizedBox(height: 77.0),
                        textField(
                          context,
                          controller: _userNameController,
                          labelText: 'Tên đăng nhập',
                          onChanged: (value) => _registerBloC.userName = value,
                          onSubmitted: (value) {
                            _fullNameNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _fullNameController,
                          focusNode: _fullNameNode,
                          labelText: 'Họ và tên',
                          onChanged: (value) => _registerBloC.fullName = value,
                          onSubmitted: (value) {
                            _emailNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _emailController,
                          focusNode: _emailNode,
                          labelText: 'Email',
                          onChanged: (value) => _registerBloC.email = value,
                          onSubmitted: (value) {
                            _addressNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _addressController,
                          focusNode: _addressNode,
                          labelText: 'Địa chỉ',
                          onChanged: (value) => _registerBloC.address = value,
                          onSubmitted: (value) {
                            _passwordNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _passwordController,
                          focusNode: _passwordNode,
                          labelText: 'Mật khẩu',
                          obscureText: true,
                          onChanged: (value) => _registerBloC.password = value,
                          onSubmitted: (value) {
                            _confirmPasswordNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordNode,
                          labelText: 'Nhập lại mật khẩu',
                          obscureText: true,
                          onChanged: (value) =>
                              _registerBloC.confirmPassword = value,
                          onSubmitted: (value) {},
                        ),
                        SizedBox(height: 65.0),
                      ],
                    ),
                  ),
                ),
                _registerButton(context),
              ],
            ),
          ),
          _loadingState(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      leading: BackButton(),
      title: Text(
        'Đăng ký tài khoản',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _logo(BuildContext context) {
    return Hero(
      tag: "app_logo",
      child: FlutterLogo(
        size: 150.0,
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: AppColor.colorWhite,
      child: StreamBuilder<bool>(
          stream: _registerBloC.registerButtonState,
          builder: (_, snapshot) {
            bool isEnable = snapshot.data ?? false;
            return MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              disabledColor: AppColor.colorGrey97,
              minWidth: double.infinity,
              height: 54,
              color: AppColor.colorDarkBlue,
              onPressed: isEnable ? register : null,
              child: Text(
                'Đăng ký',
                style: TextStyle(
                  color: AppColor.colorWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              padding: EdgeInsets.all(0),
            );
          }),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _registerBloC.loadingState,
        builder: (_, snapshot) {
          bool isLoading = snapshot.data ?? false;
          if (isLoading) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColor.colorGrey97.withOpacity(0.5),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox.shrink();
        });
  }

  void register() {
    _registerBloC.register().then((sucess) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Đăng ký');
        },
      ).then((_) {
        Navigator.pop(context);
      });
    }).catchError((error) {
      _registerBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
