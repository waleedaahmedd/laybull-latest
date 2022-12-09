// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:laybull_v3/globals.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/providers/app_language_provider.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/bidding_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/screens/account_screen.dart';
import 'package:laybull_v3/screens/currency_screen.dart';
import 'package:laybull_v3/screens/login_screen.dart';
import 'package:laybull_v3/screens/notification_screen.dart';
import 'package:laybull_v3/screens/purchased_history_screen.dart';
import 'package:laybull_v3/screens/shipping_detail_screen.dart';
import 'package:laybull_v3/screens/web_laybul.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/storage_service.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../enum.dart';

class MainAccountDrawer extends StatelessWidget {
  MainAccountDrawer({Key? key}) : super(key: key);
  SingingCharacter _character = userLocal == 'ar' ? SingingCharacter.arabic : SingingCharacter.english;

  var utilService = locator<UtilService>();
  var storageService = locator<StorageService>();

  Future<void> _changeLanguage(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "Change Language".toUpperCase(),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  RadioListTile<SingingCharacter>(
                    title: Text('English'),
                    value: SingingCharacter.english,
                    groupValue: _character,
                    onChanged: (value) {
                      setState(() {
                        _character = value!;
                        Provider.of<AppLanguage>(context, listen: false).changeLanguage(Locale("en"));
                      });
                    },
                  ),
                  RadioListTile<SingingCharacter>(
                    title: Text('عربي'),
                    value: SingingCharacter.arabic,
                    groupValue: _character,
                    onChanged: (value) {
                      setState(() {
                        _character = value!;
                        Provider.of<AppLanguage>(context, listen: false).changeLanguage(Locale("ar"));
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text(
                  "Done",
                ),
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _settingPopUP(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "Settings".toUpperCase(),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: Icon(Icons.attach_money_outlined),
                    title: Text("Currency"),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CurrencyScreen())),
                  ),
                  ListTile(
                    leading: Icon(Icons.language_outlined),
                    title: Text("Language"),
                    onTap: () {
                      Navigator.pop(context);
                      _changeLanguage(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(context.read<AuthProvider>().user != null ? "Log Out" : "Log In"),
                    onTap: () async {
                      await storageService.removeData(StorageKeys.token.toString());
                      await storageService.removeData(StorageKeys.user.toString());
                      await storageService.removeData(StorageKeys.password.toString());
                      // print(perfs);
                      // await storageService
                      //     .removeData(StorageKeys.user.toString());
                      // await storageService
                      //     .removeData(StorageKeys.token.toString());
                      // await storageService
                      //     .removeData(StorageKeys.token.toString());
                      // await storageService
                      //     .removeData(StorageKeys.user.toString());

                      context.read<ProductProvider>().clearData();
                      context.read<BidProvider>().clearData();
                      context.read<AuthProvider>().clearData();
                      // if (context.read<AuthProvider>().user != null) {
                      //   context.read<AuthProvider>().dispose();
                      //   context.read<BidProvider>().dispose();
                      //   context.read<ProductProvider>().dispose();
                      // }
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                    },
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context).translate('done'),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          DrawerHeader(
            child: Image.asset('assets/Logo_black.png'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.56,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: Icon(Icons.qr_code_2_outlined),
                  title: Text(AppLocalizations.of(context).translate('verification')),
                  onTap: () => utilService.showToast('Coming Soon', ToastGravity.BOTTOM),
                ),
                if (context.read<AuthProvider>().user != null) ...[
                  ListTile(
                      leading: Icon(Icons.notifications_none_rounded),
                      title: Text(AppLocalizations.of(context).translate('notifications')),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NotificationScreen()))),
                  ListTile(
                    leading: Icon(Icons.local_shipping_outlined),
                    title: Text(
                      AppLocalizations.of(context).translate('shippingDetails'),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ShippingDetailsScreen())),
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.shopping_cart_outlined),
                  //   title: Text(AppLocalizations.of(context)
                  //       .translate('purchasedHistory')),
                  //   onTap: () => MaterialPageRoute(
                  //       builder: (BuildContext ctx) => PurchasedHistory(
                  //           purchasedHistory:
                  //               ctx.read<AuthProvider>().listOfPurchasedHistory)),
                  // ),
                  Consumer<AuthProvider>(builder: (context, ap, _) {
                    return ListTile(
                      leading: Icon(Icons.shopping_cart_outlined),
                      title: Text(AppLocalizations.of(context).translate('purchasedHistory')),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) => PurchasedHistory(purchasedHistory: ap.listOfPurchasedHistory)),
                      ),
                    );
                  }),
                ],
                ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text(AppLocalizations.of(context).translate('term&Conditions')),
                  onTap: () async {
                    String url = "https://laybull.com/terms/";
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebLaybull(url)));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment_turned_in),
                  title: Text(AppLocalizations.of(context).translate('privacy&Policy')),
                  onTap: () async {
                    String url = "https://laybull.com/privacy-policy/";
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebLaybull(url)));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.record_voice_over_outlined),
                  title: Text(AppLocalizations.of(context).translate('helpCenter')),
                  onTap: () async {
                    String url = "https://laybull.com/help/";
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebLaybull(url)));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(AppLocalizations.of(context).translate('setting')),
                  onTap: () {
                    _settingPopUP(context);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/toppng.png',
                    width: 27.w,
                  ),
                  title: Text('Follow Laybull'),
                  onTap: () async {
                    final Uri _url = Uri.parse('https://www.instagram.com/laybull/');
                    if (!await launchUrl(_url)) {
                      throw 'Could not launch $_url';
                    }
                  },
                ),
                // ListTile(
                //   leading: Image.asset(
                //     'assets/icons/insta_icon.png',
                //     height: 40.h,
                //     width: 40.w,
                //   ),
                //   title: Text(
                //     'Follow Laybull',
                //     style: Textprimary,
                //   ),
                //   onTap: () async {
                //     final Uri _url = Uri.parse('https://www.instagram.com/laybull/');
                //     if (!await launchUrl(_url)) {
                //       throw 'Could not launch $_url';
                //     }
                //   },
                // ),

                // SizedBox(
                //   height: 20.h,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
