// ignore_for_file: prefer_const_constructors_in_immutables, prefer_final_fields, prefer_const_constructors, use_key_in_widget_constructors

import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/extensions.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/models/bid_model.dart';
import 'package:laybull_v3/models/bid_product.dart';
import 'package:laybull_v3/models/country_model.dart';
import 'package:laybull_v3/models/product_detail_model.dart';
import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/models/user_model.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/providers/payment_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/screens/web_laybul.dart';
import 'package:laybull_v3/util_services/http_service.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';
import 'package:laybull_v3/widgets/reusable_widget/item_with_chip_widget.dart';
import 'package:provider/provider.dart';

import 'package:provider/src/provider.dart';

import '../globals.dart';

class ConfirmAddress extends StatefulWidget {
  final double bidProductPrice;
  final int bidProductId;
  final ProductDetail? product;
  final BidProduct? bidProduct;

  ConfirmAddress({
    required this.bidProductPrice,
    required this.bidProductId,
    this.product,
    this.bidProduct,
  });
  @override
  _ConfirmAddressState createState() => _ConfirmAddressState();
}

class _ConfirmAddressState extends State<ConfirmAddress> {
  var utilService = locator<UtilService>();
  var httpService = locator<HttpService>();
  var _fname = TextEditingController();
  var _lname = TextEditingController();
  var _phone = TextEditingController();
  var _email = TextEditingController();
  var _address1 = TextEditingController();
  var _address2 = TextEditingController();
  CountryModel? _selectedCountry;
  CountryModel? country;
  String? paymnetLink;
  // bool isCityFetched = true;
  TextEditingController _city = TextEditingController();
  TextEditingController _discountCode = TextEditingController();
  double couponValue = 0.0;
  bool isDiscountVerified = true;
  double prodPrice = 0.0;
  String highestBid = '0';
  late UserModel user;
  Timer? _timer;

  double totalPrice(
    double productPrice,
  ) =>
      productPrice + deliveryCharges - couponValue;

  @override
  void initState() {
    super.initState();
    user = context.read<AuthProvider>().user!;
    _fname.text = user.first_name;
    _lname.text = user.last_name;
    _phone.text = user.shippingDetail?.phone_number ?? '';
    _email.text = user.email.toString();
    _address1.text = user.shippingDetail?.address ?? '';
    _city.text = user.shippingDetail?.city ?? '';
  }

