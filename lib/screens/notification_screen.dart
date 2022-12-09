// ignore_for_file: prefer_const_constructors, unnecessary_new, must_be_immutable, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/util_services/http_service.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  bool? isFromProfile;
  Map<String, bool>? argument;
  NotificationScreen({this.isFromProfile, this.argument});
  @override
  State<StatefulWidget> createState() {
    return _NotificationScreen();
  }
}

class _NotificationScreen extends State<NotificationScreen> {
  final httpService = locator<HttpService>();
  var notification;
  @override
  void initState() {
    super.initState();
    getNotification();
  }

  getNotification() async {
    var response = await httpService.getNotifications();
    notification = response.data;
    setState(() {});
    log(response.data.toString());
  }

  String connectionMessage = "No Internet Connection";
  @override
  Widget build(BuildContext context) {
    var pp = context.read<ProductProvider>();
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white10,
          title: Text(
            AppLocalizations.of(context).translate('notifications').toUpperCase(),
            // 'Noti'.toUpperCase(),
            style: headingStyle,
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 18.w, top: 18.w),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: notification == null
              ? Center(child: Text('No Notification Available'))
              : notification['data'].length == 0
                  ? Center(child: Text('No Notification Available'))
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await pp.getProductDetail(notification['data'][index]['product_id'], context, false);
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 10.w,
                                  ),
                                  width: (MediaQuery.of(context).size.width * .14).w,
                                  height: (MediaQuery.of(context).size.height * .06).h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    image: DecorationImage(
                                      image: NetworkImage(notification['data'][index]['image']),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification['data'][index]['body'],
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black,
                                            letterSpacing: 2.w,
                                            fontFamily: "MetropolisBold",
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd-MMM-yyy').format(DateTime.parse(notification['data'][index]['created_at'])),
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.grey,
                                            letterSpacing: 2.w,
                                            fontFamily: "MetropolisBold",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (contex, index) {
                        return SizedBox(
                          height: 4,
                        );
                      },
                      itemCount: notification['data'].length,
                    ),
        ),
      ),
    );
  }
}
