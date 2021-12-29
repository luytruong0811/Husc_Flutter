import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/phone_book.dart';
import 'package:final_exam/services/phone_book_services.dart';

class AddPhoneBookBloC extends BaseBloC {
  static final AddPhoneBookBloC _instance = AddPhoneBookBloC._();
  AddPhoneBookBloC._() {
    _phoneBookServices = PhoneBooksServices();
  }

  static AddPhoneBookBloC getInstance() {
    return _instance;
  }

  late PhoneBooksServices _phoneBookServices;
  late PhoneBook _phoneBook;

  StreamController<bool> _saveButtonController =
      StreamController<bool>.broadcast();

  Stream<bool> get saveButtonState => _saveButtonController.stream;

  set fullName(String value) {
    _phoneBook.fullName = value.trim();
    _saveButtonController.sink.add(_phoneBook.isFullInformation());
  }

  set phoneNumber(String value) {
    _phoneBook.phoneNumber = value.trim();
    _saveButtonController.sink.add(_phoneBook.isFullInformation());
  }

  set address(String value) {
    _phoneBook.address = value.trim();
    _saveButtonController.sink.add(_phoneBook.isFullInformation());
  }

  set region(String value) {
    _phoneBook.region = value.trim();
    _saveButtonController.sink.add(_phoneBook.isFullInformation());
  }

  Future<bool> addPhoneBook() async {
    showLoading();
    bool result = await _phoneBookServices.addPhoneBook(_phoneBook);
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
    _saveButtonController.sink.add(false);
    _phoneBook = PhoneBook();
  }

  @override
  void dispose() {
    _saveButtonController.close();
    super.dispose();
  }
}
