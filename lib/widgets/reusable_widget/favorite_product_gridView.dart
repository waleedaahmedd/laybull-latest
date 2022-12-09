// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';
import 'package:provider/src/provider.dart';
import 'package:laybull_v3/extensions.dart';
import '../../constants.dart';
import 'myCustomProgressDialog.dart';

// ignore: must_be_immutable
class FavoriteProductGridView extends StatefulWidget {
  // final List<ProductsModel>? product;
  final List<ProductsModel>? product;

  FavoriteProductGridView({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<FavoriteProductGridView> createState() => _FavoriteProductGridViewState();
}

class _FavoriteProductGridViewState extends State<FavoriteProductGridView> {
  MyProgressDialog? pr;

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
      itemBuilder: (BuildContext ctx, int index) {
        return widget.product!.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height * .4,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).translate('nothingToShow'),
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 0.2.w,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async => await context.read<ProductProvider>().getFavoriteProducts(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // pr = MyProgressDialog(context);
                            // pr!.show();
                            await context.read<ProductProvider>().getProductDetail(
                                  widget.product![index].id!,
                                  context,
                                  false,
                                );
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
                                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            // progressIndicatorBuilder: (context, url, downloadProgress) =>
                            //     Center(child: CircularProgressIndicator(color: Colors.grey, value: downloadProgress.progress)),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            // fit: BoxFit.cover,
                          ),
                        ),
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
                              child: widget.product![index].isFav == true
                                  ? Image.asset(
                                      'assets/finalFire.png',
                                      height: 25.h,
                                      width: 25.w,
                                    )
                                  : Image.asset('assets/Vector1.png'),
                            ),
                          ),
                          onTap: () async {
                            int ind = widget.product![index].id!;
                            context.read<ProductProvider>().removingFromFavLocall(widget.product![index].id!);

                            await context.read<ProductProvider>().removeFromFavoriteProducts(ind);
                            setState(() {});
                          },
                        ),
                      ],
                      alignment: Alignment.bottomRight,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 1.0.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 180.w),
                            child: Text(
                              widget.product![index].name ?? 'Product Name',
                              style: listtext1,
                              overflow: TextOverflow.ellipsis,
                              // maxLines: 1,
                            ),
                          ),
                          SizedBox(height: 3.h),
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
                            // currencyConversion
                            //         .convertToLocal(
                            //             double.parse(widget.product[index].price))
                            //         .toStringAsFixed(2) +
                            "${widget.product![index].price!.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}",
                            // currencyConversion.selectedCurrency.toUpperCase(),
                            style: listtext2,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }
}
