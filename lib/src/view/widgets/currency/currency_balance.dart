import 'package:flutter/material.dart';

import '../../../common/enums/currency.dart';
import 'currency_info.dart';

class CurrencyBalance extends StatelessWidget {
  final int commonCurrencyBalance;
  final int rareCurrencyBalance;

  const CurrencyBalance({
    required this.commonCurrencyBalance,
    required this.rareCurrencyBalance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CurrencyInfo(quantity: commonCurrencyBalance, currency: Currency.feed),
        CurrencyInfo(quantity: rareCurrencyBalance, currency: Currency.catnip),
      ],
    );
  }
}
