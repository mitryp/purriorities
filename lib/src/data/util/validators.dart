import 'package:flutter/material.dart';

typedef FieldValidator = String? Function(String?);

FieldValidator all(List<FieldValidator> validators) {
  return (s) {
    for (final validator in validators) {
      final error = validator(s);
      if (error != null) return error;
    }

    return null;
  };
}

FieldValidator any(List<FieldValidator> validators) {
  return (s) {
    String? error;
    for (final validator in validators) {
      error = validator(s);
      if (error == null) return null;
    }
    return error;
  };
}

FieldValidator get noValidation => (s) => null;

FieldValidator get notEmpty => (s) => s?.isEmpty ?? true ? 'Поле не має бути порожнім' : null;

FieldValidator hasLength(int length) => all([notEmpty, (s) => _exactLengthValidator(s, length)]);

FieldValidator get isInteger => all([notEmpty, _integerValidator]);

FieldValidator optional(FieldValidator validator) {
  return (s) {
    if (s?.isEmpty ?? true) return null;
    return validator(s);
  };
}

FieldValidator get isPositiveInteger => all([
      isInteger,
      (s) => _positiveIntegerValidator(int.parse(s!)),
    ]);

FieldValidator get isNonNegativeInteger => all([
      isInteger,
      (s) => _nonNegativeIntegerValidator(int.parse(s!)),
    ]);

FieldValidator isIntegerInRange(int min, int max) => all([
      isInteger,
      (s) => _rangeIntegerValidator(int.parse(s!), min, max),
    ]);

FieldValidator get isCurrencyValue => all([
      notEmpty,
      isNonNegativeDouble,
      (s) => _nonNegativeCurrencyValidator(s!),
    ]);

FieldValidator get isDouble => all([notEmpty, _doubleValidator]);

FieldValidator get isNonNegativeDouble => all([
      notEmpty,
      isDouble,
      (s) => _nonNegativeDoubleValidator(double.parse(s!)),
    ]);

FieldValidator get isPhoneNumber => all([
      startsWith('+'),
      hasLength(13),
      (s) => isInteger(s!.replaceFirst('+', '')),
    ]);

FieldValidator isLongerOrEqual(int minLength) {
  return all([
    notEmpty,
    (s) {
      if (s!.trim().length >= minLength) return null;

      return 'Стрічка повинна бути не коротшою, ніж $minLength символів';
    },
  ]);
}

FieldValidator repeatPasswordValidator(TextEditingController passwordController) => (value) {
      if (passwordController.text == value) return null;

      return 'Паролі повинні співпадати';
    };

FieldValidator get usernameValidator => all([
      notEmpty,
      (s) {
        final normalized = s!.trim();
        final match = RegExp(r'\w+').matchAsPrefix(normalized);

        if (match != null) return null;

        return 'Стрічка може містити латиницю, цифри та підкреслення';
      }
    ]);

FieldValidator get isEmail => all([
      notEmpty,
      (s) {
        final normalized = s!.trim();
        final match = RegExp(r'^[\w.+-]*[\w+-]@([\w.-]+\.)+\w+$').matchAsPrefix(normalized);

        if (match != null) return null;
        return 'Стрічка повинна бути валідною адресою ел. пошти';
      },
    ]);

FieldValidator startsWith(String pattern) =>
    all([notEmpty, (s) => _startsWithValidator(s, pattern)]);

String? _nonNegativeCurrencyValidator(String pattern) {
  final match = RegExp(r'^\d+(\.\d{1,2})?\s*$').matchAsPrefix(pattern);

  return match == null ? 'Число може містити один або два знаки після коми' : null;
}

String? _rangeIntegerValidator(int value, int min, int max) =>
    value >= min && value <= max ? null : 'Число повинно знаходитися в межах від $min до $max';

String? _startsWithValidator(String? s, String pattern) =>
    !s!.startsWith(pattern) ? 'Стрічка повинна починатися з "$pattern"' : null;

String? _exactLengthValidator(String? s, int length) =>
    s!.length != length ? 'Довжина поля повинна складати $length символів' : null;

String? _integerValidator(String? s) =>
    int.tryParse(s!) == null ? 'Значення повинно бути цілим числом' : null;

String? _positiveIntegerValidator(int n) => n <= 0 ? 'Число повинно бути більшим за 0' : null;

String? _nonNegativeIntegerValidator(int n) => n < 0 ? 'Число повинно бути не меншим за 0' : null;

String? _doubleValidator(String? s) =>
    double.tryParse(s!) == null ? 'Значення повинно бути дробовим числом' : null;

String? _nonNegativeDoubleValidator(double n) => n < 0 ? 'Число не повинно бути меншим за 0' : null;
