// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:laybull_v3/globals.dart';

class AppBlackButton extends StatelessWidget {
  GestureTapCallback onTap;
  String btnText;
  double? width;
  double height;
  AppBlackButton({
    Key? key,
    required this.onTap,
    required this.btnText,
    this.width,
    this.height = 35,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
     
      child: Align(
        alignment:
            userLocal == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          width: width ?? 120,
          height: height.h,
          margin: EdgeInsets.only(bottom: 5.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 2.r,
                blurRadius: 15.r,
              ),
            ],
            borderRadius: BorderRadius.circular(20.0.r),
          ),
          child: Text(
            btnText.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.normal,
              fontFamily: 'aveh',
              letterSpacing: 2.w,
              fontSize: 12.0.sp,
            ),
          ),
        ),
      ),
    );
  }
}
