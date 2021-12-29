import 'package:final_exam/bloc/add_phone_book_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddPhoneBookScreen extends StatefulWidget {
  const AddPhoneBookScreen({Key? key}) : super(key: key);

  @override
  _AddPhoneBookScreenState createState() => _AddPhoneBookScreenState();
}

class _AddPhoneBookScreenState extends State<AddPhoneBookScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _regionController = TextEditingController();
  FocusNode _fullNameNode = FocusNode();
  FocusNode _phoneNumberNode = FocusNode();
  FocusNode _addressNode = FocusNode();
  FocusNode _regionNode = FocusNode();
  late AddPhoneBookBloC _addPhoneBookBloC;

  @override
  void initState() {
    _addPhoneBookBloC = AddPhoneBookBloC.getInstance();
    _addPhoneBookBloC.clearData();
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    _fullNameNode.dispose();
    _phoneNumberNode.dispose();
    _addressNode.dispose();
    _regionNode.dispose();
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textField(
                          context,
                          controller: _fullNameController,
                          focusNode: _fullNameNode,
                          labelText: 'Họ và tên',
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 60,
                          onChanged: (value) =>
                              _addPhoneBookBloC.fullName = value,
                          onSubmitted: (value) {
                            _phoneNumberNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _phoneNumberController,
                          focusNode: _phoneNumberNode,
                          keyboardType: TextInputType.number,
                          labelText: 'Số điện thoại',
                          maxLength: 10,
                          onChanged: (value) => _addPhoneBookBloC.phoneNumber = value,
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
                          textCapitalization: TextCapitalization.words,
                          maxLength: 50,
                          onChanged: (value) => _addPhoneBookBloC.address = value,
                          onSubmitted: (value) {
                            _regionNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _regionController,
                          focusNode: _regionNode,
                          labelText: 'Vùng mạng',
                          keyboardType: TextInputType.text,
                          onChanged: (value) =>
                              _addPhoneBookBloC.region = value,
                          onSubmitted: (value) {},
                        ),
                        SizedBox(height: 18.0),
                      ],
                    ),
                  ),
                ),
                _saveButton(context),
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
        'Thêm học sinh',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: AppColor.colorWhite,
      child: StreamBuilder<bool>(
          stream: _addPhoneBookBloC.saveButtonState,
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
              onPressed: isEnable ? addPhoneBook : null,
              child: Text(
                'Thêm',
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
        stream: _addPhoneBookBloC.loadingState,
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

  void addPhoneBook() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    _addPhoneBookBloC.addPhoneBook().then((sucess) {
      HomeBloC.getInstance().getListPhoneBook();
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Thêm danh bạ');
        },
      ).then((_) {
        Navigator.pop(context);
      });
    }).catchError((error) {
      _addPhoneBookBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
