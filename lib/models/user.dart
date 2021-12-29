class User {
  String? userName;
  String? password;
  String? fullName;
  String? address;
  String? email;

  User({this.userName, this.password, this.fullName, this.address, this.email});

  User.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    password = json['password'];
    fullName = json['fullName'];
    address = json['address'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['fullName'] = this.fullName;
    data['address'] = this.address;
    data['email'] = this.email;
    return data;
  }

  bool isFullInformation() {
    if (userName == null ||
        password == null ||
        fullName == null ||
        address == null ||
        email == null) {
      return false;
    }
    return userName!.length > 0 &&
        password!.length > 0 &&
        fullName!.length > 0 &&
        address!.length > 0 &&
        email!.length > 0;
  }
}
