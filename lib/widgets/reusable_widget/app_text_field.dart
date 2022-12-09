import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  Widget? suffixIcon;
  double? width;
  TextInputType? textInputType;
  bool isReadyOnly;
  VoidCallback? callback;
  double? height;
  EdgeInsetsGeometry? contentPadding;
  bool isObscure;

  AppTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.height = 55,
    this.suffixIcon,
    this.contentPadding,
    this.textInputType = TextInputType.name,
    this.width,
    this.isReadyOnly = false,
    this.callback,
    this.isObscure = false,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5.w,
      ),
      child: Container(
        width: widget.width ?? (MediaQuery.of(context).size.width / 1.1).w,
        height: widget.height,
        alignment: Alignment.center,
        child: TextField(
          onTap: widget.callback,
          readOnly: widget.isReadyOnly,
          keyboardType: widget.textInputType,
          obscureText: widget.isObscure,
          controller: widget.controller,
          style: TextStyle(
            fontSize: 15.sp,
            fontFamily: 'aveb',
            letterSpacing: 2.2.w,
          ),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            prefixIcon: widget.suffixIcon,
            hintText: widget.hintText,
            contentPadding: widget.contentPadding,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              borderSide: BorderSide(color: Colors.black, width: 0.w, style: BorderStyle.none),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              borderSide: BorderSide(color: Colors.black, width: 0.w, style: BorderStyle.none),
            ),
            fillColor: const Color(0xfff3f3f4),
            filled: true,
          ),
        ),
      ),
    );
  }
}
