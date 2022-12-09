// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/extensions.dart';
import 'package:provider/provider.dart';

class SoldProducts extends StatefulWidget {
  final List<Product>? listSold;
  final bool? isSold;
  SoldProducts({this.listSold, this.isSold});
  @override
  _SoldProductsState createState() => _SoldProductsState();
}

class _SoldProductsState extends State<SoldProducts> {
  @override
  Widget build(BuildContext context) {
    var currencyConversion = context.read<CurrencyProvider>();
    List<Product> listOfSold = widget.listSold!;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white10,
          title: Text(
            widget.isSold == null || widget.isSold == true
                ? AppLocalizations.of(context).translate('sold').toUpperCase()
                : AppLocalizations.of(context)
                    .translate('ordered')
                    .toUpperCase(),
            style: headingStyle,
          )),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
            left: 10.w,
            right: 10.w,
            top: 20.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: listOfSold.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 170.h,
                      // width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 20.h),
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: listOfSold.isNotEmpty &&
                                        // ignore: unnecessary_null_comparison
                                        listOfSold[index].featureImage != null
                                    ? Image.network(
                                        '',
                                        fit: BoxFit.fill,
                                      )
                                    : Image.asset('assets/bigshoe.png'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height * .01)
                                        .h,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${listOfSold[index].updatedAt.toString().substring(0, 10)}',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.end,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                child: Text(
                                  listOfSold.isNotEmpty
                                      ? listOfSold[index].name
                                      : 'Product',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                width:
                                    (MediaQuery.of(context).size.width * .6).w,
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                listOfSold.isNotEmpty
                                    ? listOfSold[index].condition +
                                        " | " +
                                        listOfSold[index].size
                                    : AppLocalizations.of(context)
                                        .translate('new'),
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                listOfSold.isNotEmpty
                                    ? double.parse(listOfSold[index].price)
                                            .convertToLocal(context)
                                            .toStringAsFixed(2) +
                                        " " +
                                        currencyConversion.selectedCurrency
                                            .toUpperCase()
                                    : "AED 3000",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              listOfSold[index].status == null
                                  ? Container()
                                  : Container(
                                      height: 30.h,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(3.r)),
                                      child: Center(
                                        child: Text(
                                          listOfSold[index].status.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
