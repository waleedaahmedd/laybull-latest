// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields, prefer_const_constructors, curly_braces_in_flow_control_structures, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/globals.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/country_model.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/reusable_widget/jumping_dots.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BecomeSeller extends StatefulWidget {
  final int userId;
  const BecomeSeller({
    Key? key,
    required this.userId,
  }) : super(key: key);
  @override
  BecomeSellerState createState() => BecomeSellerState();
}

class BecomeSellerState extends State<BecomeSeller> {
  var utilService = locator<UtilService>();
  // var _firstName =
  //     TextEditingController(text: userData['detail']['fname'] ?? '');
  // var _lastName =
  //     TextEditingController(text: userData['detail']['lname'] ?? '');
  var _accountName = TextEditingController();
  var _accountNumber = TextEditingController();
  var _ibanNumber = TextEditingController();
  // var _email = TextEditingController(text: userEmail);
  // var _city = TextEditingController(text: userShipmentCity ?? '');
  // var _age = TextEditingController();
  var _phoneNumber = TextEditingController(text: userShipmentPhone ?? '');
  var _bankName = TextEditingController();
  var _sellerFormKey = GlobalKey<FormState>();
  // var dob;
  // String _country = '';
  // CountryModel? selectedCountry;

  // bool isCityFetched = false;

  // _pickDateOfBirth() async {
  //   //current datetime
  //   var now = DateTime.now();
  //   DateTime pickedDate = DateTime.now();
  //   DateTime? date = await showDatePicker(
  //     context: context,
  //     initialDate: pickedDate,
  //     firstDate: DateTime(pickedDate.year - 100),
  //     lastDate: DateTime(pickedDate.year + 1),
  //   );

  //   dob = date.toString();

