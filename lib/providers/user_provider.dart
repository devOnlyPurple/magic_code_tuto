import 'package:flutter/material.dart';
import 'package:kondjigbale/models/user.dart';

class UsersProvider with ChangeNotifier {
  static final UsersProvider _instance = UsersProvider._internal();

  factory UsersProvider() {
    return _instance;
  }

  UsersProvider._internal();
  User? _userResponse;
  User get userResponse => _userResponse!;

  set userInfo(User userResponse) {
    _userResponse = userResponse;
    print(_userResponse!.nom);
    notifyListeners();
  }
  // void makeUser(){

  // }
}
