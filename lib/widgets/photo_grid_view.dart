// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:laybull_v3/extensions.dart';
import '../constants.dart';
import 'myCustomProgressDialog.dart';

// ignore: must_be_immutable
class ProductGridView extends StatefulWidget {
  // final List<ProductsModel>? product;
  final List<ProductsModel>? product;
  final VoidCallback? onFavoutireButtonTapped;
  final bool isfavScreen;
  ProductGridView({
    Key? key,
    @required this.product,
    this.onFavoutireButtonTapped,
    required this.isfavScreen,
  }) : super(key: key);

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  MyProgressDialog? pr;
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        childAspectRatio: 0.6,
      ),
      itemCount: widget.product!.length,
      itemBuilder: (BuildContext ctx, index) {
        i = index;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () async {
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
                    imageUrl: widget.product![index].feature_image!,
                    imageBuilder: (context, imageProvider) => Container(
                      height: (MediaQuery.of(context).size.height * .22).h,
                      width: (MediaQuery.of(context).size.width * .45).w,
                      margin: EdgeInsets.only(
                        right: 10.w,
                        bottom: 10.h,
                        left: 5.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                        // shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                    // progressIndicatorBuilder: (context, url, downloadProgress) =>
                    //     Center(child: CircularProgressIndicator(color: Colors.grey, value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.contain,
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
              padding: EdgeInsets.only(top: 1.0.h, left: 8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 150.w),
                    child: Text(
                      widget.product![index].name ?? 'Product Name',
                      style: listtext1,
                      // maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  // Text("Size" + ' : US ' + '${widget.product![index].size}',
                  //     style: listtext3),
                  widget.product![index].category!.toLowerCase() == 'sneakers'
                      ? Text(
                          "Size" + ' : ' + 'US ${widget.product![index].size}',
                          style: listtext3,
                        )
                      : Text("Size" + ' : ' + '${widget.product![index].size}',
                          //widget.product![index].category == 'Sneakers' ? 'US ${widget.product![index].size' : widget.product![index].size ?? 0}',
                          style: listtext3),
                  SizedBox(height: 3.h),
                  Text(widget.product![index].condition!.toUpperCase(), style: listtext3),
                  SizedBox(height: 3.h),

                  Text(
                    "${widget.product![index].price!.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}",
                    style: listtext2,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
