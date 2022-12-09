// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/widgets/reusable_widget/cache_image.dart';
import 'package:laybull_v3/extensions.dart';
import 'package:provider/src/provider.dart';

class ReleaseCalendarChip extends StatelessWidget {
  // String asset;
  ProductsModel productsModel;
  Function()? onTap;
  bool dateShow;
  Function() fireOnTap;
  ReleaseCalendarChip({
    Key? key,
    required this.dateShow,
    required this.productsModel,
    this.onTap,
    required this.fireOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            // height: 500.h,
            // width: 200.w,
            decoration: BoxDecoration(
                // color: Color(0xffE5F3FD),
                // border: Border.all(color: Colors.black12),
                // borderRadius: BorderRadius.circular(9.r),
                ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CachedNetworkImage(
                    imageUrl: productsModel.feature_image!,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 100.w,
                      width: 130.w,
                      // width: (MediaQuery.of(context).size.width * .45).w,
                      // margin: EdgeInsets.only(
                      //   right: 10.w,
                      //   bottom: 10.h,
                      //   left: 5.w,
                      // ),
                      decoration: BoxDecoration(
                        // color: Colors.grey[100],
                        // borderRadius: BorderRadius.circular(6.r),
                        // shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // progressIndicatorBuilder: (context, url, downloadProgress) =>
                    //     Center(child: CircularProgressIndicator(color: Colors.grey, value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    // fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                  margin: EdgeInsets.only(left: 2.w),
                  constraints: BoxConstraints(maxWidth: 120.w),
                  child: Text(
                    " ${productsModel.name}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MetropolisMedium',

                      // fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 5.h,
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                //   child: Container(
                //     constraints: BoxConstraints(maxWidth: 200.w),
                //     child: Text(
                //       "${context.read<CurrencyProvider>().selectedCurrency} ${productsModel.price!.convertToLocal(context).round()}",
                //       overflow: TextOverflow.ellipsis,
                //       style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 13.sp,
                //         fontFamily: 'MetropolisBold',
                //         fontWeight: FontWeight.w600,
                //       ),
                //       maxLines: 2,
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 5.h,
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                //   child: Container(
                //     constraints: BoxConstraints(maxWidth: 200.w),
                //     child: Text(
                //       productsModel.category!.toLowerCase() == 'sneakers'
                //           ? "SIZE: US ${productsModel.size}"
                //           : "SIZE: ${productsModel.size}",
                //       overflow: TextOverflow.ellipsis,
                //       style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 13.sp,
                //         fontFamily: 'MetropolisMedium',
                //         fontWeight: FontWeight.w600,
                //       ),
                //       maxLines: 2,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        /*     Positioned(
          top: 92.h,
          left: 90.w,
          child: GestureDetector(
            child: Container(
              height: 35.h,
              width: 35.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 3,
                    ),
                  ]),
              margin: EdgeInsets.only(right: 3.w),
              child: Center(
                child: productsModel.isFav == true
                    ? Image.asset(
                        'assets/finalFire.png',
                        height: 25.h,
                        width: 25.w,
                      )
                    : Image.asset('assets/Vector1.png'),
              ),
            ),
            onTap: fireOnTap,
          ),
    */
        if (dateShow == true)
          Positioned(
            left: 0.0,
            child: Container(
              padding: EdgeInsets.only(top: 10.h, left: 10.h),
              // decoration: BoxDecoration(
              //   color: Colors.blue.shade400,
              //   borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(12.r),
              //   ),
              // ),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      productsModel.release_date != null ? DateFormat('MMM').format(DateTime.parse(productsModel.release_date!)) : 'Non',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'MetropolisBold',
                      ),
                    ),
                    Text(
                      productsModel.release_date != null ? DateFormat('dd').format(DateTime.parse(productsModel.release_date!)) : 'Non',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'MetropolisBold',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