  bool showSummery = false;
  bool showAddress = true;
  bool showComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     iconTheme: IconThemeData(color: Colors.black),
      //     elevation: 0,
      //     backgroundColor: Colors.white10,
      //     title: Text(
      //       'Shipping'.toUpperCase(),
      //       style: headingStyle,
      //     )),
      // resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 7,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: showSummery ? Colors.black : Colors.grey,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 7,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 2,
                ),
                CircleAvatar(
                  backgroundColor: showComplete ? Colors.black : Colors.grey,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 7,
                  ),
                ),
              ],
            ),
            if (showSummery && showAddress /*&& !showComplete*/)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('orderSummary'),
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'MetropolisExtraBold',
                        letterSpacing: 2.w,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: widget.bidProduct == null ? widget.product!.featuredImage! : widget.bidProduct!.featured_image!,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 130.w,
                              width: 130.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(color: Colors.grey, value: downloadProgress.progress)),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.bidProduct == null ? widget.product!.name.toString() : widget.bidProduct!.name!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MetropolisExtraBold',
                                  fontSize: 15.sp,
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Text(
                                widget.bidProduct == null
                                    ? '${widget.product!.price!.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'
                                    : '${widget.bidProductPrice.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'
                                        .toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MetropolisExtraBold',
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Discount Code
                        Text('Discount Code'.toUpperCase(), style: Textprimary),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                // height: 50.h,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                                child: TextField(
                                    controller: _discountCode,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 10.w),
                                      fillColor: Color(0xfff3f3f4),
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await httpService.verifyCupon({
                                  "coupon_name": _discountCode.text,
                                }).then((response) {
                                  if (response.data['data']['discount_percentage'] > 0) {
                                    if (widget.product != null) {
                                      setState(() {
                                        couponValue = (widget.product!.price! * response.data['data']['discount_percentage']) / 100;
                                      });
                                    } else {
                                      setState(() {
                                        couponValue = (widget.bidProductPrice * response.data['data']['discount_percentage']) / 100;
                                      });
                                    }
                                    utilService.showToast('Discount Code Verified', ToastGravity.TOP);
                                  }
                                });
                              },
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5.r)),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                ),
                                child: Center(
                                  child: Text(
                                    isDiscountVerified ? 'Verified' : 'Verify',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 2.w,
                                        fontFamily: "MetropolisExtraBold"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SubTotal'.toUpperCase(),
                              style: Textprimary,
                            ),
                            widget.product != null
                                ? Text(
                                    '${widget.product!.price!.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        letterSpacing: 2.w,
                                        fontFamily: "MetropolisExtraBold"),
                                  )
                                : Text(
                                    '${widget.bidProductPrice.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        letterSpacing: 2.w,
                                        fontFamily: "MetropolisExtraBold"),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delievery Charges'.toUpperCase() + " :",
                              style: Textprimary,
                            ),
                            Text(
                              '${deliveryCharges.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
                            ),
                          ],
                        ),
                        if (isDiscountVerified) ...[
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount'.toUpperCase() + " :",
                                style: Textprimary,
                              ),
                              Text(
                                '- ${couponValue.convertToLocal(context)} ${context.read<CurrencyProvider>().selectedCurrency}'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.red, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
                              ),
                            ],
                          )
                        ],
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total'.toUpperCase() + " :",
                              style: Textprimary,
                            ),
                            widget.product != null
                                ? Text(
                                    '${totalPrice(widget.product!.price!).convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        letterSpacing: 2.w,
                                        fontFamily: "MetropolisExtraBold"),
                                  )
                                : Text(
                                    '${totalPrice(widget.bidProductPrice).convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        letterSpacing: 2.w,
                                        fontFamily: "MetropolisExtraBold"),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    GestureDetector(
                      onTap: () async {
                        showComplete = true;
                        setState(() {});
                        if (widget.product != null) {
                          int totalAmount = totalPrice(widget.product!.price!).convertToLocal(context).round();
                          await context.read<PaymentProvider>().buyNowPayment(
                                widget.product!.id!,
                                totalAmount,
                                context,
                              );
                        } else {
                          int totalAmount = totalPrice(widget.bidProductPrice).convertToLocal(context).round();
                          await context.read<PaymentProvider>().buyNowPayment(
                                widget.bidProductId,
                                totalAmount,
                                context,
                              );
                        }
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 1.07).w,
                        height: 45.h,
                        margin: EdgeInsets.only(bottom: 5.h),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          // color: isCityFetched ? Colors.black : Colors.grey,
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5.0.r),
                        ),
                        child: Text(
                          AppLocalizations.of(context).translate('checkout').toUpperCase(),
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
            if (!showSummery && showAddress /*&& !showComplete*/)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('shippingDetails'),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MetropolisExtraBold',
                            letterSpacing: 2.w,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),

                        /// First Name
                        Text(
                          'First Name'.toUpperCase() + ' *',
                          style: Textprimary,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        Container(
                          // height: 50.h,
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                          child: TextField(
                              controller: _fname,
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10.w),
                                fillColor: Color(0xfff3f3f4),
                              )),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        /// Last Name
                        Text(
                          'Last Name'.toUpperCase() + ' *',
                          style: Textprimary,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey[400]!)),
                          child: TextField(
                              controller: _lname,
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10.w),
                                fillColor: Color(0xfff3f3f4),
                              )),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        /// Email
                        Text(
                          'Email'.toUpperCase(),
                          style: Textprimary,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                          child: TextField(
                              enabled: false,
                              controller: _email,
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10.w),
                                fillColor: Color(0xfff3f3f4),
                              )),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        /// Phone Number
                        Text('Phone Number'.toUpperCase() + ' *', style: Textprimary),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                          child: TextField(
                              controller: _phone,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10.w),
                                fillColor: Color(0xfff3f3f4),
                              )),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        /// Address 1
                        Text('Address 1'.toUpperCase() + ' *', style: Textprimary),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                          child: TextField(
                              controller: _address1,
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10.w),
                                fillColor: Color(0xfff3f3f4),
                              )),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        /// Address 2
                        Text('Address 2'.toUpperCase(), style: Textprimary),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                          child: TextField(
                              controller: _address2,
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10.w),
                                fillColor: Color(0xfff3f3f4),
                              )),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        /// Country
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Country'.toUpperCase() + ' *', style: Textprimary),
                            SizedBox(
                              height: 15.h,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text('Country'),
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
                                value: _selectedCountry,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCountry = newValue as CountryModel;
                                  });
                                },
                                items: context.read<AuthProvider>().countries.map((valueItem) {
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
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        /// City
                        Text('City'.toUpperCase() + ' *', style: Textprimary),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          // height: 50.h,
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                          child: TextField(
                              controller: _city,
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10.w),
                                fillColor: Color(0xfff3f3f4),
                              )),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        InkWell(
                          onTap: () async {
                            if (_fname.text.isEmpty) {
                              utilService.showToast('Please enter first name', ToastGravity.TOP);
                              return;
                            }
                            if (_lname.text.isEmpty) {
                              utilService.showToast('Please enter last name', ToastGravity.TOP);
                              return;
                            }
                            if (_phone.text.isEmpty) {
                              utilService.showToast('Please enter phone number', ToastGravity.TOP);
                              return;
                            }
                            if (_address1.text.isEmpty) {
                              utilService.showToast('Please enter address', ToastGravity.TOP);
                              return;
                            }
                            if (_selectedCountry?.name == null) {
                              utilService.showToast('Please select country', ToastGravity.TOP);
                              return;
                            }
                            if (_city.text.isEmpty) {
                              utilService.showToast('Please enter city', ToastGravity.TOP);
                              return;
                            }
                            showSummery = true;
                            setState(() {});
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
                            child: Text(
                              AppLocalizations.of(context).translate('proceedCheckout').toUpperCase(),
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
                        SizedBox(
                          height: 30.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          /*  if (showSummery && showAddress && showComplete)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80.sp,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('thankYouForYor').toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      // fontFamily: 'MetropolisExtraBold',
                      letterSpacing: 2.w,
                      fontSize: 17.sp,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('purchase').toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MetropolisExtraBold',
                      letterSpacing: 2.w,
                      fontSize: 25.sp,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('confirmationText').toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      // fontFamily: 'MetropolisExtraBold',
                      // letterSpacing: 2.w,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  Container(
                    child: Consumer<ProductProvider>(builder: (context, pp, _) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                AppLocalizations.of(context).translate('recommendation').toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontFamily: 'MetropolisExtraBold',
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          LimitedBox(
                            maxHeight: 210.h,
                            child: pp.homeData!.laybullPicks != null || pp.homeData!.laybullPicks!.isNotEmpty
                                ? ListView.separated(
                                    padding: EdgeInsets.only(bottom: 0.h),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: pp.homeData!.laybullPicks!.length,
                                    separatorBuilder: (context, index) => SizedBox(
                                          width: 10.w,
                                        ),
                                    itemBuilder: (context, index) {
                                      return ItemWithPriceChip(
                                        dateShow: false,
                                        onTap: () async {
                                          if (context.read<AuthProvider>().user != null) {
                                            await pp.getProductDetail(pp.homeData!.laybullPicks![index].id!, context, false);
                                          } else {
                                            await pp.getGuestProductDetail(pp.homeData!.laybullPicks![index].id!, context, false);
                                          }
                                        },
                                        fireOnTap: () async {},
                                        key: UniqueKey(),
                                        productsModel: pp.homeData!.laybullPicks![index],
                                      );
                                    })
                                : Container(),
                          ),
                        ], //
                      );
                    }),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('continueShopping').toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        // letterSpacing: 1.5,
                        // fontFamily: 'MetropolisExtraBold',
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              )*/
          ],
        ),
      ),
    );
  }
}


