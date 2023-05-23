import 'dart:developer';

import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier {
  String _email = '';

  String _password = '';

  String _nickname = '';

  String get email => _email;

  set email(String value) {
    _email = value;
    log('new email is $value');
    notifyListeners();
  }

  String get password => _password;

  set password(String value) {
    _password = value;
    log('new password is $value');
    notifyListeners();
  }

  String get nickname => _nickname;

  set nickname(String value) {
    _nickname = value;
    log('new nickname is $value');
    notifyListeners();
  }
}
