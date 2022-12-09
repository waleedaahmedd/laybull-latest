// ignore_for_file: avoid_print, prefer_final_fields, curly_braces_in_flow_control_structures

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/models/country_model.dart';
import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/models/shipping_mode.dart';
import 'package:laybull_v3/models/user_model.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/screens/account_screen.dart';
import 'package:laybull_v3/screens/forgot_pass_screen.dart';
import 'package:laybull_v3/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart' as img;
import 'package:laybull_v3/screens/main_dashboard_screen.dart';
import 'package:laybull_v3/screens/signup_screen.dart';
import 'package:laybull_v3/util_services/http_service.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/storage_service.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';
import 'package:provider/src/provider.dart';

import '../enum.dart';
import 'bidding_provider.dart';

class AuthProvider with ChangeNotifier {
  TextEditingController emailControllerForLogin = TextEditingController();
  TextEditingController passwordControllerForLogin = TextEditingController();
  TextEditingController firstNameControllerForSG = TextEditingController();
  TextEditingController lastNameControllerForSG = TextEditingController();
  TextEditingController addressControllerForSG = TextEditingController();
  TextEditingController cityControllerForSG = TextEditingController();
  TextEditingController emailControllerForSG = TextEditingController();
  TextEditingController passwordControllerForSG = TextEditingController();
  TextEditingController phoneControllerForSG = TextEditingController();
  TextEditingController accountControllerForSG = TextEditingController();
  TextEditingController accountNumberControllerForSG = TextEditingController();
  TextEditingController accountNameControllerForSG = TextEditingController();

  TextEditingController accountHolderPhoneControllerForSG = TextEditingController();
  TextEditingController bankNameControllerForSG = TextEditingController();
  TextEditingController ibanNumberControllerForSG = TextEditingController();
  var sellerFormKeyForSG = GlobalKey<FormState>();

  var _http = locator<HttpService>();
  var utilService = locator<UtilService>();
  var _storage = locator<StorageService>();

  List<CountryModel> countries = [];
  bool isSeller = false;
  CountryModel? selectedCountry;
  bool isCountryFetched = false;
  List<String> cities = [];
  bool isbecomingSeller = false;
  bool isUpdating = false;
  img.ImagePicker obj = img.ImagePicker();

  // ImageClass imageFile = ImageClass(isPicked: false, image: null);
  img.XFile? imageFile;
  File? profileImg;

  UserModel? user;
  UserModel? fetchedUser;
  bool isfetchingUserDetail = false;
  MyProgressDialog? pr;

  clearSignUpFields() {
    emailControllerForLogin.clear();
    passwordControllerForLogin.clear();
    firstNameControllerForSG.clear();
    lastNameControllerForSG.clear();
    addressControllerForSG.clear();
    cityControllerForSG.clear();
    emailControllerForSG.clear();
    passwordControllerForSG.clear();
    phoneControllerForSG.clear();
    accountControllerForSG.clear();
    accountHolderPhoneControllerForSG.clear();
    bankNameControllerForSG.clear();
    ibanNumberControllerForSG.clear();
    isSeller = false;
    isUpdating = false;
    selectedCountry = null;
    profileImg = null;
    imageFile = null;
    isfetchingUserDetail = false;
    isbecomingSeller = false;
    isCountryFetched = false;
  }

  clearData() {
    isfetchingUserDetail = false;
    cities = [];
    user = null;
    fetchedUser = null;
    clearSignUpFields();
  }

  List<Product> listOfPurchasedHistory = [];
  double userRating = 3.5;
  bool isLoading = true;

  bool isFollowed = false;
  int noOfFollowers = 0;
  int noOfFollowings = 0;
  List<Product> listOfSelling = [];
  List<Product> listOfSold = [];
  String? editedProfilePicUrl = '';
  List<Product> listOfPurchased = [];

