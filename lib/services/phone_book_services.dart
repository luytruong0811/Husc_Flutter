import 'dart:convert';

import 'package:final_exam/models/phone_book.dart';
import 'package:final_exam/services/file_services.dart';
import 'package:flutter/services.dart';

//ghi các thông tin của student trong file students.json
class PhoneBooksServices extends FileServices {
  final String fileName = 'phonebooks.json';

  ///lấy data student từ file [phonebooks.json]
  ///trả về default data từ assets nếu không có dữ liệu từ file
  Future<List<PhoneBook>> getListPhoneBooks() async {
    try {
      String data = await readData(fileName);
      List jsonData = json.decode(data);
      return jsonData.map<PhoneBook>((e) => PhoneBook.fromJson(e)).toList();
    } catch (error) {
      String studentData =
          await rootBundle.loadString('assets/json/phone_book_data.json');
      await writeData(fileName, studentData);
      List jsonData = json.decode(studentData);
      return jsonData.map<PhoneBook>((e) => PhoneBook.fromJson(e)).toList();
    }
  }

  Future<bool> addPhoneBook(PhoneBook phoneBook) async {
    List<PhoneBook> listUser = await getListPhoneBooks();
    int index = listUser
        .indexWhere((element) => element.phoneNumber == phoneBook.phoneNumber);
    if (index != -1) {
      throw Exception('Số điện thoại đã tồn tại');
    }
    listUser.insert(0, phoneBook);
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<bool> deletePhoneBook(PhoneBook phoneBook) async {
    List<PhoneBook> listUser = await getListPhoneBooks();
    int index = listUser
        .indexWhere((element) => element.phoneNumber == phoneBook.phoneNumber);
    if (index == -1) {
      throw Exception('Số điện thoại không tồn tại');
    }
    listUser.removeAt(index);
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<bool> editPhoneBook(PhoneBook phoneBook) async {
    List<PhoneBook> listUser = await getListPhoneBooks();
    int index = listUser
        .indexWhere((element) => element.phoneNumber == phoneBook.phoneNumber);
    listUser[index] = phoneBook;
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }
}
