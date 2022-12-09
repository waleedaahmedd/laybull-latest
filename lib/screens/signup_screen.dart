// ignore_for_file: prefer_final_fields, avoid_unnecessary_containers, prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart' as img;
import 'package:laybull_v3/globals.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/country_model.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/screens/web_laybul.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_black_button.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_text_button.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var _formKey = GlobalKey<FormState>();
  img.ImagePicker obj = img.ImagePicker();
  var isLoading = false;
  var utilService = locator<UtilService>();

  // ImageClass imageFile = ImageClass(isPicked: false, image: null);
  img.XFile? imageFile;
  File? profileImg;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Future.delayed(Duration.zero);
      context.read<AuthProvider>().getCountries(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    context.read<AuthProvider>().clearSignUpFields();
    super.dispose();
  }

  void _showPicker(
    context,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text(
                        "Photo Library",
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text("Camera"),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromGallery() async {
    await obj.pickImage(source: img.ImageSource.gallery, imageQuality: 10).then((img) {
      setState(() {
        if (kDebugMode) {
          print(img);
          print(img!.path);
        }
        imageFile = img;
        profileImg = File(img!.path);
      });
    });
  }

  _imgFromCamera() async {
    await obj.pickImage(source: img.ImageSource.camera, imageQuality: 50).then((img) {
      setState(() {
        print(img);
        print(img!.path);
        imageFile = img;
        profileImg = File(img.path);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: null,
      body: Consumer<AuthProvider>(builder: (context, ap, _) {
        return WillPopScope(
          onWillPop: () async {
            context.read<AuthProvider>().clearSignUpFields();
            return false;
          },
          child: GestureDetector(
            onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),

                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    child: Center(
                                  child: Text(
                                    AppLocalizations.of(context).translate('signUp').toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.w,
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 75.h,
                                  width: 75.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.0.w,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0.r)),
                                  ),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showPicker(
                                          context,
                                        );
                                      },
                                      child: Container(
                                        child: imageFile != null
                                            ? Image.file(
                                                profileImg!,
                                                width: 100.w,
                                                height: 100.h,
                                                fit: BoxFit.fill,
                                              )
                                            : Container(
                                                decoration: BoxDecoration(color: Color(0xFFE5F3FD), borderRadius: BorderRadius.circular(0.r)),
                                                width: 100.w,
                                                height: 100.h,
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 25.h,
                          ),

                          /// First Name+
                          AppTextField(
                            controller: ap.firstNameControllerForSG,
                            hintText: AppLocalizations.of(context).translate('enterFirstName'),
                            textInputType: TextInputType.name,
                            width: (MediaQuery.of(context).size.width / 1.07).w,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          AppTextField(
                            controller: ap.lastNameControllerForSG,
                            hintText: AppLocalizations.of(context).translate('enterLasttName'),
                            textInputType: TextInputType.name,
                            width: (MediaQuery.of(context).size.width / 1.07).w,
                          ),

                          SizedBox(
                            height: 25.h,
                          ),

                          /// Email
                          AppTextField(
                            controller: ap.emailControllerForSG,
                            textInputType: TextInputType.emailAddress,
                            hintText: AppLocalizations.of(context).translate('enterEmail'),
                            width: (MediaQuery.of(context).size.width / 1.07).w,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),

                          /// Password
                          AppTextField(
                            controller: ap.passwordControllerForSG,
                            hintText: AppLocalizations.of(context).translate('enterPassword'),
                            isObscure: true,
                            textInputType: null,
                            width: (MediaQuery.of(context).size.width / 1.07).w,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),

                          /// Phone Number
                          AppTextField(
                            controller: ap.phoneControllerForSG,
                            hintText: AppLocalizations.of(context).translate('enterPhoneNumber'),
                            textInputType: TextInputType.phone,
                            width: (MediaQuery.of(context).size.width / 1.07).w,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),

                          /// Country
                          ap.isCountryFetched == true
                              ? Container(
                                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                  decoration: BoxDecoration(
                                    color: Color(0xfff3f3f4),
                                    // border: Border.all(color:Colors.grey[400]),
                                    borderRadius: BorderRadius.circular(5.0.r),
                                  ),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text(
                                      ap.selectedCountry == null
                                          ? AppLocalizations.of(context).translate('enterCountry')
                                          : ap.selectedCountry!.name!.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: 'aveb',
                                        letterSpacing: 2.2.w,
                                      ),
                                    ),
                                    dropdownColor: Colors.grey[100],
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 20.sp,
                                      color: Colors.black,
                                    ),
                                    iconSize: 12,
                                    underline: SizedBox(),
                                    style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                    value: ap.selectedCountry,
                                    onChanged: (newValue) {
                                      print("value = $ap.selectedCountry");
                                      ap.selectedCountry = newValue as CountryModel?;
                                      setState(() {});
                                    },
                                    items: ap.countries.map((valueItem) {
                                      return DropdownMenuItem(
                                        value: valueItem,
                                        child: Row(
                                          children: <Widget>[
                                            Text(valueItem.name!),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : SizedBox(height: 10.h),
                          SizedBox(
                            height: 25.h,
                          ),

                          /// City
                          AppTextField(
                            controller: ap.cityControllerForSG,
                            hintText: AppLocalizations.of(context).translate('enterCity'),
                            textInputType: TextInputType.name,
                            width: (MediaQuery.of(context).size.width / 1.07).w,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),

                          /// Address
                          AppTextField(
                            controller: ap.addressControllerForSG,
                            textInputType: TextInputType.streetAddress,
                            hintText: AppLocalizations.of(context).translate('enterAddress'),
                            width: (MediaQuery.of(context).size.width / 1.07).w,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context).translate('becomeSeller'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                  letterSpacing: 2.2.w,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Checkbox(
                                  value: ap.isSeller,
                                  activeColor: Colors.black,
                                  checkColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() {
                                      log(value.toString());
                                      ap.isSeller = value!;
                                      ap.accountNumberControllerForSG.clear();
                                      ap.accountNameControllerForSG.clear();
                                      ap.accountHolderPhoneControllerForSG.clear();
                                      ap.bankNameControllerForSG.clear();
                                    });
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: ap.isSeller ? 25.h : 0,
                          ),
                          ap.isSeller
                              ? Column(
                                  children: [
                                    /// Bank Name
                                    AppTextField(
                                      controller: ap.bankNameControllerForSG,
                                      hintText: AppLocalizations.of(context).translate('enterBankName'),
                                      width: MediaQuery.of(context).size.width / 1.07,
                                    ),

                                    SizedBox(
                                      height: 25.h,
                                    ),

                                    /// IBAN
                                    AppTextField(
                                      controller: ap.ibanNumberControllerForSG,
                                      hintText: AppLocalizations.of(context).translate('enterIban'),
                                      width: (MediaQuery.of(context).size.width / 1.07).w,
                                    ),

                                    SizedBox(
                                      height: 25.h,
                                    ),

                                    /// Account Number
                                    AppTextField(
                                      controller: ap.accountNumberControllerForSG,
                                      hintText: AppLocalizations.of(context).translate('enterAccountNumber'),
                                      textInputType: null,
                                      width: (MediaQuery.of(context).size.width / 1.07).w,
                                    ),
                                    SizedBox(
                                      height: 25.h,
                                    ),

                                    /// Account Holder Name
                                    AppTextField(
                                      controller: ap.accountNameControllerForSG,
                                      hintText: AppLocalizations.of(context).translate('enterAccountHolderName'),
                                      width: (MediaQuery.of(context).size.width / 1.07).w,
                                    ),
                                    SizedBox(
                                      height: 25.h,
                                    ),

                                    GestureDetector(
                                      onTap: () async {
                                        final Uri url = Uri.parse("https://laybull.com/data-collection-policy");
                                        // ignore: deprecated_member_use
                                        if (!await launchUrl(url)) {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 12.0.w),
                                        child: Text(AppLocalizations.of(context).translate('whyWeNeedThis'),
                                            style: TextStyle(
                                                color: Color(
                                                  0xff5DB3F5,
                                                ),
                                                decoration: TextDecoration.underline)),
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 50.h,
                          ),

                          /// SignUp Button
                          ap.isCountryFetched == false
                              ? Align(
                                  alignment: userLocal == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
                                  child: Container(
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
                                    width: 200.0,
                                    height: 40.0,
                                    child: Center(
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.white,
                                        highlightColor: Colors.grey,
                                        child: Text(
                                          'Country Fetching'.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : AppBlackButton(
                                  onTap: () async {
                                    await ap.signUp(
                                      firstName: ap.firstNameControllerForSG.text.trim(),
                                      lastName: ap.lastNameControllerForSG.text.trim(),
                                      email: ap.emailControllerForSG.text.trim(),
                                      password: ap.passwordControllerForSG.text.trim(),
                                      phoneNumber: ap.phoneControllerForSG.text.trim(),
                                      country: ap.selectedCountry != null ? ap.selectedCountry!.name ?? '' : '',
                                      city: ap.cityControllerForSG.text.trim(),
                                      address: ap.addressControllerForSG.text.trim(),
                                      becomeSeller: ap.isSeller,
                                      context: context,
                                      bankName: ap.isSeller ? ap.bankNameControllerForSG.text.trim() : '',
                                      profilePic: profileImg,
                                      IBAN: ap.isSeller ? ap.ibanNumberControllerForSG.text.trim() : '',
                                      accountHolderName: ap.isSeller ? ap.accountNameControllerForSG.text.trim() : '',
                                      accountNumber: ap.isSeller ? ap.accountNumberControllerForSG.text.trim() : '',
                                    );
                                  },
                                  btnText: 'Sign Up',
                                ),

                          SizedBox(
                            height: 10.h,
                          ),

                          /// Go to Login Page Button
                          AppWhiteButton(
                            onTap: () {
                              context.read<AuthProvider>().clearSignUpFields();
                              Navigator.pop(context);
                            },
                            btnText: AppLocalizations.of(context).translate('alreadyHaveAccount'),
                          ),
                          GestureDetector(
                            onTap: () {
                              String url = "https://laybull.com/policy/#terms";
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebLaybull(url)));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                              // constraints: BoxConstraints(maxWidth: 80),
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                AppLocalizations.of(context).translate('regulationForAccount').toUpperCase(),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: const Color(0XFF878787),
                                  letterSpacing: 2.w,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Metropolis',
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 40.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
