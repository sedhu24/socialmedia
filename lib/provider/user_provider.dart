import 'package:flutter/material.dart';
import 'package:socialmedia/model/user.dart';
import 'package:socialmedia/services/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User _user = const User(
    username: "",
    uid: "",
    photoUrl: "",
    email: "",
    bio: "",
    favorites: [],
    followers: [],
    following: [],
  );
  final AuthMethod authMethod = AuthMethod();

  User get getUser => _user;

  Future<void> refereshUser() async {
    User user = await authMethod.getUserDetails();

    _user = user;
    notifyListeners();
  }
}


// class UserProvider with ChangeNotifier {
//   User? _user;
//   final AuthMethods _authMethods = AuthMethods();

//   User get getUser => _user!;

//   Future<void> refreshUser() async {
//     User user = await _authMethods.getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }