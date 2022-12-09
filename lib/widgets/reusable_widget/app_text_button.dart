// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppWhiteButton extends StatelessWidget {
  GestureTapCallback onTap;
  String btnText;

  double? width;
  double height;
  double size;
  AppWhiteButton({
    Key? key,
    required this.onTap,
    required this.btnText,
    this.width,
    this.height = 35,
    this.size = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              btnText.toUpperCase(),
              style: TextStyle(
                fontSize: size.sp,
                color: const Color(0XFF878787),
                letterSpacing: 2.w,
                fontWeight: FontWeight.w600,
                fontFamily: 'Metropolis',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
