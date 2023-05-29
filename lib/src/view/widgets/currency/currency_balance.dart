import 'package:flutter/material.dart';

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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CurrencyInfo(quantity: commonCurrencyBalance, currency: Currency.common),
        const SizedBox(width: 20),
        CurrencyInfo(quantity: rareCurrencyBalance, currency: Currency.rare),
      ],
    );
  }
}
