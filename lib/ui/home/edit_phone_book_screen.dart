import 'package:final_exam/bloc/edit_phone_book_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/phone_book.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class EditPhoneBookScreen extends StatefulWidget {
  final PhoneBook phoneBook;
  const EditPhoneBookScreen({Key? key, required this.phoneBook}) : super(key: key);

  @override
  _EditPhoneBookScreenState createState() => _EditPhoneBookScreenState();
}

class _EditPhoneBookScreenState extends State<EditPhoneBookScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _regionController = TextEditingController();
  FocusNode _phoneNumberNode = FocusNode();
  FocusNode _addressNode = FocusNode();
  FocusNode _regionNode = FocusNode();
  EditPhoneBookBloC _editBloC = EditPhoneBookBloC.getInstance();
  late PhoneBook phoneBook;

  @override
  void initState() {
    _editBloC.clearData();
    _editBloC.phoneBook = widget.phoneBook;
    phoneBook = widget.phoneBook;
    _fullNameController.text =
        '${phoneBook.fullName}';
    _phoneNumberController.text = '${phoneBook.phoneNumber}';
    _addressController.text = '${phoneBook.address}';
    _regionController.text = '${phoneBook.region}';
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _regionController.dispose();
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
                          labelText: 'Họ và tên',
                          keyboardType: TextInputType.text,
                          onChanged: (value) => _editBloC.fullName =value,
                          onSubmitted: (value) {
                            _phoneNumberNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _phoneNumberController,
                          focusNode: _phoneNumberNode,
                          labelText: 'Số điện thoại',
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          onChanged: (value) => _editBloC.phoneNumber =value,
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
                          keyboardType: TextInputType.text,
                          onChanged: (value) => _editBloC.address = value,
                          onSubmitted: (value) {
                            _regionNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _regionController,
                          focusNode: _regionNode,
                          labelText: 'Vùng',
                          keyboardType: TextInputType.text,
                          onChanged: (value) => _editBloC.region = value,
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
        'Thông tin học sinh',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: AppColor.colorWhite,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        disabledColor: AppColor.colorGrey97,
        minWidth: double.infinity,
        height: 54,
        color: AppColor.colorDarkBlue,
        onPressed: updatePhoneBook,
        child: Text(
          'Cập nhật',
          style: TextStyle(
            color: AppColor.colorWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        padding: EdgeInsets.all(0),
      ),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _editBloC.loadingState,
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

  void updatePhoneBook() {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    _editBloC.updatePhoneBook().then((success) {
      HomeBloC.getInstance().getListPhoneBook();
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Cập nhật');
        },
      ).then((value) => Navigator.pop(context));
    }).catchError((error) {
      _editBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
