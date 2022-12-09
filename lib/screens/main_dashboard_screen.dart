// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laybull_v3/constants.dart';

import 'package:laybull_v3/globals.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/screens/account_screen.dart';
import 'package:laybull_v3/screens/add_product_screen.dart';
import 'package:laybull_v3/screens/login_screen.dart';
import 'package:laybull_v3/screens/offer_screen.dart';
import 'package:laybull_v3/screens/favorite_product_screen.dart';
import 'package:laybull_v3/screens/search_screen.dart';
import 'package:laybull_v3/screens/welcome_screen.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/main_account_drawer.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_text_field.dart';
import 'package:laybull_v3/widgets/reusable_widget/myCustomProgressDialog.dart';
import 'package:provider/src/provider.dart';

import '../main.dart';

class BottomNav extends StatefulWidget {
  final int navIndex;
  final Map<String, int>? argument;
  BottomNav({required this.navIndex, this.argument});
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var utilService = locator<UtilService>();
  var scaffolKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  var ind = 0;
  int i = 0;
  // final _formKey = GlobalKey<FormState>();
  final List<bool> iconss = [
    true,
    false,
    false,
    false,
  ];

  void onTabTapped(int index, BuildContext context) async {
    _currentIndex = index;
    if (_currentIndex == index) {
      for (i = 0; i < 4; i++) {
        iconss[i] = false;
      }
      setState(() {
        if (context.read<AuthProvider>().user != null) {
          iconss[_currentIndex] = true;
          ind = _currentIndex;
        } else {
          if (index > 0) {
            _currentIndex = 0;
            iconss[_currentIndex] = true;
            utilService.showDialogue(AppLocalizations.of(context).translate('guestAlert'), context);
          }
        }
      });
    }
    //});
  }

  @override
  void initState() {
    if (widget.navIndex != null) {
      _currentIndex = widget.navIndex;
      if (widget.navIndex == 3) {
        iconss[widget.navIndex] = true;
        iconss[0] = false;
      }
      iconss[widget.navIndex] = true;
    }
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    iconss[_currentIndex] = false;
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex = 0;
        iconss[0] = true;
      });
      return false; // return true if the route to be popped
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      WelcomeScreen(),
      FavoriteProductScreen(
        isFromNavBar: true,
      ),
      OfferScreen(
        comingfromDashBoard: true,
      ),
      // Container()
      context.read<AuthProvider>().user != null
          ? AccountScreen(
              key: UniqueKey(), userId: context.read<AuthProvider>().user!.id,
              comingFromDashboard: true,
              // isUserDetail: true,
            )
          : //utilService.showDialogue('Login Please', context),
          Container(
              child: Center(
                child: Text("404 Not Found",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                    )),
              ),
            ),
    ];
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
          key: scaffolKey,
          resizeToAvoidBottomInset: true,
          extendBody: false,
          body: _children[_currentIndex],
          drawer: MainAccountDrawer(),
          appBar: AppBar(
              toolbarHeight: 60,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              backgroundColor: Colors.white10,
              title: Text(
                _currentIndex == 0
                    ? ''
                    : _currentIndex == 1
                        ? AppLocalizations.of(context).translate('favorite').toUpperCase()
                        : _currentIndex == 2
                            ? AppLocalizations.of(context).translate('offer').toUpperCase()
                            : AppLocalizations.of(context).translate('account').toUpperCase(),
                style: headingStyle,
              ),
              actions: [
                if (_currentIndex == 0)
                  Padding(
                    padding: EdgeInsets.only(
                      right: 18.w,
                    ),
                    child: AppTextField(
                      width: 320.w,
                      controller: TextEditingController(),
                      hintText: AppLocalizations.of(context).translate('search'),
                      isReadyOnly: true,
                      height: 50,
                      contentPadding: EdgeInsets.only(top: 10),
                      callback: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Search()),
                        );
                      },
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 20.sp,
                      ),
                    ),
                  ),
              ],
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  scaffolKey.currentState!.openDrawer();
                },
              )),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(top: 20.0.h),
            child: SizedBox(
              height: 80.0.h,
              width: 80.0.w,
              child: FittedBox(
                child: SizedBox(
                  width: 80.w,
                  height: 80.h,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      if (context.read<AuthProvider>().user != null) {
                        if (context.read<AuthProvider>().user!.isSeller != 0) {
                          context.read<ProductProvider>().clearAddProductFormData();
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddProduct()));
                        } else {
                          utilService.showToast(AppLocalizations.of(context).translate('beSellerForProduct'), ToastGravity.CENTER);
                        }
                      } else {
                        utilService.showDialogue(AppLocalizations.of(context).translate('guestAlert'), context);
                        // Future.delayed(Duration(seconds: 2), () {
                        //   Navigator.of(context).pop();
                        //   Navigator.of(context).pushReplacement(
                        //     MaterialPageRoute(
                        //       builder: (BuildContext context) => LoginPage(),
                        //     ),
                        //   );
                        // });
                      }
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    // elevation: 5.0,
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(30.r), topLeft: Radius.circular(30.r)),
              boxShadow: [
                BoxShadow(color: Colors.black38, spreadRadius: 0.r, blurRadius: 10.r),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0.r),
                topRight: Radius.circular(30.0.r),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedIconTheme: IconThemeData(opacity: 5, color: Colors.black),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                unselectedItemColor: Colors.grey[100],
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: iconss[0]
                          ? Image.asset(
                              'assets/home1.png',
                            )
                          : Image.asset(
                              'assets/home0.png',
                              color: Colors.grey,
                            ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: userLocal == 'ar' ? EdgeInsets.only(left: 50.w) : EdgeInsets.only(right: 50.w),
                      child: SizedBox(
                        //
                        width: 20.w,
                        height: 20.h,
                        child: iconss[1]
                            ? Image.asset(
                                'assets/home_fire2.png',
                              )
                            : Image.asset(
                                'assets/home_fire1.png',
                                // color: Colors.grey,
                              ),
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: userLocal == 'ar' ? EdgeInsets.only(right: 50.w) : EdgeInsets.only(left: 50.w),
                      child: SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: iconss[2]
                            ? Image.asset(
                                'assets/cartblack.png',
                              )
                            : Image.asset(
                                'assets/cart.png',
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: iconss[3]
                          ? Image.asset(
                              'assets/user1.png',
                            )
                          : Image.asset(
                              'assets/user0.png',
                              color: Colors.grey,
                            ),
                    ),
                    label: '',
                    // title: Text('.', style: TextStyle(fontSize: 25)),
                  )
                ],
                currentIndex: _currentIndex,
                onTap: (index) {
                  onTabTapped(index, context);
                }, // onTabTapped,
                selectedItemColor: Colors.black,
              ),
            ),
          )),
    );
  }
}
