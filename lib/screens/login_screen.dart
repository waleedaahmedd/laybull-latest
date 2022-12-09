import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laybull_v3/globals.dart';
import 'package:laybull_v3/loader/loader.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/screens/forgot_pass_screen.dart';
import 'package:laybull_v3/screens/main_dashboard_screen.dart';
import 'package:laybull_v3/screens/signup_screen.dart';
import 'package:laybull_v3/util_services/routes.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_black_button.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_text_button.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_text_field.dart';
import 'package:laybull_v3/widgets/reusable_widget/jumping_dots.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UtilService? utilService = locator<UtilService>();
  bool isFetching = false;

  MyProgressDialog? pr;

  @override
  void initState() {
    utilService!.checkConnection();
    super.initState();
  }

  @override
  void dispose() {
    context.read<AuthProvider>().clearSignUpFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Consumer<AuthProvider>(builder: (context, ap, _) {
                    return Container(
                      // margin: EdgeInsets.only(top: 50.h),
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: isFetching == true
                                      ? SizedBox(
                                          width: 100.w,
                                          height: 20.h,
                                          child: const JumpingDots(
                                            isLoadingShow: false,
                                          ))
                                      : GestureDetector(
                                          onTap: () async {
                                            try {
                                              if (context.read<ProductProvider>().homeData == null) {
                                                setState(() {
                                                  isFetching = true;
                                                });
                                                if (context.read<ProductProvider>().homeData == null) {
                                                  await context.read<ProductProvider>().getGuestHomeProducts();
                                                }
                                                if (context.read<ProductProvider>().homeSlider.isEmpty) {
                                                  await context.read<ProductProvider>().getHomeSlider();
                                                }
                                                setState(() {
                                                  isFetching = false;
                                                });
                                              }

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) {
                                                  return BottomNav(
                                                    navIndex: 0,
                                                  );
                                                }),
                                              );
                                            } catch (err) {
                                              setState(() {
                                                isFetching = false;
                                              });
                                              utilService!.showToast('Internal Server Error', ToastGravity.BOTTOM);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                AppLocalizations.of(context).translate('asGuest').toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: const Color(0XFF878787),
                                                  letterSpacing: 2.w,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Metropolis',
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.grey,
                                              )
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.only(top: 18.0.h),
                              child: SizedBox(
                                width: 130,
                                height: 60,
                                child: Image.asset('assets/loginLogo.png'),
                              ),
                            ),
                            SizedBox(height: 40.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).translate('logIn').toUpperCase(),
                                  // 'Login',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2.w,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                AppTextField(
                                  controller: ap.emailControllerForLogin,
                                  textInputType: TextInputType.emailAddress,
                                  hintText: AppLocalizations.of(context).translate('enterEmail'),
                                ),
                                SizedBox(height: 10.h),
                                AppTextField(
                                  controller: ap.passwordControllerForLogin,
                                  textInputType: null,
                                  hintText: AppLocalizations.of(context).translate('enterPassword'),
                                  isObscure: true,
                                ),
                                SizedBox(height: 10.h),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ForgotPassword();
                                      }),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 4.h),
                                    child: Text(
                                      AppLocalizations.of(context).translate('forgotPassword').toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: const Color(0XFF878787),
                                        letterSpacing: 2.w,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Metropolis',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            AppBlackButton(
                              onTap: () async {
                                if (ap.emailControllerForLogin.text.trim().isNotEmpty && ap.passwordControllerForLogin.text.trim().isNotEmpty) {
                                  if (ap.passwordControllerForLogin.text.length >= 8) {
                                    pr = MyProgressDialog(context);
                                    await pr!.show();
                                    await ap.login(ap.emailControllerForLogin.text, ap.passwordControllerForLogin.text, context);
                                  } else {
                                    utilService!.showToast('Password length should be atleast 8 character', ToastGravity.BOTTOM);
                                  }
                                } else {
                                  utilService!.showToast('Kindly fill all fields', ToastGravity.BOTTOM);
                                }
                              },
                              btnText: AppLocalizations.of(context).translate('logIn'),
                              width: 120,
                              height: 35.h,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Center(
                              child: AppWhiteButton(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return Signup();
                                    }),
                                  );
                                },
                                btnText: AppLocalizations.of(context).translate('registerAccount'),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ));
  }
}
