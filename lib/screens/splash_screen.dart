// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/bidding_provider.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/screens/boarding_screen.dart';
import 'package:laybull_v3/screens/login_screen.dart';
import 'package:laybull_v3/screens/main_dashboard_screen.dart';
import 'package:laybull_v3/util_services/firebase_service.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/storage_service.dart';

import 'package:provider/provider.dart';

import '../enum.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StorageService? storageServie = locator<StorageService>();
  FirebaseService? fcmService = locator<FirebaseService>();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
      ),
    );

    fcmService!.notificatonPermission();
    fcmService!.getTokken();
    fcmService!.getForgruoundNotificaton();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Message data: ${message.data}');

      log('Message also contained a notification: ${message.notification!}');
    });
    Timer(Duration(milliseconds: 1), () async {
      try {
        var token = await storageServie!.getAccessToken(StorageKeys.token.toString());
        var data = await storageServie!.getData(StorageKeys.user.toString());
        var firstTime = await storageServie!.getBoolData(StorageKeys.first_time.toString());

        if (data != null) {
          context.read<AuthProvider>().user = data;
        }
        if (token != null) {
          await context.read<AuthProvider>().getUpdatedLoginUser(context.read<AuthProvider>().user!.id, context);
          await context.read<ProductProvider>().getHomeProducts();
          await context.read<ProductProvider>().getHomeSlider();

          await context.read<ProductProvider>().getFavoriteProducts();
          await context.read<BidProvider>().getSentOffer(false);
          await context.read<BidProvider>().getRecievedOffers(false);
          await context.read<AuthProvider>().getCountries(context);
        }
        await context.read<ProductProvider>().getGuestHomeProducts();
        await context.read<ProductProvider>().getHomeSlider();
        await context.read<ProductProvider>().getCategoriesAndBrand();
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => BoardingScreen(),
        //   ),
        // );
        if (firstTime == null || firstTime == false) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => BoardingScreen(),
            ),
          );
        } else {
          if (context.read<AuthProvider>().user != null) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => BottomNav(
                navIndex: 0,
              ),
            ));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
          }
        }
      } catch (err) {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => BoardingScreen(),
        //   ),
        // );
        if (context.read<AuthProvider>().user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => BottomNav(
                navIndex: 0,
              ),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(),
            ),
          );
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<CurrencyProvider>().setCurrency();
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Center(
          child: Image.asset(
            'assets/splashLogo.png',
            width: MediaQuery.of(context).size.width * .7,
            height: MediaQuery.of(context).size.height * .07,
          ),
        ),
      ),
    );
  }
}
