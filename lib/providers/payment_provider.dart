import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laybull_v3/screens/web_laybul.dart';
import 'package:laybull_v3/util_services/http_service.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';

class PaymentProvider with ChangeNotifier {
  var httpService = locator<HttpService>();
  var utilService = locator<UtilService>();
  String? openUrl;

  buyNowPayment(int product_id, int amount, BuildContext context) async {
    Map<String, dynamic> data = {
      'product_id': product_id,
      'amount': amount,
    };
    MyProgressDialog pr = MyProgressDialog(context);
    try {
      pr.show();
      var response = await httpService.buyNowPayment(data);
      if (response.statusCode == 200) {
        openUrl = response.data['link'];
        pr.hide();
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebLaybull(openUrl!)));
      } else {
        pr.hide();
        utilService.showToast('Internal Server Error', ToastGravity.BOTTOM);
      }
    } catch (err) {
      pr.hide();
      utilService.showToast('Internal Server Error', ToastGravity.BOTTOM);
      if (kDebugMode) {
        print(err);
      }
    }
  }
}
