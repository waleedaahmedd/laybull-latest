// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'package:laybull_v3/providers/currency_provider.dart';

extension CurrencyCoversion on double {
  double convertToLocal(BuildContext context) {
    double result = double.parse((this * context.read<CurrencyProvider>().localCurrency).toStringAsFixed(2));
    return result;
    // return (this * context.read<CurrencyProvider>().localCurrency);
  }

  double convertToEuro(BuildContext context) {
    double result = double.parse((this / context.read<CurrencyProvider>().localCurrency).toStringAsFixed(2));
    return result;
    // return (this / context.read<CurrencyProvider>().localCurrency);
  }
}
