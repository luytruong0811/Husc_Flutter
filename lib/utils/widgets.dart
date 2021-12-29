import 'package:final_exam/utils/app_color.dart';
import 'package:flutter/material.dart';

Widget textField(
  BuildContext context, {
  TextEditingController? controller,
  FocusNode? focusNode,
  String? labelText,
  bool readOnly = false,
  bool obscureText = false,
  int? maxLength,
  TextInputType keyboardType = TextInputType.text,
  TextCapitalization textCapitalization = TextCapitalization.none,
  void Function(String value)? onChanged,
  void Function(String value)? onSubmitted,
}) {
  return TextField(
    controller: controller,
    focusNode: focusNode,
    obscureText: obscureText,
    readOnly: readOnly,
    textInputAction: TextInputAction.go,
    maxLength: maxLength,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    cursorColor: AppColor.colorDarkBlue,
    decoration: InputDecoration(
      labelText: labelText,
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
      counterText: '',
      isDense: true,
    ),
    onChanged: onChanged,
    onSubmitted: onSubmitted,
  );
}
