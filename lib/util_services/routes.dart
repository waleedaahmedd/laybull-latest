// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:laybull_v3/screens/currency_screen.dart';
import 'package:laybull_v3/screens/forgot_pass_screen.dart';
import 'package:laybull_v3/screens/login_screen.dart';
import 'package:laybull_v3/screens/notification_screen.dart';
import 'package:laybull_v3/screens/offer_screen.dart';
import 'package:laybull_v3/screens/favorite_product_screen.dart';
import 'package:laybull_v3/screens/product_detail_screen.dart';
import 'package:laybull_v3/screens/purchased_history_screen.dart';
import 'package:laybull_v3/screens/shipping_detail_screen.dart';
import 'package:laybull_v3/screens/signup_screen.dart';
import 'package:laybull_v3/screens/sold_products_screen.dart';
import 'package:laybull_v3/screens/boarding_screen.dart';
import 'package:laybull_v3/screens/splash_screen.dart';

const SplashScreenRoute = "/splash-screen";
const BoardingScreenRoute = "/boarding-screen-route";
const LoginScreenRoute = "/login-screen";
const SignUpScreenRoute = "sign-up-screen";
const ForgotPasswordScreenRoute = "/forgot-password-screen";
const PopularProductScreenRoute = "/popular-products-screen";
const OfferScreenRoute = "/offer-screen-route";
const CurrencyScreenRoute = "/currency-screen-route";
const NotificationScreenRoute = "/notification-screen-route";
const ShippingDetailsScreenRoute = '/shipping-detail-screen-route';
const PurchseHistoryScreenRoute = 'purchase-history-screen-route';
const SoldProductsScreenRoute = '/sold-products-screen-route';
const ProductDetailScreenRoute = '/product-detail-screen';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case BoardingScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => BoardingScreen());
    case SplashScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SplashScreen());
    case LoginScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => LoginPage());

    case SignUpScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => Signup());

    case ForgotPasswordScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ForgotPassword());
    case PopularProductScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ForgotPassword());
    case OfferScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => OfferScreen());
    case CurrencyScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => CurrencyScreen());
    case NotificationScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => NotificationScreen());
    case ShippingDetailsScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ShippingDetailsScreen());
    case PurchseHistoryScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) =>
              PurchasedHistory(purchasedHistory: []));
    case SoldProductsScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SoldProducts());

    case ProductDetailScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ProductDetailScreen());

    default:
      return MaterialPageRoute(
        builder: (BuildContext context) => FavoriteProductScreen(
          isFromNavBar: false,
        ),
      );
  }
}
