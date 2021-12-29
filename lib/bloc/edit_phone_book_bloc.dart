import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/phone_book.dart';
import 'package:final_exam/services/phone_book_services.dart';

class EditPhoneBookBloC extends BaseBloC {
  static final EditPhoneBookBloC _instance = EditPhoneBookBloC._();
  EditPhoneBookBloC._() {
     _phoneBookServices = PhoneBooksServices();
  }

  static EditPhoneBookBloC getInstance() {
    return _instance;
  }

  late PhoneBooksServices _phoneBookServices;
  late PhoneBook _phoneBook;

  set phoneBook(PhoneBook value) {
    _phoneBook = value;
  }

  set fullName(String fullName) {
    _phoneBook.fullName = fullName;
  }

  set phoneNumber(String phoneNumber) {
    _phoneBook.phoneNumber = phoneNumber;
  }

  set address(String address) {
    _phoneBook.address = address;
  }

  set region(String region) {
    _phoneBook.region = region;
  }

  Future<bool> updatePhoneBook() async {
    showLoading();
    bool result = await _phoneBookServices.editPhoneBook(_phoneBook);
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
