import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/phone_book.dart';
import 'package:final_exam/services/phone_book_services.dart';

class HomeBloC extends BaseBloC {
  static final HomeBloC _instance = HomeBloC._();
  HomeBloC._() {
    _phoneBooksServices = PhoneBooksServices();
  }

  static HomeBloC getInstance() {
    return _instance;
  }

  late PhoneBooksServices _phoneBooksServices;

  StreamController<List<PhoneBook>> _listPhoneBooksController =
      StreamController<List<PhoneBook>>.broadcast();

  Stream<List<PhoneBook>> get listPhoneBooksStream => _listPhoneBooksController.stream;

  Future<List<PhoneBook>> getListPhoneBook() async {
    List<PhoneBook> list = await _phoneBooksServices.getListPhoneBooks();
    _listPhoneBooksController.sink.add(list);
    return list;
  }

  Future<bool> deletePhoneBook(PhoneBook phoneBook) async {
    bool deleteSuccess = await _phoneBooksServices.deletePhoneBook(phoneBook);
    await getListPhoneBook();
    return deleteSuccess;
  }

  @override
  void clearData() {}

  @override
  void dispose() {
    _listPhoneBooksController.close();
    super.dispose();
  }
}