//  ListView(
//           children: [
//             /// First Name
//             Text(
//               'First Name'.toUpperCase() + ' *',
//               style: Textprimary,
//             ),
//             SizedBox(
//               height: 15.h,
//             ),
//             Container(
//               height: 50.h,
//               width: (MediaQuery.of(context).size.width / 1.07).w,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
//               child: TextField(
//                   controller: _fname,
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.only(left: 10.w),
//                     fillColor: Color(0xfff3f3f4),
//                   )),
//             ),
//             SizedBox(
//               height: 15.h,
//             ),

//             /// Last Name
//             Text(
//               'Last Name'.toUpperCase() + ' *',
//               style: Textprimary,
//             ),
//             SizedBox(
//               height: 15.h,
//             ),
//             Container(
//               height: 50.h,
//               width: (MediaQuery.of(context).size.width / 1.07).w,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey[400]!)),
//               child: TextField(
//                   controller: _lname,
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.only(left: 10.w),
//                     fillColor: Color(0xfff3f3f4),
//                   )),
//             ),
//             SizedBox(
//               height: 15.h,
//             ),

//             /// Email
//             Text(
//               'Email'.toUpperCase(),
//               style: Textprimary,
//             ),
//             SizedBox(
//               height: 15.h,
//             ),
//             Container(
//               height: 50.h,
//               width: (MediaQuery.of(context).size.width / 1.07).w,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
//               child: TextField(
//                   enabled: false,
//                   controller: _email,
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.only(left: 10.w),
//                     fillColor: Color(0xfff3f3f4),
//                   )),
//             ),
//             SizedBox(
//               height: 15.h,
//             ),

