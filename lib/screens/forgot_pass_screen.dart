// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_black_button.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_text_field.dart';
import 'package:provider/src/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var utilService = locator<UtilService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white10,
        title: Text(
          AppLocalizations.of(context)
              .translate('forgotPassword')
              .toUpperCase(),
          //  style: headingStyle,
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 50.h),
            SizedBox(
              width: 130.w,
              height: 60.h,
              child: Image.asset('assets/loginLogo.png'),
            ),
            SizedBox(height: 50.h),
            AppTextField(
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              hintText:
                  AppLocalizations.of(context).translate('enteryouremail'),
            ),
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.only(right: 20.0.w),
              child: AppBlackButton(
                onTap: () async {
                  if (emailController.text.trim().isNotEmpty) {
                    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.text.trim()) ==
                        false) {
                      utilService.showToast(
                          'Invalid Email', ToastGravity.BOTTOM);
                    } else {
                      await context
                          .read<AuthProvider>()
                          .forgotPassword(emailController.text.trim(), context);
                      // emailController.clear();
                      
                    }
                  } else {
                    utilService.showToast(
                        'Kindly Enter Email', ToastGravity.BOTTOM);
                  }
                },
                btnText: AppLocalizations.of(context).translate('submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
