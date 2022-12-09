import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = const Locale('en');

  get appCurrentLocale {
    return _appLocale.languageCode.toString();
  }

  Locale get appLocal => _appLocale;
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = const Locale('en');
      userLocal = 'en';
      return;
    }
    _appLocale = Locale(prefs.getString('language_code')!);
    _appLocale.languageCode == 'ar' ? userLocal = 'ar' : userLocal = 'en';
    return Null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (type == const Locale("ar")) {
      _appLocale = const Locale("ar");
      userLocal = 'ar';
      await prefs.setString('language_code', 'ar');
      await prefs.setString('countryCode', '');
    } else {
      _appLocale = const Locale("en");
      userLocal = 'en';
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    notifyListeners();
  }
}
