import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/list_model.dart';
import 'package:final_exam/models/phone_book.dart';
import 'package:final_exam/models/user.dart';
import 'package:final_exam/ui/auth/login_screen.dart';
import 'package:final_exam/ui/home/add_phone_book_screen.dart';
import 'package:final_exam/ui/home/phone_book_item.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  HomeBloC _homeBloC = HomeBloC.getInstance();
  late ListModel<PhoneBook> _list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: AppColor.colorGreyF5F5F7,
      body: FutureBuilder<List<PhoneBook>>(
          future: _homeBloC.getListPhoneBook(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // if (snapshot.hasError) {
            //   return Center(
            //     child: Text('Đã có lỗi xảy ra.'),
            //   );
            // }
            return StreamBuilder<List<PhoneBook>>(
                stream: _homeBloC.listPhoneBooksStream,
                initialData: snapshot.data,
                builder: (__, listSnapshot) {
                  if (listSnapshot.data!.isEmpty) {
                    return Center(
                      child: Text('Danh sách danh bạ rỗng.'),
                    );
                  }
                  _list = ListModel<PhoneBook>(
                    listKey: _listKey,
                    initialItems: listSnapshot.data!,
                    removedItemBuilder: (context, item, animation) =>
                        PhoneBookItem(
                      phoneBook: item,
                      animation: animation,
                    ),
                  );
                  return AnimatedList(
                    key: _listKey,
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 60.0),
                    initialItemCount: listSnapshot.data!.length,
                    itemBuilder: (context, index, animation) {
                      return PhoneBookItem(
                        key: Key('student ${_list[index].phoneNumber}'),
                        phoneBook: _list[index],
                        animation: animation,
                        onRemoved: () {
                          _list.removeAt(index);
                        },
                      );
                    },
                  );
                });
          }),
      floatingActionButton: _addPhoneBookButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.colorGreyF5F5F7,
      title: Text(
        'Quản lý danh bạ điện thoại',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () => logout(context),
          child: Text('Đăng xuất'),
        ),
      ],
    );
  }

  Widget _addPhoneBookButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddPhoneBookScreen()));
      },
      backgroundColor: AppColor.colorDarkBlue,
      child: Icon(
        Icons.add,
        color: AppColor.colorWhite,
      ),
    );
  }

  void logout(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return confirmDialog(
            context, 'Đăng xuất', 'Bạn chắc chắn muốn đăng xuất?');
      },
    ).then((acceptLogout) {
      if (acceptLogout ?? false) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
      }
    });
  }
}
