import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/models/bid_model.dart';
import 'package:laybull_v3/models/bid_product.dart';
import 'package:laybull_v3/util_services/http_service.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/extensions.dart';

class BidProvider with ChangeNotifier {
  List<BidModel>? sentBids = [];
  List<BidModel>? recievedBids = [];
  var httpService = locator<HttpService>();
  var utilService = locator<UtilService>();

  bool isFetchingBids = false;

  clearData() {
    sentBids!.clear();
    recievedBids!.clear();
    isFetchingBids = false;
    notifyListeners();
  }

  getSentOffer(bool onscreen) async {
    try {
      // isFetchingBids = true;
      var response = await httpService.getSentOffers();
      if (response.data['status'] == 'True') {
        sentBids!.clear();
        if (response.data['bids'].length > 0) {
          for (int i = 0; i < response.data['bids'].length; i++) {
            sentBids!.add(
              BidModel(
                bidId: response.data['bids'][i]['id'] ?? 0,
                user_id: response.data['bids'][i]['user_id'] ?? 0,
                vendor_id: response.data['bids'][i]['vendor_id'] ?? 0,
                product_id: response.data['bids'][i]['product_id'] ?? 0,
                price: double.parse(response.data['bids'][i]['price'] != null ? response.data['bids'][i]['price'].toString() : '0.0'),
                status: response.data['bids'][i]['status'] ?? '',
                counter: response.data['bids'][i]['counter'] != null ? response.data['bids'][i]['counter'].toString() : '',
                product: BidProduct(
                  id: response.data['bids'][i]['product']['id'],
                  userId: response.data['bids'][i]['product']['user_id'],
                  name: response.data['bids'][i]['product']['name'],
                  condition: response.data['bids'][i]['product']['condition'],
                  featured_image: response.data['bids'][i]['product']['featured_image'],
                  isSold: response.data['bids'][i]['product']['sold'],
                  size: response.data['bids'][i]['product']['size_id'] != null ? response.data['bids'][i]['size']['text'] : 'M',
                ),
              ),
            );
          }
          // isFetchingBids = false;
          notifyListeners();
        } else {
          if (onscreen == true) {
            // isFetchingBids = false;
            notifyListeners();
            // utilService.showToast('You don\'t have make any bid yet.');
          }
        }
      }
    } catch (err) {
      // isFetchingBids = false;
      if (kDebugMode) {
        print(err);
      }
    }
  }

  getRecievedOffers(bool onscreen) async {
    try {
      // isFetchingBids = true;
      var response = await httpService.getRecievedOffers();
      if (response.data['status'] == 'success') {
        recievedBids!.clear();
        if (response.data['data'].length > 0) {
          for (int i = 0; i < response.data['data'].length; i++) {
            recievedBids!.add(
              BidModel(
                bidId: response.data['data'][i]['id'] ?? 0,
                user_id: response.data['data'][i]['user_id'] ?? 0,
                vendor_id: response.data['data'][i]['vendor_id'] ?? 0,
                product_id: response.data['data'][i]['product_id'] ?? 0,
                price: double.parse(response.data['data'][i]['price'] != null ? response.data['data'][i]['price'].toString() : '0.0'),
                status: response.data['data'][i]['status'],
                counter: response.data['data'][i]['counter'] != null ? response.data['data'][i]['counter'].toString() : null,
                product: BidProduct(
                  id: response.data['data'][i]['product']['id'],
                  userId: response.data['data'][i]['product']['user_id'],
                  featured_image: response.data['data'][i]['product']['featured_image'],
                  name: response.data['data'][i]['product']['name'],
                  condition: response.data['data'][i]['product']['condition'],
                  isSold: response.data['data'][i]['product']['sold'],
                  size: response.data['data'][i]['product']['size_id'] != null ? response.data['data'][i]['size']['text'] : 'M',
                ),
              ),
            );
          }
          // isFetchingBids = false;
          notifyListeners();
        } else {
          if (onscreen == true) {
            // isFetchingBids = false;
            notifyListeners();
            // utilService.showToast('You don\'t have recieved any bid yet.');
          }
        }
      }
    } catch (err) {
      // isFetchingBids = false;
      if (kDebugMode) {
        print(err);
      }
      utilService.showToast('Internal Server Error', ToastGravity.CENTER);
    }
  }

  makeCounterOffer(String price, int id, BuildContext context) async {
    try {
      Map<String, int> data = {
        'bid_id': id,
        'counter': double.parse(price).convertToEuro(context).round(),
      };
      Navigator.of(context).pop();
      var response = await httpService.makeCounterOfferOnRecievedBid(data);

      if (response.data['status'] == 'success') {
        utilService.showToast('Your Counter Has Been Sent!', ToastGravity.CENTER);
        getRecievedOffers(true);
      } else {
        utilService.showToast('Please Try Again Later', ToastGravity.CENTER);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      utilService.showToast('Internal Server Error', ToastGravity.CENTER);
    }
  }

  acceptOffer(int id) async {
    try {
      var response = await httpService.acceptOffer(id);
      if (response.data['status'] == 'success') {
        utilService.showToast(response.data['message'].toString().toUpperCase(), ToastGravity.CENTER);
        await getRecievedOffers(true);
        await getSentOffer(true);
      } else {
        utilService.showToast('Internal Server Error', ToastGravity.CENTER);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  rejectOffer(int id) async {
    try {
      var response = await httpService.rejectOffer(id);
      if (response.data['status'] == 'success') {
        utilService.showToast(response.data['message'].toString().toUpperCase(), ToastGravity.CENTER);
        await getRecievedOffers(true);
        await getSentOffer(true);
      } else {
        utilService.showToast('Internal Server Error', ToastGravity.CENTER);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  deleteSentOffer(int id) async {
    try {
      var response = await httpService.deleteBid(id);
      if (response.data['status'] == 'success') {
        utilService.showToast(response.data['message'], ToastGravity.TOP);
        sentBids!.removeWhere((element) => element.bidId == id);
        await getSentOffer(true);
        notifyListeners();
      } else {
        utilService.showToast('Refresh The Page Please', ToastGravity.BOTTOM);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }
}
