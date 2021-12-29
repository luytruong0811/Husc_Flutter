import 'package:final_exam/ui/auth/login_screen.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Final Exam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0.0,
          iconTheme: IconThemeData(color: AppColor.colorDarkBlue),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColor.colorDarkBlue,
        ),
        platform: TargetPlatform.iOS,
      ),
      home: LoginScreen(),
    );
  }
}
