import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/phone_book.dart';
import 'package:final_exam/ui/home/edit_phone_book_screen.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneBookItem extends StatefulWidget {
  final Animation<double> animation;
  final PhoneBook phoneBook;
  final Function()? onRemoved;
  const PhoneBookItem(
      {Key? key,
      required this.phoneBook,
      required this.animation,
      this.onRemoved})
      : super(key: key);

  @override
  _PhoneBookItemState createState() => _PhoneBookItemState();
}

class _PhoneBookItemState extends State<PhoneBookItem> {
  late PhoneBook phoneBook;
  @override
  void initState() {
    phoneBook = widget.phoneBook;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      axis: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Color(0xff141A1A1A),
              blurRadius: 32,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '''${phoneBook.fullName}''',
                    style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                _buildButton(context, 'Sửa', editPhoneBook,
                    color: AppColor.colorGreen),
                SizedBox(width: 5.0),
                _buildButton(context, 'Xoá', deletePhoneBook,
                    color: AppColor.colorRed),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              'Số điện thoại: ${phoneBook.phoneNumber}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            ),
            Text(
              'Địa chỉ: ${phoneBook.address}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            ),
            Text(
              'Vùng: ${phoneBook.region}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String label, void Function()? onPressed,
      {Color color = AppColor.colorGreen}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        elevation: 0.0,
      ),
      child: Text(label),
    );
  }

  void editPhoneBook() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => EditPhoneBookScreen(phoneBook: phoneBook)));
  }

  void deletePhoneBook() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return confirmDialog(
            context, 'Xoá', 'Bạn chắc chắn muốn xoá danh bạ này?');
      },
    ).then((acceptDelete) {
      if (acceptDelete ?? false) {
        HomeBloC.getInstance().deletePhoneBook(phoneBook).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(StringUtil.stringFromException(error))));
        });
        if (widget.onRemoved != null) {
          widget.onRemoved!.call();
        }
      }
    });
  }
}
