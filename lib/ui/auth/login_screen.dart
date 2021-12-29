import 'package:final_exam/bloc/login_bloc.dart';
import 'package:final_exam/ui/auth/register_screen.dart';
import 'package:final_exam/ui/home/home_screen.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordNode = FocusNode();
  late LoginBloC _loginBloC;

  @override
  void initState() {
    _loginBloC = LoginBloC.getInstance();
    _loginBloC.clearData();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Theme.of(context).backgroundColor,
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _logo(context),
                  SizedBox(height: 77.0),
                  _buildUserNameInputField(context),
                  SizedBox(height: 18.0),
                  _buildPasswordInputField(context),
                  SizedBox(height: 65.0),
                  _loginButton(context),
                  SizedBox(height: 20.0),
                  _registerButton(context),
                ],
              ),
            ),
          ),
          _loadingState(context),
        ],
      ),
    );
  }

  Widget _buildUserNameInputField(BuildContext context) {
    return TextField(
      controller: _userNameController,
      textInputAction: TextInputAction.go,
      keyboardType: TextInputType.text,
      cursorColor: AppColor.colorDarkBlue,
      decoration: InputDecoration(
        labelText: 'Tên đăng nhập',
        focusColor: AppColor.colorDarkBlue,
        hoverColor: AppColor.colorDarkBlue,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        fillColor: AppColor.colorGreyEE,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            width: 0.8,
            color: AppColor.colorDarkBlue,
          ),
        ),
        isDense: true,
      ),
      onChanged: (userName) => _loginBloC.userName = userName,
      onSubmitted: (_) {
        _passwordNode.requestFocus();
      },
    );
  }

  Widget _buildPasswordInputField(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _loginBloC.hidePasswordState,
        builder: (_, snapshot) {
          return TextField(
            controller: _passwordController,
            focusNode: _passwordNode,
            obscureText: snapshot.data ?? true,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: AppColor.colorDarkBlue,
            decoration: InputDecoration(
              labelText: 'Mật khẩu',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              filled: true,
              fillColor: AppColor.colorGreyEE,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColor.colorDarkBlue,
                ),
              ),
              suffixIcon: InkWell(
                child: Icon(
                  snapshot.data ?? true
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 23,
                ),
                onTap: () {
                  _loginBloC.hidePassword = !(snapshot.data ?? true);
                },
              ),
              isDense: true,
            ),
            onChanged: (password) => _loginBloC.password = password,
          );
        });
  }

  Widget _logo(BuildContext context) {
    return Hero(
      tag: "app_logo",
      child: FlutterLogo(
        size: 150.0,
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _loginBloC.loginButtonState,
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
            onPressed: isEnable ? login : null,
            child: Text(
              'Đăng nhập',
              style: TextStyle(
                color: AppColor.colorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            padding: EdgeInsets.all(0),
          );
        });
  }

  Widget _registerButton(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Chưa có tài khoản? ",
        style: TextStyle(
          color: AppColor.colorBlack,
          fontSize: 14,
        ),
        children: [
          TextSpan(
            text: 'Đăng ký',
            style: TextStyle(
              color: AppColor.colorPrimaryBlue,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
          )
        ],
      ),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _loginBloC.loadingState,
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

  void login() {
    _loginBloC.login().then((userData) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(user: userData)),
          (route) => false);
    }).catchError((error) {
      _loginBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
