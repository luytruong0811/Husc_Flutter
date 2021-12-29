

class PhoneBook {
  String? fullName;
  String? phoneNumber;
  String? address;
  String? region;

  PhoneBook(
      {this.fullName,
      this.phoneNumber,
      this.address,
      this.region});

  PhoneBook.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['region'] = this.region;
    return data;
  }

  bool isFullInformation() {
    if (fullName == null ||
        phoneNumber == null ||
        address == null ||
        region == null
) {
      return false;
    }
    return 
        fullName!.isNotEmpty &&
        phoneNumber!.isNotEmpty &&
        address!.isNotEmpty &&
        region!.isNotEmpty;
  }
}
