// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/models/home_category_model.dart';
import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:laybull_v3/extensions.dart';
import '../constants.dart';
import 'myCustomProgressDialog.dart';

// ignore: must_be_immutable
class ViewAllProductGridView extends StatefulWidget {
  // final List<ProductsModel>? product;
  final bool isViewAllrelease;
  final List<HomeCategoryModel>? product;
  final VoidCallback? onFavoutireButtonTapped;
  // ScrollController controller;

  final bool isfavScreen;
  ViewAllProductGridView({
    Key? key,
    required this.isViewAllrelease,
    required this.product,
    // required this.controller,
    this.onFavoutireButtonTapped,
    required this.isfavScreen,
  }) : super(key: key);

  @override
  State<ViewAllProductGridView> createState() => _ViewAllProductGridViewState();
}

class _ViewAllProductGridViewState extends State<ViewAllProductGridView> {
  MyProgressDialog? pr;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // controller: widget.controller,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 25.h,
        childAspectRatio: 0.6,
      ),
      itemCount: widget.product!.length,
      itemBuilder: (BuildContext ctx, index) {
        // i = index;
        return Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: widget.isViewAllrelease == true
                      ? null
                      : () async {
                          // pr = MyProgressDialog(context);
                          // pr!.show();
                          if (context.read<AuthProvider>().user != null) {
                            await context.read<ProductProvider>().getProductDetail(
                                  widget.product![index].id!,
                                  context,
                                  false,
                                );
                          } else {
                            await context.read<ProductProvider>().getGuestProductDetail(
                                  widget.product![index].id!,
                                  context,
                                  false,
                                );
                          }
                        },
                  child: CachedNetworkImage(
                    imageUrl: widget.product![index].featured_image!,
                    imageBuilder: (context, imageProvider) => Container(
                      height: (MediaQuery.of(context).size.width * .45).w,
                      width: (MediaQuery.of(context).size.width * .45).w,
                      margin: EdgeInsets.only(
                          // right: 20.w,
                          // bottom: 10.h,
                          ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                        // shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        Center(child: CircularProgressIndicator(color: Colors.grey, value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    // fit: BoxFit.cover,
                  ),
                ),
                if (widget.isfavScreen == true)
                  GestureDetector(
                    child: Container(
                      height: 35.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 3.r,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(right: 3.w),
                      child: Center(
                          child: Image.asset(
                        'assets/finalFire.png',
                        height: 25.h,
                        width: 25.w,
                      )
                          // : Image.asset('assets/Vector1.png'),
                          ),
                    ),
                    onTap: () {},
                  ),
              ],
              alignment: Alignment.bottomRight,
            ),
            Container(
              // padding: EdgeInsets.only(top: 1.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 7.h,
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 150.w),
                    child: Text(
                      widget.product![index].name ?? 'Product Name',
                      style: listtext1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      // maxLines: 1,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text("Size" + ' : ' + '${widget.product![index].size}', style: listtext3),
                  // widget.product![index].category!.toLowerCase() == 'sneakers'
                  //     ? Text(
                  //         "Size" + ' : ' + 'US ${widget.product![index].size}',
                  //         style: listtext3,
                  //       )
                  //     : Text("Size" + ' : ' + '${widget.product![index].size}',
                  //         //widget.product![index].category == 'Sneakers' ? 'US ${widget.product![index].size' : widget.product![index].size ?? 0}',
                  //         style: listtext3),
                  SizedBox(height: 3.h),
                  Text(widget.product![index].condition!.toUpperCase(), style: listtext3),
                  SizedBox(height: 3.h),
                  Text(
                    "${widget.product![index].price!.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}",
                    style: listtext2,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
