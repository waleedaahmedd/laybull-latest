// ignore_for_file: prefer_is_empty, prefer_const_constructors, unnecessary_string_interpolations, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/extensions.dart';
import 'package:provider/provider.dart';

class PurchasedHistory extends StatefulWidget {
  final List<Product> purchasedHistory;

  PurchasedHistory({required this.purchasedHistory});
  @override
  _PurchasedHistoryState createState() => _PurchasedHistoryState();
}

class _PurchasedHistoryState extends State<PurchasedHistory> {
  @override
  Widget build(BuildContext context) {
    var currencyConversion = context.read<CurrencyProvider>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Purchased History'.toUpperCase(), style: headingStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: widget.purchasedHistory.length < 1
          ? Center(
              child: Text('No Purchased History'.toUpperCase()),
            )
          : SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.purchasedHistory.length,
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
                                    margin:
                                        EdgeInsets.symmetric(vertical: 20.h),
                                    width: 120,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Image.network(
                                        '',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                                  .01)
                                              .h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${widget.purchasedHistory[index].updatedAt.toString().substring(0, 10)}',
                                          style: TextStyle(color: Colors.grey),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.end,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Container(
                                      child: Text(
                                        widget.purchasedHistory[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  .6)
                                              .w,
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      widget.purchasedHistory[index].condition +
                                          " | " +
                                          widget.purchasedHistory[index].size,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      double.parse(widget
                                                  .purchasedHistory[index]
                                                  .price)
                                              .convertToLocal(context)
                                              .toStringAsFixed(2) +
                                          " " +
                                          currencyConversion.selectedCurrency
                                              .toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //   print(widget.purchasedHistory[index].status);
                                      },
                                      child: Container(
                                        height: 30.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        child: Center(
                                          child: Text(
                                            widget
                                                .purchasedHistory[index].status
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                            ),
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
