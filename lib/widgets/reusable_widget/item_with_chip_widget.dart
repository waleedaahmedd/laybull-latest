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

class ItemWithPriceChip extends StatelessWidget {
  // String asset;
  ProductsModel productsModel;
  Function()? onTap;
  bool dateShow;
  bool isGride;
  Function() fireOnTap;
  ItemWithPriceChip({Key? key, required this.dateShow, required this.productsModel, this.onTap, required this.fireOnTap, this.isGride = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CachedNetworkImage(
                    imageUrl: productsModel.feature_image!,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 130.w,
                      width: isGride ? null : 130.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    // progressIndicatorBuilder: (context, url, downloadProgress) =>
                    //     Center(child: CircularProgressIndicator(color: Colors.grey, value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                  margin: EdgeInsets.only(left: 2.w),
                  constraints: BoxConstraints(maxWidth: 150.w),
                  child: Text(
                    "${productsModel.name}",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MetropolisMedium',
                      overflow: TextOverflow.ellipsis,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 200.w),
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: Text(
                    productsModel.category!.toLowerCase() == 'sneakers' ? "SIZE: US ${productsModel.size}" : "SIZE: ${productsModel.size}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontFamily: 'MetropolisMedium',
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 200.w),
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: Text(
                    "${context.read<CurrencyProvider>().selectedCurrency} ${productsModel.price!.convertToLocal(context).round()}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.sp,
                      fontFamily: 'MetropolisBold',
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (dateShow == true)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 20.h,
              width: 60.w,
              decoration: BoxDecoration(
                color: Colors.blue.shade400,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                ),
              ),
              child: Center(
                child: Text(
                  productsModel.release_date != null ? DateFormat('dd MMM').format(DateTime.parse(productsModel.release_date!)) : 'dsa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
