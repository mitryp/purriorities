import 'package:flutter/widgets.dart';

import '../data/models/user.dart';

class UserData with ChangeNotifier {
  /// A stored user object.
  /// If null, then no user is logged in.
  User? _user;

  /// A stored session auth token.
  /// Changing this field does not require notifying the listeners.
  String? token;

  /// Returns a current user.
  /// If null, then no user is logged in.
  User? get user => _user;

  /// Sets a new user object notifying listeners.
  /// If the [user] is null, sets the token to null either.
  set user(User? user) {
    _user = user;

    if (user == null) {
      token = null;
    }

    notifyListeners();
  }

  UserData({required User? user, required this.token})
      : _user = user;
}
