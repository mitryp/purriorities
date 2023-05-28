import 'dart:developer';

import 'package:flutter/material.dart';

/// A single value implementation of the [ChangeNotifier] mixin with a predefined behavior for
/// exposing and editing any data.
///
/// It will not notify listeners if the new [data] is equal to the previously set one.
class NotifierWrapper<T> with ChangeNotifier {
  T _data;

  NotifierWrapper(this._data);

  T get data => _data;

  set data(T value) {
    if (_data == value) return;
    _data = value;
    notifyListeners();
    log('Changed the wrapped $T: $_data', name: 'NotifierWrapper');
  }
}