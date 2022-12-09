// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laybull_v3/enum.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/storage_service.dart';
import 'package:laybull_v3/util_services/utilservices.dart';

class HttpService {
  Dio _dio = Dio();
  // final baseUrl = "https://demo.techstirr.com/laybull2/laybull/public";
  final baseUrl = "https://laybulldxb.com/laybull2/laybull/public";
  StorageService? storageServie = locator<StorageService>();
  UtilService? utilService = locator<UtilService>();

  Future<Dio> getApiClient() async {
    try {
      var token = await storageServie!.getAccessToken(StorageKeys.token.toString());
print(token);
      _dio.interceptors.clear();
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers["Authorization"] = "Bearer " + token.toString();
          return handler.next(options);
        },
        onResponse: (e, handler) {
          return handler.next(e);
        },
        onError: (e, handler) {
          return handler.next(e);
        },
      ));
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      utilService!.showToast('Network Error! Kindly Restart Your App', ToastGravity.BOTTOM);
    }
    return _dio;
  }

  Future<Response> signUp(FormData data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/signup', data: data);
    return response;
  }

  Future<Response> signIn(data) async {
    var http = await getApiClient();
    var response = await http.post('https://laybulldxb.com/laybull2/laybull/public/api/login', data: data);
    return response;
  }

  Future<Response> getSingleUserData(int id) async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/users/$id?user_id=$id');
    return response;
  }

  Future<Response> becomeSeller(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/seller_account_details', data: data);
    return response;
  }

  Future<Response> homeProducts() async {
    var http = await getApiClient();

    var response = await http.get(baseUrl + '/api/homeproducts');
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  Future<Response> homeGuestProducts() async {
    var http = await getApiClient();

    var response = await http.get(baseUrl + '/api/guest-home-product');
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  Future<Response> getCategoriesAndBrand() async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/brand_category');
    return response;
  }

  Future<Response> getSizesOfCategories(int id) async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/productsizes/$id');
    return response;
  }

  Future<Response> addProduct(FormData data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/products', data: data);
    return response;
  }

  Future<Response> updateProduct(FormData data, int id) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/product/$id', data: data);
    return response;
  }

  Future<Response> productDetail(int id) async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/products/$id');
    return response;
  }

  Future<Response> productGuestDetail(int id) async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/guest-product/$id');
    return response;
  }

  Future<Response> getCategoryDetail(int id) async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/categories/$id');
    return response;
  }

  Future<Response> getCountries() async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/countries');
    return response;
  }

  Future<Response> getCities(String countryCode) async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/cities?country_code=$countryCode');
    return response;
  }

  Future<Response> setFavoriteProducts(int id) async {
    Map<String, dynamic> data = {'product_id': id};
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/productfavs', data: data);
    return response;
  }

  Future<Response> removeFavoriteProduct(int id) async {
    var http = await getApiClient();
    var response = await http.delete(baseUrl + '/api/productfavs/$id');
    return response;
  }

  Future<Response> getFavoriteProducts() async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/favouriteproducts');
    return response;
  }

  Future<Response> makeProductBid(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/productbids', data: data);
    return response;
  }

  Future<Response> getCurrencies() async {
    var http = await getApiClient();
    var response = await http.get('https://laybulldxb.com/laybull2/laybull/public/api/currency');
    return response;
  }

  Future<Response> getSlider() async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/slider');
    return response;
  }

  Future<Response> updateUer(Map<String, dynamic> data, int id) async {
    var http = await getApiClient();
    var response = await http.put(baseUrl + '/api/users/$id', data: data);
    return response;
  }

  Future<Response> updateProfilePicture(
    FormData data,
  ) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/profilepicture', data: data);
    return response;
  }

  Future<Response> getSentOffers() async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/getSendOffersList');
    return response;
  }

  Future<Response> getRecievedOffers() async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/getReceivedOffers');
    return response;
  }

  Future<Response> getViewAllProducts(int pageNumber, Map<String, String> data) async {
    var http = await getApiClient();
    var response = await http.post('https://laybulldxb.com/laybull2/laybull/public/api/all-product?page=$pageNumber', data: data);
    return response;
  }

  Future<Response> getGuestViewAllProducts(int pageNumber, Map<String, String> data) async {
    var http = await getApiClient();
    var response = await http.post('https://laybulldxb.com/laybull2/laybull/public/api/guest-product-all?page=$pageNumber', data: data);
    return response;
  }

  Future<Response> makeCounterOfferOnRecievedBid(Map<String, int> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/counterBid', data: data);
    return response;
  }

  Future<Response> acceptOffer(int id) async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/accept-offer/$id');
    return response;
  }

  Future<Response> rejectOffer(int id) async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/reject-offer/$id');
    return response;
  }

  Future<Response> followUser(Map<String, int> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/follow', data: data);
    return response;
  }

  Future<Response> unFollowUser(Map<String, int> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/un-follow', data: data);
    return response;
  }

  Future<Response> deleteBid(int id) async {
    var http = await getApiClient();
    var response = await http.delete(baseUrl + '/api/delete-bit/$id');
    return response;
  }

  Future<Response> rateUser(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/ratting', data: data);
    return response;
  }

  Future<Response> deleteProduct(int id) async {
    var http = await getApiClient();
    var response = await http.delete(baseUrl + '/api/products/$id');
    return response;
  }

  Future<Response> searchProduct(String searchingText) async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/searchProduct?search=$searchingText');
    return response;
  }

  Future<Response> searchProductWithFiltes(
      {String categoryid = '', String brandId = '', String sizeId = '', String color = '', String maxPrice = '', String minPrice = ''}) async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/search-filter/?category_id=$categoryid&brand_id=$brandId&size_id=$sizeId&$color&$maxPrice&$minPrice');
    return response;
  }

  Future<Response> forgotPassword(Map<String, String> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/forgot-password', data: data);
    return response;
  }

  Future<Response> addShippingDetail(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/shipping-detail', data: data);
    return response;
  }

  Future<Response> updateShippingDetail(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/shipping-detail', data: data);
    return response;
  }

  Future<Response> getShippingDetail() async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/shipping-detail');
    return response;
  }

  Future<Response> buyNowPayment(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/payment-process', data: data);
    return response;
  }

  Future<Response> verifyCupon(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + '/api/verify-coupon', data: data);
    return response;
  }

  Future<Response> getNotifications() async {
    var http = await getApiClient();
    var response = await http.get(baseUrl + '/api/app-notification');
    return response;
  }
}
