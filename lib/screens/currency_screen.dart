// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

class CurrencyScreen extends StatefulWidget {
  @override
  _CurrencyScreenState createState() => _CurrencyScreenState();
}

// ignore: constant_identifier_names
enum CurrencyCharacter { AED, BHD, KWD, USD, OMR, QAR, SAR, INR }

class _CurrencyScreenState extends State<CurrencyScreen> {
// ...

  CurrencyCharacter _character = CurrencyCharacter.AED;
  @override
  void initState() {
    checkSelectedCurrency();
    super.initState();
  }

  checkSelectedCurrency() {
    if (cSymbol == 'AED') {
      return _character = CurrencyCharacter.AED;
    }
    if (cSymbol == 'BHD') {
      return _character = CurrencyCharacter.BHD;
    }
    if (cSymbol == 'KWD') {
      return _character = CurrencyCharacter.KWD;
    }
    if (cSymbol == 'USD') {
      return _character = CurrencyCharacter.USD;
    }
    if (cSymbol == 'OMR') {
      return _character = CurrencyCharacter.OMR;
    }
    if (cSymbol == 'QAR') {
      return _character = CurrencyCharacter.QAR;
    }
    if (cSymbol == 'SAR') {
      return _character = CurrencyCharacter.SAR;
    }
    if (cSymbol == 'INR') {
      return _character = CurrencyCharacter.INR;
    }
  }

  @override
  Widget build(BuildContext context) {
    var changeCurrency = context.read<CurrencyProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(AppLocalizations.of(context).translate('currencies').toUpperCase(), style: headingStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 15.h),
          Text(
            AppLocalizations.of(context).translate('changeAppCurrencies').toUpperCase(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 2.w,
              fontFamily: "MetropolisExtraBold",
            ),
          ),
          SizedBox(height: 10.h),
          RadioListTile<CurrencyCharacter>(
            title: Text(
              AppLocalizations.of(context).translate('uaeDirham'),
            ),
            value: CurrencyCharacter.AED,
            groupValue: _character,
            onChanged: (value) async {
              var pref = await SharedPreferences.getInstance();
              pref.setString('currencySymbol', 'AED');
              setState(() {
                _character = value!;
                changeCurrency.selectedCurrency = 'AED';
                cSymbol = 'AED';
                changeCurrency.setCurrency();
              });
            },
          ),
          RadioListTile<CurrencyCharacter>(
            title: Text(
              "Bahraini dinar",
            ),
            value: CurrencyCharacter.BHD,
            groupValue: _character,
            onChanged: (value) async {
              var pref = await SharedPreferences.getInstance();
              pref.setString('currencySymbol', 'BHD');
              setState(() {
                _character = value!;
                changeCurrency.selectedCurrency = 'BHD';
                cSymbol = 'BHD';
                changeCurrency.setCurrency();
              });
            },
          ),
          RadioListTile<CurrencyCharacter>(
            title: Text(
              AppLocalizations.of(context).translate('kuwaitiDinar'),
            ),
            value: CurrencyCharacter.KWD,
            groupValue: _character,
            onChanged: (value) async {
              var pref = await SharedPreferences.getInstance();
              pref.setString('currencySymbol', 'KWD');
              setState(() {
                _character = value!;
                changeCurrency.selectedCurrency = 'KWD';
                cSymbol = 'KWD';
                changeCurrency.setCurrency();
              });
            },
          ),
          RadioListTile<CurrencyCharacter>(
            title: Text(
              AppLocalizations.of(context).translate('usDollar'),
            ),
            value: CurrencyCharacter.USD,
            groupValue: _character,
            onChanged: (value) async {
              var pref = await SharedPreferences.getInstance();
              pref.setString('currencySymbol', 'USD');
              setState(() {
                _character = value!;
                changeCurrency.selectedCurrency = 'USD';
                cSymbol = 'USD';
                changeCurrency.setCurrency();
              });
            },
          ),
          RadioListTile<CurrencyCharacter>(
            title: Text(
              AppLocalizations.of(context).translate('omaniRial'),
            ),
            value: CurrencyCharacter.OMR,
            groupValue: _character,
            onChanged: (value) async {
              var pref = await SharedPreferences.getInstance();
              pref.setString('currencySymbol', 'OMR');
              setState(() {
                _character = value!;
                changeCurrency.selectedCurrency = 'OMR';
                cSymbol = 'OMR';
                changeCurrency.setCurrency();
              });
            },
          ),
          RadioListTile<CurrencyCharacter>(
            title: Text(
              AppLocalizations.of(context).translate('qatariRiyal'),
            ),
            value: CurrencyCharacter.QAR,
            groupValue: _character,
            onChanged: (value) async {
              var pref = await SharedPreferences.getInstance();
              pref.setString('currencySymbol', 'QAR');
              setState(() {
                _character = value!;
                changeCurrency.selectedCurrency = 'QAR';
                cSymbol = 'QAR';
                changeCurrency.setCurrency();
              });
            },
          ),
          RadioListTile<CurrencyCharacter>(
            title: Text(
              AppLocalizations.of(context).translate('saudiRiyal'),
            ),
            value: CurrencyCharacter.SAR,
            groupValue: _character,
            onChanged: (value) async {
              var pref = await SharedPreferences.getInstance();
              pref.setString('currencySymbol', 'SAR');
              setState(() {
                _character = value!;
                changeCurrency.selectedCurrency = 'SAR';
                cSymbol = 'SAR';
                changeCurrency.setCurrency();
              });
            },
          ),
          RadioListTile<CurrencyCharacter>(
            title: Text(
              AppLocalizations.of(context).translate('indianRupee'),
            ),
            value: CurrencyCharacter.INR,
            groupValue: _character,
            onChanged: (value) async {
              var pref = await SharedPreferences.getInstance();
              pref.setString('currencySymbol', 'INR');
              setState(() {
                _character = value!;
                changeCurrency.selectedCurrency = 'INR';
                cSymbol = 'INR';
                changeCurrency.setCurrency();
              });
            },
          ),
        ],
      ),
    );
  }
}
