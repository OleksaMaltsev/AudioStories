class UserApp {
  String? uid;
  String? phoneNumber;
  String? name;

  UserApp({this.uid, this.phoneNumber, this.name});

  sf() {
    UserSingleton.instance.setNumberPhone = '';
  }
}

class UserSingleton {
  UserSingleton._();
  static final instance = UserSingleton._();
  String? _uid;
  String? _numberPhone;
  String? _name;

  set setUid(String uid) => _uid = uid;
  get getUid => _uid;

  set setNumberPhone(String number) => _numberPhone = number;
  get getNumber => _numberPhone;

  set setName(String name) => _name = name;
  get getName => _name;
}
