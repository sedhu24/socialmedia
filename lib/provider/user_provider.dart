import 'package:flutter/material.dart';
import 'package:socialmedia/model/user.dart';
import 'package:socialmedia/services/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethod authMethod = AuthMethod();

  User get getUser => _user!;

  Future<void> refereshUser() async {
    User user = await authMethod.getUserDetails();

    _user = user;
    notifyListeners();
  }
}
