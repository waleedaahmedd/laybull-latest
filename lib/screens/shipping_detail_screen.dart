// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/country_model.dart';
import 'package:laybull_v3/models/shipping_mode.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class ShippingDetailsScreen extends StatefulWidget {
  @override
  _ShippingDetailsScreenState createState() => _ShippingDetailsScreenState();
}

class _ShippingDetailsScreenState extends State<ShippingDetailsScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isEdit = false;
  var _formKey = GlobalKey<FormState>();
  var utilService = locator<UtilService>();
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Future.delayed(Duration.zero);
      context.read<AuthProvider>().getCountries(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, ap, _) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Shipping Details".toUpperCase(), style: headingStyle),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isEdit = !isEdit;
                  });
                  if (ap.user!.shippingDetail != null) {
                    addressController.text = ap.user!.shippingDetail!.address!;
                    cityController.text = ap.user!.shippingDetail!.city!;
                    ap.selectedCountry = ap.countries.firstWhere((element) =>
                        element.name == ap.user!.shippingDetail!.country);
                    phoneController.text =
                        ap.user!.shippingDetail!.phone_number!;
                    setState(() {});
                  }
                },
                icon: Icon(
                  Icons.edit, //: Icons.add,
                  color: Colors.black,
                )),
          ],
        ),
        body: isEdit
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text("Shipping Address"),
                        SizedBox(height: 20.h),
                        Text(
                          "Address".toUpperCase(),
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 2.w,
                              fontFamily: "MetropolisExtraBold"),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          child: TextFormField(
                            controller: addressController,
                            maxLines: 4,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Shipping Address";
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: 'Metropolis',
                                letterSpacing: 2.2.w),
                            decoration: InputDecoration(
                              hintText: "Address",
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          "City".toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 2.w,
                            fontFamily: "MetropolisExtraBold",
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          child: TextFormField(
                            controller: cityController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "City";
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: 'Metropolis',
                              letterSpacing: 2.2.w,
                            ),
                            decoration: InputDecoration(
                              hintText: "City",
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),

                        SizedBox(height: 10.h),
                        // isCityFetched
                        //     ?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                AppLocalizations.of(context)
                                    .translate('country')
                                    .toUpperCase(),
                                style: Textprimary),
                            SizedBox(
                              height: 15.h,
                            ),
                            context.read<AuthProvider>().isCountryFetched ==
                                    true
                                ? Container(
                                    padding: EdgeInsets.only(
                                        left: 10.w, right: 10.w),
                                    decoration: BoxDecoration(
                                      color: Color(0xfff3f3f4),
                                      // border: Border.all(color:Colors.grey[400]),
                                      borderRadius:
                                          BorderRadius.circular(5.0.r),
                                    ),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: Text(
                                        context
                                                    .read<AuthProvider>()
                                                    .selectedCountry ==
                                                null
                                            ? AppLocalizations.of(context)
                                                .translate('enterCountry')
                                            : context
                                                .read<AuthProvider>()
                                                .selectedCountry!
                                                .name!
                                                .toUpperCase(),
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
                                      iconSize: 12.sp,
                                      underline: SizedBox(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.sp),
                                      value: context
                                          .read<AuthProvider>()
                                          .selectedCountry,
                                      onChanged: (newValue) {
                                        if (kDebugMode) {
                                          print(
                                              "value = ${context.read<AuthProvider>().selectedCountry}");
                                        }
                                        context
                                                .read<AuthProvider>()
                                                .selectedCountry =
                                            newValue as CountryModel?;
                                        setState(() {});
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
                                  )
                                : SizedBox(height: 10.h),
                            /*       Container(
                                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400]!),
                                  borderRadius: BorderRadius.circular(5.0.r),
                                ),
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text(AppLocalizations.of(context)
                                      .translate('country')),
                                  dropdownColor: Colors.grey[100],
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    size: 20.sp,
                                    color: Colors.black,
                                  ),
                                  iconSize: 12.sp,
                                  underline: SizedBox(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                  ),
                                  // value: _selectedCountry,
                                  onChanged: (newValue) {},
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
                      */
                          ],
                        ),
                        //     : SizedBox(),

                        SizedBox(height: 30.h),
                        Text(
                          "Phone Number".toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 2.w,
                            fontFamily: "MetropolisExtraBold",
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          child: TextFormField(
                            controller: phoneController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter  Phone Number";
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: 'Metropolis',
                              letterSpacing: 2.2.w,
                            ),
                            decoration: InputDecoration(
                              hintText: "Phone Number",
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: () async {
                            if (addressController.text.isNotEmpty &&
                                cityController.text.trim().isNotEmpty &&
                                phoneController.text.trim().isNotEmpty &&
                                ap.selectedCountry != null) {
                              ShippingModel shippingModel = ShippingModel(
                                address: addressController.text.trim(),
                                city: cityController.text.trim(),
                                country: 'United Arab Emirates',
                                phone_number: phoneController.text.trim(),
                              );
                              ap.user!.shippingDetail != null
                                  ? await ap.updateShippingDetail(
                                      shippingModel, context)
                                  : await ap.addShippingDetail(
                                      shippingModel, context);
                              setState(() {
                                isEdit = !isEdit;
                              });
                            } else {
                              utilService.showToast(
                                'Kindly Fill All Fields',
                                ToastGravity.BOTTOM,
                              );
                            }
                          },
                          child: Container(
                            height: 45.h,
                            margin: EdgeInsets.only(bottom: 15.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5.0.r),
                            ),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('updateShippingAddress')
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2.w,
                                fontFamily: "MetropolisExtraBold",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : context.read<AuthProvider>().user!.shippingDetail == null
                ? Center(
                    child: TextButton(
                      child: Text("Add Shipping Detail"),
                      onPressed: () {
                        setState(() {
                          isEdit = !isEdit;
                        });
                      },
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: 30.h,
                      left: 30.w,
                      right: 30.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Adddress".toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 2.w,
                            fontFamily: "MetropolisExtraBold",
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "${ap.user!.shippingDetail!.address}",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              letterSpacing: 2.w,
                              fontFamily: "MetropolisExtraBold"),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate('city')
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 2.w,
                            fontFamily: "MetropolisExtraBold",
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "${ap.user!.shippingDetail!.city}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            letterSpacing: 2.w,
                            fontFamily: "MetropolisExtraBold",
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          AppLocalizations.of(context)
                              .translate('country')
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 2.w,
                            fontFamily: "MetropolisExtraBold",
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "${ap.user!.shippingDetail!.country}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            letterSpacing: 2.w,
                            fontFamily: "MetropolisExtraBold",
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          AppLocalizations.of(context)
                              .translate('phoneNumber')
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 2.w,
                            fontFamily: "MetropolisExtraBold",
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "${ap.user!.shippingDetail!.phone_number}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            letterSpacing: 2.w,
                            fontFamily: "MetropolisExtraBold",
                          ),
                        ),
                      ],
                    ),
                  ),
      );
    });
  }
}