//             /// Phone Number
//             Text('Phone Number'.toUpperCase() + ' *', style: Textprimary),
//             SizedBox(
//               height: 15.h,
//             ),
//             Container(
//               height: 50.h,
//               width: (MediaQuery.of(context).size.width / 1.07).w,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
//               child: TextField(
//                   controller: _phone,
//                   keyboardType: TextInputType.number,
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.only(left: 10.w),
//                     fillColor: Color(0xfff3f3f4),
//                   )),
//             ),
//             SizedBox(
//               height: 15.h,
//             ),

//             /// Address 1
//             Text('Address 1'.toUpperCase() + ' *', style: Textprimary),
//             SizedBox(
//               height: 15.h,
//             ),
//             Container(
//               height: 50.h,
//               width: (MediaQuery.of(context).size.width / 1.07).w,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
//               child: TextField(
//                   controller: _address1,
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.only(left: 10.w),
//                     fillColor: Color(0xfff3f3f4),
//                   )),
//             ),
//             SizedBox(
//               height: 15.h,
//             ),

//             /// Address 2
//             Text('Address 2'.toUpperCase(), style: Textprimary),
//             SizedBox(
//               height: 15.h,
//             ),
//             Container(
//               height: 50.h,
//               width: (MediaQuery.of(context).size.width / 1.07).w,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
//               child: TextField(
//                   controller: _address2,
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.only(left: 10.w),
//                     fillColor: Color(0xfff3f3f4),
//                   )),
//             ),
//             SizedBox(
//               height: 15.h,
//             ),

//             /// Country
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Country'.toUpperCase() + ' *', style: Textprimary),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(left: 10.w, right: 10.w),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey[400]!),
//                     borderRadius: BorderRadius.circular(5.r),
//                   ),
//                   child: DropdownButton(
//                     isExpanded: true,
//                     hint: Text('Country'),
//                     dropdownColor: Colors.grey[100],
//                     icon: Icon(
//                       Icons.keyboard_arrow_down_outlined,
//                       size: 20.sp,
//                       color: Colors.black,
//                     ),
//                     iconSize: 12.sp,
//                     underline: SizedBox(),
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 15.sp,
//                     ),
//                     value: _selectedCountry,
//                     onChanged: (newValue) {
//                       setState(() {
//                         _selectedCountry = newValue as CountryModel;
//                       });
//                     },
//                     items: context.read<AuthProvider>().countries.map((valueItem) {
//                       return DropdownMenuItem(
//                         value: valueItem,
//                         child: Row(
//                           children: <Widget>[
//                             Text(valueItem.name!),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 15.h,
//             ),

//             /// City
//             Text('City'.toUpperCase() + ' *', style: Textprimary),
//             SizedBox(
//               height: 15.h,
//             ),
//             Container(
//               height: 50.h,
//               width: (MediaQuery.of(context).size.width / 1.07).w,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
//               child: TextField(
//                   controller: _city,
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.only(left: 10.w),
//                     fillColor: Color(0xfff3f3f4),
//                   )),
//             ),
//             SizedBox(
//               height: 15.h,
//             ),