  Future login(String email, String password, BuildContext context) async {
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      _firebaseMessaging.requestPermission();
      String? deviceToken = await _firebaseMessaging.getToken();
      log(deviceToken.toString());
      Map<String, dynamic> data = {'email': email, 'password': password, 'fcm_token': deviceToken};

      pr = MyProgressDialog(context);
      var response = await _http.signIn(data);
      if (response.data['status'] == 'success') {
        user = UserModel(
            id: response.data['data']['user']['id'] ?? 0,
            first_name: response.data['data']['user']['first_name'] ?? '',
            last_name: response.data['data']['user']['last_name'] ?? '',
            email: response.data['data']['user']['email'] ?? '',
            isSeller: response.data['data']['user']['is_seller'] ?? 0,
            verified_vendor: response.data['data']['user']['verified_vendor'] ?? 0,
            image: response.data['data']['user']['image'] ?? '',
            address: response.data['data']['user']['address'] ?? '',
            // products: response.data['data']['user']['products'] ?? [],
            city: response.data['data']['user']['city'] ?? '',
            country: response.data['data']['user']['country'] ?? '',
            ratting: double.parse(response.data['data']['user']['ratting'] != null ? response.data['data']['user']['ratting'].toString() : '0'),
            ratting_count: response.data['data']['user']['ratting_count'] ?? 0,
            contact: response.data['data']['user']['contact'] != null ? (response.data['data']['user']['contact']).toString() : '',
            profile_picture: response.data['data']['user']['profile_picture'] ?? '',
            accountHolderName: response.data['data']['user']['account_name'] ?? '',
            bankName: response.data['data']['user']['bank_name'] ?? '',
            followers: response.data['data']['user']['followers'] ?? 0,
            followings: response.data['data']['user']['followings'],
            IBAN: response.data['data']['user']['iban'] ?? '',
            accountNumber: response.data['data']['user']['card_number'] ?? '',
            phoneNumber: response.data['data']['user']['phone_number'] ?? '0',
            products: response.data['data']['user']['products'] != null
                ? List<ProductsModel>.from(
                    (response.data['data']['user']['products'] as List<dynamic>).map<ProductsModel?>(
                      (x) => ProductsModel.fromJson(x as Map<String, dynamic>),
                    ),
                  )
                : null);

        await _storage.saveAccessToken(
          StorageKeys.token.toString(),
          response.data['data']['accessToken'],
        );
        await getShippingDetail();
        await _storage.setData(StorageKeys.user.toString(), response.data['data']['user']);
        await context.read<ProductProvider>().getHomeProducts();
        await context.read<ProductProvider>().getFavoriteProducts();
        await context.read<ProductProvider>().getCategoriesAndBrand();
        await context.read<ProductProvider>().getHomeSlider();
        await context.read<BidProvider>().getSentOffer(false);
        await context.read<BidProvider>().getRecievedOffers(false);
        await context.read<AuthProvider>().getCountries(context);

        // await getCountries(context);
        emailControllerForLogin.text = '';
        passwordControllerForLogin.text = '';
        pr!.hide();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => BottomNav(
              navIndex: 0,
            ),
          ),
        );
      } else {
        utilService.showToast('${response.data['message']}', ToastGravity.TOP);
        pr!.hide();
      }
    } catch (err) {
      pr!.hide();
      utilService.showToast(err.toString(), ToastGravity.TOP);
      print(err);
    }
    notifyListeners();
  }

  Future getUserById(int id, BuildContext context, bool alreadyOnScreen) async {
    try {
      if (alreadyOnScreen == false) {
        isfetchingUserDetail = true;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AccountScreen(
                    // isUserDetail: false,
                    userId: id,
                    comingFromDashboard: false,
                    key: UniqueKey(),
                  )),
        );
      }
      notifyListeners();
      var response = await _http.getSingleUserData(id);
      if (response.statusCode == 200) {
        fetchedUser = UserModel.fromMap(response.data['data']);
        if (alreadyOnScreen == false) {
          isfetchingUserDetail = false;
        }

        notifyListeners();
      }
    } catch (err) {
      if (alreadyOnScreen == false) {
        isfetchingUserDetail = false;
      }
      notifyListeners();
      print(err);
    }
    notifyListeners();
  }

  Future getUpdatedLoginUser(int id, BuildContext context) async {
    try {
      var response = await _http.getSingleUserData(id);
      if (response.statusCode == 200) {
        user = UserModel(
            id: response.data['data']['id'] ?? 0,
            first_name: response.data['data']['first_name'] ?? '',
            last_name: response.data['data']['last_name'] ?? '',
            email: response.data['data']['email'] ?? '',
            isSeller: response.data['data']['is_seller'] ?? 0,
            verified_vendor: response.data['data']['verified_vendor'] ?? 0,
            image: response.data['data']['image'] ?? '',
            address: response.data['data']['address'] ?? '',
            city: response.data['data']['city'] ?? '',
            country: response.data['data']['country'] ?? '',
            ratting: double.parse(response.data['data']['ratting'] != null ? response.data['data']['ratting'].toString() : '0'),
            ratting_count: response.data['data']['ratting_count'] ?? 0,
            contact: response.data['data']['contact'] != null ? (response.data['data']['contact']).toString() : '',
            profile_picture: response.data['data']['profile_picture'] ?? '',
            accountHolderName: response.data['data']['account_name'] ?? '',
            bankName: response.data['data']['bank_name'] ?? '',
            followers: response.data['data']['followers'] ?? 0,
            followings: response.data['data']['followings'],
            IBAN: response.data['data']['iban'] ?? '',
            accountNumber: response.data['data']['card_number'] ?? '',
            phoneNumber: response.data['data']['phone_number'] ?? '0',
            products: response.data['data']['products'] != null
                ? List<ProductsModel>.from(
                    (response.data['data']['products'] as List<dynamic>).map<ProductsModel?>(
                      (x) => ProductsModel.fromJson(x as Map<String, dynamic>),
                    ),
                  )
                : null);

        await getShippingDetail();

        await _storage.setData(StorageKeys.user.toString(), response.data['data']);

        notifyListeners();
      }
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  Future getCountries(BuildContext context) async {
    try {
      isCountryFetched = false;
      notifyListeners();
      var response = await _http.getCountries();
      if (response.data['data'].length > 0) {
        countries.clear();
        for (int i = 0; i < response.data['data'].length; i++) {
          countries.add(CountryModel.fromJson(response.data['data'][i]));
        }
        selectedCountry = null;
        isCountryFetched = true;
        notifyListeners();
      }
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  Future getCities(String countryCode) async {
    try {
      var response = await _http.getCities(countryCode);
      if (response.data['data'].length > 0) {
        cities.clear();
        cities.addAll(response.data['data']);
      }
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  Future signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String country,
    required String city,
    required String address,
    required bool becomeSeller,
    File? profilePic,
    String? bankName,
    String? IBAN,
    String? accountNumber,
    String? accountHolderName,
    required BuildContext context,
  }) async {
    try {
      if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || phoneNumber.isEmpty) {
        utilService.showToast('Kindly fill all fields', ToastGravity.CENTER);
      } else if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) == false) {
        utilService.showToast('Invalid Email', ToastGravity.CENTER);
      } else if (password.length < 8) {
        utilService.showToast('Password length should be atleast 8 characters', ToastGravity.CENTER);
      } else if (isSeller == true) {
        if (bankName!.isEmpty || IBAN!.isEmpty || accountNumber!.isEmpty || accountHolderName!.isEmpty) {
          utilService.showToast("Kindly fill all banking details.", ToastGravity.CENTER);
        } else if (profilePic == null) {
          utilService.showToast('Upload profile pic', ToastGravity.CENTER);
        } else {
          pr = MyProgressDialog(context);
          pr!.show();
          var formData = FormData.fromMap({
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'name': '$firstName $lastName',
            'password': password,
            'phone_number': phoneNumber,
            'city': city,
            'country': country,
            'address': address,
            'is_seller': becomeSeller == true ? 1 : 0,
            'iban': IBAN,
            'card_number': accountNumber,
            'account_name': accountHolderName,
            'bank_name': bankName,
            'profile_picture': await MultipartFile.fromFile(
              profilePic.path,
              filename: 'profileImage',
            ),
          });

          var response = await _http.signUp(formData);
          if (response.data['status'] == 'success') {
            pr!.hide();
            utilService.showToast('Account has been registered', ToastGravity.BOTTOM);
            clearSignUpFields();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const LoginPage()));
          } else if (response.data['status'] == 'error') {
            pr!.hide();
            utilService.showToast(response.data['data'], ToastGravity.CENTER);
          }
        }
      } else if (profilePic == null) {
        utilService.showToast('Upload profile pic', ToastGravity.CENTER);
      } else {
        pr = MyProgressDialog(context);
        pr!.show();
        var formData = FormData.fromMap({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'name': '$firstName $lastName',
          'password': password,
          'phone_number': phoneNumber,
          'city': city,
          'country': country,
          'address': address,
          'is_seller': becomeSeller == true ? 1 : 0,
          'iban': IBAN,
          'card_number': accountNumber,
          'account_name': accountHolderName,
          'bank_name': bankName,
          'profile_picture': await MultipartFile.fromFile(
            profilePic.path,
            filename: 'profileImage',
          ),
        });

        var response = await _http.signUp(formData);
        if (response.data['status'] == 'success') {
          pr!.hide();
          utilService.showToast('Verification Email Has Been Sent.', ToastGravity.BOTTOM);
          clearSignUpFields();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage(),
            ),
          );
        } else if (response.data['status'] == 'error') {
          pr!.hide();
          utilService.showToast(response.data['data']['email'][0], ToastGravity.CENTER);
        }
      }
    } catch (err) {
      pr = MyProgressDialog(context);
      pr!.hide();

      print(err);
    }
    notifyListeners();
  }

  Future updateUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String country,
    required String city,
    required String address,
    required bool becomeSeller,
    required File? profilePic,
    String? bankName,
    String? IBAN,
    String? accountNumber,
    String? accountHolderName,
    required BuildContext context,
  }) async {
    try {
      isUpdating = true;
      pr = MyProgressDialog(context);
      pr!.show();
      notifyListeners();
      var data = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'name': '$firstName $lastName',
        'phone_number': phoneNumber,
        'city': city,
        'country': country,
        'address': address,
        'is_seller': becomeSeller == true ? 1 : 0,
        'iban': IBAN,
        'card_number': accountNumber,
        'account_name': accountHolderName,
        'bank_name': bankName,
      };

      if (profilePic != null) {
        var formData = FormData.fromMap({
          'profile_picture': await MultipartFile.fromFile(profilePic.path, filename: 'ProfileImage'),
        });
        await _http.updateProfilePicture(formData);
      }
      var response = await _http.updateUer(data, user!.id);

      if (response.data['status'] == 'success') {
        await getUpdatedLoginUser(user!.id, context);
        notifyListeners();
        await _storage.removeData(StorageKeys.user.toString());
        await _storage.setData(StorageKeys.user.toString(), user);
        clearSignUpFields();
        isSeller = false;
        pr!.hide();
        Navigator.of(context).pop();
        notifyListeners();

        // Navigator.of(context).pop();
      }
      isUpdating = false;

      notifyListeners();
    } catch (err) {
      utilService.showToast('Internal Server Error', ToastGravity.CENTER);
      isUpdating = false;
      pr!.hide();
      notifyListeners();
      print(err);
    }
  }

  Future becomeSeller(
      {int? phoneNumber, String? accountHolderName, String? accountBankName, String? IBAN, String? accountNumber, BuildContext? context}) async {
    try {
      isbecomingSeller = true;
      notifyListeners();
      Map<String, dynamic> data = {
        'account_holder_name': accountHolderName,
        'account_number': accountNumber,
        'account_phone_number': phoneNumber,
        'account_iban': IBAN,
        'account_bank_name': accountBankName,
      };
      var response = await _http.becomeSeller(data);
      if (response.statusCode == 200) {
        await getUpdatedLoginUser(response.data['user']['id'], context!);
        isbecomingSeller = false;
        notifyListeners();
        utilService.showToast(response.data['message'], ToastGravity.CENTER);
        Navigator.of(context).pop();
        await _storage.setData(StorageKeys.user.toString(), response.data['user']);

        await context.read<ProductProvider>().getHomeProducts();
        await context.read<ProductProvider>().getFavoriteProducts();
        await context.read<ProductProvider>().getCategoriesAndBrand();
      } else {
        utilService.showToast(response.data['message'], ToastGravity.CENTER);
      }
    } catch (err) {
      isbecomingSeller = false;
      print(err);
    }
    notifyListeners();
  }

  void showPicker(
    context,
  ) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text(
                        "Photo Library",
                      ),
                      onTap: () {
                        imgFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text("Camera"),
                    onTap: () {
                      imgFromCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  imgFromGallery(BuildContext context) async {
    await obj.pickImage(source: img.ImageSource.gallery, imageQuality: 10).then((img) {
      if (kDebugMode) {
        print(img);
      }
      imageFile = img;
      profileImg = File(img!.path);
      user!.profile_picture = null;
    });
    notifyListeners();
  }

  imgFromCamera(BuildContext context) async {
    await obj.pickImage(source: img.ImageSource.camera, imageQuality: 10).then((img) {
      print(img);
      print(img!.path);
      imageFile = img;
      profileImg = File(img.path);
      user!.profile_picture = null;
    });
    notifyListeners();
  }

  followUser(int id, BuildContext context, int loggedInUserId) async {
    try {
      Map<String, int> data = {
        'follow_id': id,
      };
      var response = await _http.followUser(data);
      if (response.data['status'] == 'success') {
        // utilService.showToast(response.data['message'], ToastGravity.CENTER);
        fetchedUser!.isFollow = true;
        fetchedUser!.followers = fetchedUser!.followers! + 1;
        notifyListeners();
        await getUserById(id, context, true);
        await getUpdatedLoginUser(
          loggedInUserId,
          context,
        );
      }
    } catch (err) {
      print(err);
    }
  }

  unFollowUser(int id, BuildContext context, int loggedInUserId) async {
    try {
      Map<String, int> data = {
        'follow_id': id,
      };
      var response = await _http.unFollowUser(data);
      if (response.data['status'] == 'success') {
        fetchedUser!.isFollow = false;
        fetchedUser!.followers = fetchedUser!.followers! - 1;
        notifyListeners();
        // utilService.showToast(response.data['message'], ToastGravity.CENTER);
        await getUserById(id, context, true);
        await getUpdatedLoginUser(
          loggedInUserId,
          context,
        );
      }
    } catch (err) {
      print(err);
    }
  }

  rateUser(int ratingUserid, double rating, BuildContext context) async {
    try {
      Map<String, dynamic> data = {
        'ratting_user_id': ratingUserid,
        'ratting': rating,
      };

      var response = await _http.rateUser(data);
      if (response.data['status'] == 'success') {
        utilService.showToast(
          'Thanks for rating your seller!',
          ToastGravity.BOTTOM,
        );
        notifyListeners();
        await getUserById(ratingUserid, context, true);
      }
    } catch (err) {
      print(err);
    }
  }

  forgotPassword(String email, BuildContext context) async {
    try {
      pr = MyProgressDialog(context);
      pr!.show();
      Map<String, String> data = {'email': email};
      var response = await _http.forgotPassword(data);
      if (response.data['status'] == 200) {
        utilService.showToast(response.data['message'], ToastGravity.BOTTOM);
        pr!.hide();
        Navigator.of(context).pop();
      } else {
        utilService.showToast(response.data['message'], ToastGravity.BOTTOM);
        pr!.hide();
      }
    } catch (err) {
      pr!.hide();
      print(err);
    }
  }

  addShippingDetail(ShippingModel shippingModel, BuildContext context) async {
    try {
      MyProgressDialog pr = MyProgressDialog(context);
      pr.show();
      Map<String, dynamic> data = {
        'address': shippingModel.address,
        'city': shippingModel.city,
        'country': shippingModel.country,
        'phone_number': shippingModel.phone_number,
      };
      var response = await _http.addShippingDetail(data);
      if (response.data['status'] == 'success') {
        await getShippingDetail();
      }
      pr.hide();
    } catch (err) {
      print(err);
    }
  }

  getShippingDetail() async {
    try {
      var response = await _http.getShippingDetail();
      if (response.data['status'] == 'success') {
        user!.shippingDetail = ShippingModel.fromMap(response.data['data']);
        notifyListeners();
      }
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  updateShippingDetail(ShippingModel shippingModel, BuildContext context) async {
    try {
      MyProgressDialog pr = MyProgressDialog(context);
      pr.show();
      Map<String, dynamic> data = {
        'address': shippingModel.address,
        'city': shippingModel.city,
        'country': shippingModel.country,
        'phone_number': shippingModel.phone_number,
      };
      var response = await _http.updateShippingDetail(data);
      if (response.data['status'] == 'success') {
        await getShippingDetail();
      }
      pr.hide();
    } catch (err) {
      print(err);
    }
  }
}
