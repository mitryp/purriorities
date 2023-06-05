import 'dart:developer';

import 'package:flutter/material.dart';

/// A single value implementation of the [ChangeNotifier] mixin with a predefined behavior for
/// exposing and editing any data.
///
/// It will not notify listeners if the new [data] is equal to the previously set one.
class NotifierWrapper<T> with ChangeNotifier {
  /// Whether this wrapper should check if the object has actually changed before notifying the
  /// listeners.
  final bool checkEquality;
  T _data;

  NotifierWrapper(this._data, {this.checkEquality = true});

  T get data => _data;

  set data(T value) {
    if (checkEquality && _data == value) return;

    _data = value;
    notifyListeners();

    log('Changed the wrapped $T: $_data', name: 'NotifierWrapper');
  }
}