//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Discount Code
//                 Text('Discount Code'.toUpperCase(), style: Textprimary),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         height: 50.h,
//                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
//                         child: TextField(
//                             controller: _discountCode,
//                             style: TextStyle(
//                               fontSize: 18.sp,
//                             ),
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.only(left: 10.w),
//                               fillColor: Color(0xfff3f3f4),
//                             )),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5.w,
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         await httpService.verifyCupon({
//                           "coupon_name": _discountCode.text,
//                         }).then((response) {
//                           if (response.data['data']['discount_percentage'] > 0) {
//                             if (widget.product != null) {
//                               setState(() {
//                                 couponValue = (widget.product!.price! * response.data['data']['discount_percentage']) / 100;
//                               });
//                             } else {
//                               setState(() {
//                                 couponValue = (widget.bidProductPrice * response.data['data']['discount_percentage']) / 100;
//                               });
//                             }
//                             utilService.showToast('Discount Code Verified', ToastGravity.TOP);
//                           }
//                         });
//                       },
//                       child: Container(
//                         height: 40.h,
//                         decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5.r)),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 10.w,
//                         ),
//                         child: Center(
//                           child: Text(
//                             isDiscountVerified ? 'Verified' : 'Verify',
//                             style: TextStyle(
//                                 fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 15.h,
//             ),



//             /// Shipping Cost
//             Column(
//               children: [
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'SubTotal'.toUpperCase(),
//                       style: Textprimary,
//                     ),
//                     widget.product != noull
//                         ? Text(
//                             '${widget.product!.price!.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'.toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
//                           )
//                         : Text(
//                             '${widget.bidProductPrice.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'.toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
//                           ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Delievery Charges'.toUpperCase() + " :",
//                       style: Textprimary,
//                     ),
//                     Text(
//                       '${deliveryCharges.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'.toUpperCase(),
//                       style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
//                     ),
//                   ],
//                 ),
//                 if (isDiscountVerified) ...[
//                   SizedBox(height: 15.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Discount'.toUpperCase() + " :",
//                         style: Textprimary,
//                       ),
//                       Text(
//                         '- ${couponValue.convertToLocal(context)} ${context.read<CurrencyProvider>().selectedCurrency}'.toUpperCase(),
//                         style:
//                             TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.red, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
//                       ),
//                     ],
//                   )
//                 ],
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Total'.toUpperCase() + " :",
//                       style: Textprimary,
//                     ),
//                     widget.product != null
//                         ? Text(
//                             '${totalPrice(widget.product!.price!).convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'
//                                 .toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
//                           )
//                         : Text(
//                             '${totalPrice(widget.bidProductPrice).convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'
//                                 .toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
//                           ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 30.h,
//             ),
//             InkWell(
//               onTap: () async {
//                 if (_fname.text.isEmpty) {
//                   utilService.showToast('Please enter first name', ToastGravity.TOP);
//                   return;
//                 }
//                 if (_lname.text.isEmpty) {
//                   utilService.showToast('Please enter last name', ToastGravity.TOP);
//                   return;
//                 }
//                 if (_phone.text.isEmpty) {
//                   utilService.showToast('Please enter phone number', ToastGravity.TOP);
//                   return;
//                 }
//                 if (_address1.text.isEmpty) {
//                   utilService.showToast('Please enter address', ToastGravity.TOP);
//                   return;
//                 }
//                 if (_selectedCountry?.name == null) {
//                   utilService.showToast('Please select country', ToastGravity.TOP);
//                   return;
//                 }
//                 if (_city.text.isEmpty) {
//                   utilService.showToast('Please enter city', ToastGravity.TOP);
//                   return;
//                 }
//                 if (widget.product != null) {
//                   int totalAmount = totalPrice(widget.product!.price!).round();
//                   await context.read<PaymentProvider>().buyNowPayment(
//                         widget.product!.id!,
//                         totalAmount,
//                         context,
//                       );
//                 } else {
//                   int totalAmount = totalPrice(widget.bidProductPrice).round();
//                   await context.read<PaymentProvider>().buyNowPayment(
//                         widget.bidProductId,
//                         totalAmount,
//                         context,
//                       );
//                 }
//               },
//               child: Container(
//                 width: (MediaQuery.of(context).size.width / 1.07).w,
//                 height: 45.h,
//                 margin: EdgeInsets.only(bottom: 5.h),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   // color: isCityFetched ? Colors.black : Colors.grey,
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(5.0.r),
//                 ),
//                 child: Text(
//                   // isCityFetched
//                   //     ? 'Proced To Checkout'.toUpperCase()
//                   //     : 'Fetching Countries'.toUpperCase(),
//                   AppLocalizations.of(context).translate('proceedCheckout').toUpperCase(),
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     letterSpacing: 2.w,
//                     fontFamily: "MetropolisExtraBold",
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//                 margin: EdgeInsets.only(top: 10.h, bottom: 30.w),
//                 child: Container(
//                   alignment: Alignment.center,
//                   padding: EdgeInsets.all(10),
//                   child: Center(
//                       child: Text.rich(TextSpan(
//                           text: AppLocalizations.of(context).translate('checkOutAgreement1'),
//                           style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//                           children: <TextSpan>[
//                         TextSpan(
//                             text: AppLocalizations.of(context).translate('purchase&return'),
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               color: Colors.grey,
//                               decoration: TextDecoration.underline,
//                             ),
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = () async {
//                                 print("Tapped");
//                                 String url = "https://laybull.com/payment-terms";
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (BuildContext context) => WebLaybull(url),
//                                   ),
//                                 );
//                               }),
//                         TextSpan(
//                           text: AppLocalizations.of(context).translate('checkOutAgreement2'),
//                           style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//                         )
//                       ]))),
//                 )),
//           ],
//         ),
    
    