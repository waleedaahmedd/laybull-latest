import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:laybull_v3/util_services/http_service.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  String cSymbol = '';
  //final storage = FlutterSecureStorage();

  var currencies;
  var selectedCurrency = "AED";
  double localCurrency = 1.0;
  var httpService = locator<HttpService>();

  setCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var currencyData = prefs.getString('currencySymbol');
    if (currencyData != null) {
      print('---------------------------');
      print(currencyData);
      print('---------------------------');
      selectedCurrency = currencyData;
      cSymbol = selectedCurrency;
      await getCurrecny();
      notifyListeners();
    } else {
      await getCurrecny();
      notifyListeners();
    }
  }

  getCurrecny() async {
    try {
      var response = await httpService.getCurrencies();
      if (response.data['status'] == 'success') {
        currencies = response.data['data'];
        localCurrency = currencies[selectedCurrency].toDouble();
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    notifyListeners();
  }

  // double convertToLocal(double inputAED) {
  //   return (inputAED * localCurrency);
  // }

  // double convertToAED(double inputLocal) {
  //   return (inputLocal / localCurrency);
  // }
}