  //   _age.text = (int.parse(DateFormat.y().format(now)) -
  //           int.parse(DateFormat.y().format(date!)))
  //       .toString();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.read<AuthProvider>().isbecomingSeller == true
            ? null
            : IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        title: Text(
            AppLocalizations.of(context)
                .translate('accountDetails')
                .toUpperCase(),
            style: headingStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.h),
        child: ListView(
          children: [
            Form(
              key: _sellerFormKey,
              child: Column(
                children: [
                  /// full Name
                  /*             SizedBox(
                    width: (MediaQuery.of(context).size.width / 1.07).w,
                    child: TextFormField(
                      controller: _firstName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('enterFirstName');
                        }
                        return null;
                      },
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontFamily: 'Metropolis',
                          letterSpacing: 2.2.w),
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate('firstName'),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 1.07).w,
                    child: TextFormField(
                      controller: _lastName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('enterLasttName');
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Metropolis',
                        letterSpacing: 2.2.w,
                      ),
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate('lastName'),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  //bank name

                  Container(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    decoration: BoxDecoration(
                      color: Color(0xfff3f3f4),
                      // border: Border.all(color:Colors.grey[400]),
                      borderRadius: BorderRadius.circular(5.0.r),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Text(
                          AppLocalizations.of(context).translate('country')),
                      dropdownColor: Colors.grey[100],
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 20.sp,
                        color: Colors.black,
                      ),
                      iconSize: 12.sp,
                      underline: SizedBox(),
                      style: TextStyle(color: Colors.black, fontSize: 15.sp),
                      value: selectedCountry,
                      onChanged: (newValue) {
                        setState(() {
                          print("value = $selectedCountry");
                          selectedCountry = newValue as CountryModel;
                          _country = selectedCountry!.name!;
                          print(_country);
                        });
                      },
                      items: context
                          .read<AuthProvider>()
                          .countries
                          .map((valueItem) {
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
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width / 1.07).w,
                    child: TextFormField(
                      controller: _city,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('enterCity');
                        }
                        return null;
                      },
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontFamily: 'Metropolis',
                          letterSpacing: 2.2.w),
                      decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context).translate('city'),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: _pickDateOfBirth,
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width / 1.07).w,
                      child: TextFormField(
                        enabled: false,
                        controller: _age,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate('enterAge');
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontFamily: 'Metropolis',
                          letterSpacing: 2.2.w,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context).translate('age'),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 1.07).w,
                    child: TextFormField(
                      enabled: false,
                      controller: _email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('enterEmail');
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Metropolis',
                        letterSpacing: 2.2.w,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context).translate('email'),
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
*/
                  /// Account Holder Phone Number
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 1.07).w,
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _phoneNumber,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate('enterPhoneNumber');
                          }
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 15.sp,
                            // fontFamily: 'Metropolis',
                            letterSpacing: 2.2.w),
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('phoneNumber'),
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 1.07).w,
                    child: TextFormField(
                      controller: _bankName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('enterBankName');
                        }
                        return null;
                      },
                      style: TextStyle(
                          fontSize: 15.sp,
                          // fontFamily: 'Metropolis',
                          letterSpacing: 2.2.w),
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate('bankName'),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),

                  /// IBAN
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 1.07).w,
                    child: TextFormField(
                        controller: _ibanNumber,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate('enterIban');
                          }
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 15.sp,
                            // fontFamily: 'Metropolis',
                            letterSpacing: 2.2.w),
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context).translate('iban'),
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),

                  /// Account Number
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 1.07).w,
                    child: TextFormField(
                        controller: _accountNumber,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate('enterAccountNumber');
                          }
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 15.sp,
                            // fontFamily: 'Metropolis',
                            letterSpacing: 2.2.w),
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('accountNumber'),
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),

                  /// Account Holder Name
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 1.07).w,
                    child: TextFormField(
                        controller: _accountName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate('enterAccountHolderName');
                          }
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 15.sp,
                            // fontFamily: 'Metropolis',
                            letterSpacing: 2.2.w),
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('accountHolderName'),
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    String url = "https://laybull.com/data-collection-policy";
                    if (await canLaunch(url))
                      await launch(url);
                    else
                      utilService.showToast(
                          AppLocalizations.of(context).translate('linkFailed'),
                          ToastGravity.CENTER);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.0.w),
                    child: Text(
                        AppLocalizations.of(context).translate('whyWeNeedThis'),
                        style: TextStyle(
                            color: Color(
                              0xff5DB3F5,
                            ),
                            decoration: TextDecoration.underline)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Consumer<AuthProvider>(builder: (context, ap, _) {
              return InkWell(
                onTap: () async {
                  if (_phoneNumber.text.trim().isEmpty) {
                    utilService.showToast(
                        'Kindly Enter Phone Number.', ToastGravity.CENTER);
                    return;
                  }
                  if (_accountName.text.trim().isEmpty) {
                    utilService.showToast(
                        'Kindly Enter Account Name', ToastGravity.CENTER);
                    return;
                  }
                  if (_ibanNumber.text.trim().isEmpty) {
                    utilService.showToast(
                        'Kindly Enter IBAN Number', ToastGravity.CENTER);
                    return;
                  }
                  if (_accountNumber.text.trim().isEmpty) {
                    utilService.showToast(
                        'Kindly Enter Account Number', ToastGravity.CENTER);
                    return;
                  }
                  if (_bankName.text.trim().isEmpty) {
                    utilService.showToast(
                        'Kindlu Enter Bank Name', ToastGravity.CENTER);
                    return;
                  }

                  await context.read<AuthProvider>().becomeSeller(
                        phoneNumber: int.parse(
                          _phoneNumber.text.trim(),
                        ),
                        accountHolderName: _accountName.text.trim(),
                        accountBankName: _bankName.text.trim(),
                        IBAN: _ibanNumber.text.trim(),
                        accountNumber: _accountNumber.text.trim(),
                        context: context,
                      );
                },
                child: Container(
                    width: (MediaQuery.of(context).size.width / 1.07).w,
                    height: 45.h,
                    margin: EdgeInsets.only(bottom: 5.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5.0.r),
                    ),
                    child: ap.isbecomingSeller == false
                        ? Text(
                            AppLocalizations.of(context)
                                .translate('save')
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2.w,
                              // fontFamily: "MetropolisExtraBold",
                            ),
                          )
                        : JumpingDots(
                            numberOfDots: 4,
                            isLoadingShow: false,
                          )),
              );
            }),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
