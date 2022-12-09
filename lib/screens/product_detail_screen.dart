// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_string_interpolations, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_final_fields, prefer_is_empty

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/color_model.dart';
import 'package:laybull_v3/models/image_model.dart';
import 'package:laybull_v3/models/product_detail_model.dart';
import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/providers/payment_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/screens/confirm_address_screen.dart';
import 'package:laybull_v3/screens/main_dashboard_screen.dart';
import 'package:laybull_v3/screens/web_laybul.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';
import 'package:laybull_v3/widgets/reusable_widget/jumping_dots.dart';
import 'package:laybull_v3/widgets/size_chart_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:laybull_v3/extensions.dart';
import 'edit_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductsModel? product;
  ProductDetailScreen({this.product});

  @override
  _ProductDetailScreentate createState() => _ProductDetailScreentate();
}

class _ProductDetailScreentate extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  var utilservice = locator<UtilService>();
  CarouselController controller = CarouselController();
  int currentIndex = 0;
  bool isDeletingProduct = false;

  Future<void> _showMyDialog(
      String currentCurrency,
      BuildContext context,
      int productId,
      ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AlertDialog(
              title: Text(
                AppLocalizations.of(context).translate('makeOffer').toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
              ),
              content: Consumer<ProductProvider>(builder: (context, pp, _) {
                return SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(AppLocalizations.of(context).translate('enterPrice1')),
                      SizedBox(height: 20.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: pp.bidController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context).translate('bidAmount');
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: 'Metropolis',
                            letterSpacing: 2.2.w,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffix: Text(
                              currentCurrency,
                              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
                            ),
                            // suffixText: "AED",
                            // suffixStyle:  TextStyle(fontWeight: FontWeight.bold,letterSpacing: 2,fontFamily: "MetropolisExtraBold"),
                            fillColor: Color(0xfff3f3f4),
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              actions: <Widget>[
                Consumer<ProductProvider>(builder: (context, pp, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text('Cancel'.toUpperCase()),
                        onPressed: () {
                          pp.bidController.text = '';
                          Navigator.of(context).pop();
                        },
                      ),
                      // Container(height: 60, width: 60, child: JumpingDots()),
                      // pp.isBidding == true
                      //     ? Container(
                      //         height: 60, width: 60, child: JumpingDots())
                      //     :
                      TextButton(
                        child: Text(
                          // AppLocalizations.of(context)
                          //   .translate('offer')
                            "offer".toUpperCase()),
                        onPressed: () async {
                          if (double.parse(pp.bidController.text.trim()).convertToEuro(context) > pp.productDetail!.highestBid!) {
                            await context.read<ProductProvider>().makeProductBid(
                              int.parse(pp.bidController.text),
                              productId,
                              context,
                            );
                          } else {
                            utilservice.showToast('Your bid must be higher than the current bid', ToastGravity.BOTTOM);
                          }
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // void handleClick(int item) {
  //   switch (item) {
  //     case 0:
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => EditProduct(
  //                   // product: widget.product,
  //                   )));
  //       break;
  //     case 1:
  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(
  //               builder: (c) => BottomNav(
  //                     navIndex: 3,
  //                   )),
  //           (route) => false);

  //       break;
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, pp, _) {
      return RefreshIndicator(
        onRefresh: () async {
          await pp.getProductDetail(pp.productDetail!.id!, context, true);
        },
        child: Scaffold(
          // appBar: pp.productDetail != null
          //     ? AppBar(
          //         elevation: 0,
          //         iconTheme: IconThemeData(color: Colors.black),
          //         backgroundColor: Colors.white10,
          //         title: Text(
          //           AppLocalizations.of(context)
          //               .translate('productDetail')
          //               .toUpperCase(),
          //           style: headingStyle,
          //         ),
          //       )
          //     : null,
            appBar: pp.productDetail != null
                ? AppBar(
              toolbarHeight: 50,
              elevation: 0,
              actions: [
                if (context.read<AuthProvider>().user != null)
                  if (pp.productDetail!.user!.id == context.read<AuthProvider>().user!.id) ...[
                    IconButton(
                      splashColor: Colors.black54,
                      highlightColor: Colors.transparent,
                      splashRadius: 26.r,
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        MyProgressDialog pr = MyProgressDialog(context);
                        pr.show();
                        pp.clearAddProductFormData();
                        for (int i = 0; i < pp.productDetail!.images!.length; i++) {
                          pp.networkImages.add(
                            ProductDetailImageClass(
                              id: pp.productDetail!.images![i].id,
                              images: pp.productDetail!.images![i].images,
                            ),
                          );
                          pp.imgeFiles[i].isPicked = true;
                        }

                        pp.selectedCategory = pp.categories.firstWhere(
                              (element) => element.name!.toLowerCase() == pp.productDetail!.category!.toLowerCase(),
                        );
                        await pp.getSizes(pp.selectedCategory!.id!);
                        pp.prodName.text = pp.productDetail!.name!;
                        pp.prodPrice.text = pp.productDetail!.price!.convertToLocal(context).round().toString();
                        pp.selectedBrand = pp.brands.firstWhere((element) => element.name.toLowerCase() == pp.productDetail!.brand!.toLowerCase());
                        pp.selectedCondition = pp.productDetail!.condition!;
                        pp.selectedSize = pp.sizes.firstWhere((element) => element.size.toLowerCase() == pp.productDetail!.size!.toLowerCase());
                        pp.sizes.firstWhere((element) => element.id == pp.selectedSize!.id).isSelected = true;
                        pp.selectedColor = colorList.firstWhere((element) {
                          return element.colorName.toLowerCase() == pp.productDetail!.color!.toLowerCase();
                        });
                        pp.descriptionController.text = pp.productDetail!.description!;
                        colorList.firstWhere((element) => element.colorName.toLowerCase() == pp.selectedColor!.colorName.toLowerCase()).isSelected = true;
                        pr.hide();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProduct(
                              // product: widget.product,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      splashColor: Colors.red[300],
                      highlightColor: Colors.transparent,
                      splashRadius: 26.r,
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Warning'.toUpperCase()),
                              content: Text(
                                "Are you sure, You want to delete this product?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    MyProgressDialog pr = MyProgressDialog(context);
                                    pr.show();
                                    await pp.deleteProduct(
                                      pp.productDetail!.id!,
                                      context,
                                    );
                                    await pp.getHomeProducts();
                                    pr.hide();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Yes".toUpperCase()),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No'.toUpperCase()))
                              ],
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: 5.w,
                    )
                  ],
              ],
              iconTheme: IconThemeData(color: Colors.black, size: 20),
              backgroundColor: Colors.white10,
            )
                : null,
            body: pp.productDetail != null
                ? SingleChildScrollView(
              child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      if (pp.productDetail!.images!.length > 0) ...[
                        Stack(
                          children: [
                            CarouselSlider(
                              carouselController: controller,
                              options: CarouselOptions(
                                height: 250.h,
                                viewportFraction: 1,
                                enlargeCenterPage: true,
                                onPageChanged: (position, reason) {
                                  currentIndex = position;
                                  setState(() {});
                                  if (kDebugMode) {
                                    print("cc $position && $currentIndex");

                                    print("cc $position && $currentIndex");
                                    print(reason);
                                    print(CarouselPageChangedReason.controller);
                                  }
                                },
                                enableInfiniteScroll: false,
                              ),
                              items: pp.productDetail!.images!.map<Widget>((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) => Center(
                                            child: Container(
                                              height: 350.h,
                                              width: MediaQuery.of(context).size.width.w,
                                              child: PhotoView(
                                                imageProvider: NetworkImage(
                                                  i.images ?? '',
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: i.images ?? '',

                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(5.r),
                                            // shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        //         JumpingDots(
                                        //   forImage: true,
                                        //   isLoadingShow: true,
                                        // ),
                                        Center(
                                          child: CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                            color: Colors.black,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),

                                        // fit: BoxFit.cover,
                                      ),
                                      // Container(
                                      //   width:
                                      //       MediaQuery.of(context).size.width,
                                      //   child: Image.network(
                                      //     i,
                                      //     fit: BoxFit.cover,
                                      // height: 200.h,
                                      // width: 350.w,
                                      //   ),
                                      // ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            Align(
                              // top: 0.h,

                              // left: MediaQuery.of(context).size.width / 1.2,
                              alignment: Alignment.bottomRight,
                              // alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                  child: Container(
                                    height: 35.h,
                                    width: 35.w,
                                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: 3,
                                          ),
                                        ]),
                                    margin: EdgeInsets.only(right: 10.w, top: 205.h),
                                    child: Center(
                                      child: pp.productDetail!.favourite == true
                                          ? Image.asset(
                                        'assets/finalFire.png',
                                        height: 25.h,
                                        width: 25.w,
                                      )
                                          : Image.asset('assets/Vector1.png'),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (context.read<AuthProvider>().user != null) {
                                      if (pp.productDetail!.favourite == false) {
                                        // pp.addingIntoFavLocall(
                                        //     pp.productDetail!.favourite);
                                        setState(() {});
                                        pp.productDetail!.favourite = true;
                                        await pp.addToFavoriteProducts(
                                          pp.productDetail!.id!,
                                        );
                                        setState(() {});
                                      } else {
                                        pp.removingFromFavLocall(
                                          pp.productDetail!.id!,
                                        );

                                        setState(() {});
                                        pp.productDetail!.favourite = false;
                                        await pp.removeFromFavoriteProducts(
                                          pp.productDetail!.id!,
                                        );
                                        setState(() {});
                                      }
                                    }
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                          child: DotsIndicator(
                            dotsCount: pp.productDetail!.images!.length,
                            position: currentIndex.toDouble(),
                            decorator: DotsDecorator(
                              spacing: EdgeInsets.only(
                                left: 3.w,
                                right: 3.w,
                              ),
                              size: Size(
                                5.w,
                                5.h,
                              ),
                              activeSize: Size(
                                5.w,
                                5.h,
                              ),
                              color: Colors.grey,
                              activeColor: Colors.black,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(
                        height: 15.h,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 1.0.h),
                              width: (MediaQuery.of(context).size.width).w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pp.productDetail!.name!.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "MetropolisBold",
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        "${pp.productDetail!.condition}".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontFamily: 'MetropolisBold',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (pp.productDetail!.highestBid != 0.0)
                                            Container(
                                              height: 20.h,
                                              decoration: null,
                                              child: Text(AppLocalizations.of(context).translate('highestBid'),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily: 'MetropolisBold',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black54,
                                                  )),
                                            ),
                                          if (pp.productDetail!.highestBid != 0.0) SizedBox(width: 5.w),
                                          Container(
                                            margin: EdgeInsets.only(
                                              bottom: pp.productDetail!.highestBid! > 0 ? 8.h : 5.0,
                                            ),
                                            height: 15.h,
                                            decoration: pp.productDetail!.highestBid! > 0
                                                ? BoxDecoration(
                                              color: Colors.orange,
                                              border: Border.all(color: Colors.orange),
                                              borderRadius: BorderRadius.circular(
                                                3.r,
                                              ),
                                            )
                                                : null,
                                            child: Text(
                                              pp.productDetail!.highestBid == 0.0
                                                  ? 'No Bid Yet'
                                                  : '${pp.productDetail!.highestBid!.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency.toUpperCase()}'
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontFamily: 'MetropolisBold',
                                                fontWeight: FontWeight.w600,
                                                color: pp.productDetail!.highestBid == 0.0 ? Colors.black54 : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${context.read<CurrencyProvider>().selectedCurrency.toUpperCase()} ${pp.productDetail!.price!.convertToLocal(context).round()}'
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontFamily: 'MetropolisBold',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /*   Container(
                                padding: EdgeInsets.only(top: 1.0.h),
                                width: (MediaQuery.of(context).size.width).w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      pp.productDetail!.name!.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "MetropolisBold"),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      '${pp.productDetail!.price!.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency.toUpperCase()}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: 'MetropolisBold',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      "${pp.productDetail!.condition}"
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'MetropolisBold',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 20.h,
                                          decoration: null,
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate('highestBid'),
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontFamily: 'MetropolisBold',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black54,
                                              )),
                                        ),
                                        SizedBox(width: 5.w),
                                        // Text('  '),
                                        Container(
                                          height: 20.h,
                                          decoration:
                                              pp.productDetail!.highestBid! > 0
                                                  ? BoxDecoration(
                                                      color: Colors.orange,
                                                      border: Border.all(
                                                          color: Colors.orange),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        3.r,
                                                      ),
                                                    )
                                                  : null,
                                          child: Text(
                                            pp.productDetail!.highestBid == 0.0
                                                ? 'No Bid Yet'
                                                : '${pp.productDetail!.highestBid!.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency.toUpperCase()}'
                                                    .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 17.sp,
                                              fontFamily: 'MetropolisBold',
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  pp.productDetail!.highestBid ==
                                                          0.0
                                                      ? Colors.black54
                                                      : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          */
                            SizedBox(
                              height: 5.h,
                            ),
                            if (context.read<AuthProvider>().user != null)
                              if (pp.productDetail!.user!.id != context.read<AuthProvider>().user!.id)
                                Padding(
                                  padding: EdgeInsets.only(right: 10.w, left: 5.w),
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: InkWell(
                                          onTap: () {
                                            if (context.read<AuthProvider>().user != null) {
                                              _showMyDialog(context.read<CurrencyProvider>().selectedCurrency.toUpperCase(), context, pp.productDetail!.id!);
                                            } else {
                                              utilservice.showDialogue(AppLocalizations.of(context).translate('guestAlert'), context);
                                            }
                                          },
                                          child: Container(
                                            height: 45.h,
                                            // width: (MediaQuery.of(context)
                                            //             .size
                                            //             .width /
                                            //         2.5)
                                            //     .w,
                                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.r)),
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of(context).translate('makeOffer').toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  letterSpacing: 1.1.w,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 10.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Flexible(
                                        child: InkWell(
                                          onTap: () async {
                                            if (context.read<AuthProvider>().user != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ConfirmAddress(
                                                    product: pp.productDetail!,
                                                    bidProductPrice: 0,
                                                    bidProductId: 0,
                                                  ),
                                                ),
                                              );
                                              //payent method open karwany k lia ye api hit karni hogi - rangila
                                              // await context.read<PaymentProvider>().buyNowPayment(
                                              //       pp.productDetail!.id!,
                                              //       pp.productDetail!.price!,
                                              //       context,
                                              //     );
                                            }
                                            // _showMyDialogPayment();
                                          },
                                          child: Container(
                                              height: 45.h,
                                              // width: (MediaQuery.of(context)
                                              //             .size
                                              //             .width /
                                              //         2.5)
                                              //     .w,
                                              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.r)),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/authentic.png",
                                                        color: Colors.white,
                                                        width: 15.w,
                                                        height: 15.h,
                                                      ),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Text(
                                                        AppLocalizations.of(context).translate('buyNow').toUpperCase(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          letterSpacing: 1.12.w,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2.h,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(context).translate('verifiedAuthentic'),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      letterSpacing: 0.12.w,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            // : SizedBox(),
                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                              height: 90.h,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Color(0xff5DB3F5))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.h, left: 12.w),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/authentic.png",
                                          color: Color(0xff5DB3F5),
                                          width: 15.w,
                                          height: 15.h,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          AppLocalizations.of(context).translate('verifiedAuthentic'),
                                          style: TextStyle(
                                            color: Color(0xff5DB3F5),
                                            fontFamily: 'MetropolisMedium',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width.w,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 12.0.w, right: 5.w),
                                        child: Text(
                                          AppLocalizations.of(context).translate('authenticDetails'),
                                          style: TextStyle(
                                            color: Color(0xff5DB3F5),
                                            fontFamily: 'MetropolisMedium',
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      String url = "https://laybull.com/authentication-process";
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebLaybull(url)));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 12.0.w),
                                      child: Text(
                                        AppLocalizations.of(context).translate('learnMore'),
                                        style: TextStyle(
                                            color: Color(
                                              0xff5DB3F5,
                                            ),
                                            decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Seller'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              horizontalTitleGap: 5,
                              leading: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(30.r),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: pp.productDetail!.user!.profile_picture!,
                                    // height: 20,
                                    // width: 20,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Center(child: CircularProgressIndicator(color: Colors.grey, value: downloadProgress.progress)),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                pp.productDetail!.user!.first_name.toUpperCase() + " " + pp.productDetail!.user!.last_name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  // letterSpacing: 2.w,
                                  fontFamily: "MetropolisBold",
                                ),
                              ),
                              trailing: TextButton(
                                onPressed: () async {
                                  if (context.read<AuthProvider>().user != null) {
                                    if (context.read<AuthProvider>().isfetchingUserDetail == false) {
                                      await context.read<AuthProvider>().getUserById(pp.productDetail!.user!.id, context, false);
                                    }
                                  }
                                },
                                child: Text(
                                  "View Profile".toUpperCase(),
                                  style: TextStyle(
                                    color: Color(0xff5DB3F5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    fontFamily: "MetropolisBold",
                                  ),
                                ),
                              ),
                            ),
                            /* Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                            .translate('name')
                                            .toUpperCase() +
                                        ' :',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        letterSpacing: 2.w,
                                        fontFamily: "MetropolisBold"),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      print(
                                          "user id ${pp.productDetail!.user!.id}");
                                      if (context.read<AuthProvider>().user !=
                                          null) {
                                        if (context
                                                .read<AuthProvider>()
                                                .isfetchingUserDetail ==
                                            false) {
                                          await context
                                              .read<AuthProvider>()
                                              .getUserById(
                                                  pp.productDetail!.user!.id,
                                                  context,
                                                  false);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 30.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                        vertical: 5.h,
                                      ),
                                      child: Text(
                                        "${pp.productDetail!.user!.first_name} ${pp.productDetail!.user!.last_name}",
                                        style: TextStyle(
                                          color: Color(0xff5DB3F5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          fontFamily: "MetropolisBold",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            */
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Specification'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 2.w,
                                    fontFamily: "MetropolisExtraBold",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description'.toUpperCase() + ' :',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      letterSpacing: 2.w,
                                      fontFamily: "MetropolisBold",
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    pp.productDetail!.description!.toUpperCase(),
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      letterSpacing: 2.w,
                                      fontFamily: "MetropolisBold",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('size').toUpperCase() + ' :',
                                  style: TextStyle(
                                      fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2.w, fontFamily: "MetropolisBold"),
                                ),
                                Spacer(),
                                Text(
                                  pp.productDetail!.size == ""
                                      ? 'Not Mentioned'
                                      : pp.productDetail!.size != null
                                      ? pp.productDetail!.category!.toLowerCase() == 'sneakers'
                                      ? "US ${pp.productDetail!.size}"
                                      : "${pp.productDetail!.size}"
                                      : 'Not Mentioned',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    letterSpacing: 2.w,
                                    fontFamily: "MetropolisBold",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('color').toUpperCase() + ' :',
                                  style: TextStyle(
                                      fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2.w, fontFamily: "MetropolisBold"),
                                ),
                                Spacer(),
                                Text(
                                  pp.productDetail!.color != "" ? pp.productDetail!.color! : "Not Given",
                                  style: TextStyle(
                                      fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 2.w, fontFamily: "MetropolisBold"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Condition'.toUpperCase() + ' :',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 2.w,
                                    fontFamily: "MetropolisBold",
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  pp.productDetail!.condition!.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    letterSpacing: 2.w,
                                    fontFamily: "MetropolisBold",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),

                            SizedBox(
                              height: 25.h,
                            ),

                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: PictureDialog(
                                          key: UniqueKey(),
                                          address: 'assets/sizeguide.jpg',
                                        )));
                              },
                              child: Container(
                                height: (MediaQuery.of(context).size.height / 16).h,
                                width: (MediaQuery.of(context).size.width / 1.1).w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Center(
                                    child: Text(
                                      AppLocalizations.of(context).translate('sizeGuide').toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'MetropolisBold',
                                        letterSpacing: 1.w,
                                        fontSize: 15.0.sp,
                                      ),
                                    )),
                              ),
                            ),

                            SizedBox(
                              height: 12.h,
                            ),
                            // Text('RELATED PRODUCTS', style: Textprimary),
                            // Container(
                            //   height: MediaQuery.of(context).size.height / 3.5,
                            //   width: MediaQuery.of(context).size.width,
                            //   //color: Colors.black,
                            //   child: GridView.builder(
                            //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            //         maxCrossAxisExtent: 200,
                            //         // childAspectRatio: (itemWidth / itemHeight),
                            //         crossAxisSpacing: 20,
                            //         mainAxisSpacing: 20),
                            //     physics: NeverScrollableScrollPhysics(),
                            //     itemCount: slideList.length,
                            //     itemBuilder: (BuildContext ctx, index) {
                            //       return Container(
                            //         child: Column(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Stack(
                            //               children: [
                            //                 Column(
                            //                   children: [
                            //                     Container(
                            //                       height: 100,
                            //                       width:
                            //                           MediaQuery.of(context).size.width /
                            //                               2.4,
                            //                       decoration: BoxDecoration(
                            //                         color: Greycolor,
                            //                         borderRadius:
                            //                             BorderRadius.circular(10),
                            //                       ),
                            //                       child:
                            //                           Image.asset(slideList[index].image),
                            //                     ),
                            //                   ],
                            //                 ),
                            //                 Padding(
                            //                   padding: const EdgeInsets.only(
                            //                       left: 120.0, top: 77),
                            //                   child: Container(
                            //                     height: 30,
                            //                     width: 30,
                            //                     decoration: BoxDecoration(
                            //                       color: Colors.white,
                            //                       borderRadius: BorderRadius.circular(20),
                            //                     ),
                            //                     child: Image.asset('assets/fire.png'),
                            //                   ),
                            //                 ),
                            //                 // Padding(
                            //                 //   padding: const EdgeInsets.only(top:123.0),
                            //                 //   child: Column(
                            //                 //     mainAxisAlignment: MainAxisAlignment.start,
                            //                 //     crossAxisAlignment: CrossAxisAlignment.start,
                            //                 //     children: [
                            //                 //       Text('Air Jordan 1 Dior',style: TextStyle(fontSize: 10),),
                            //                 //       Text('425 AED',style: TextStyle(fontSize: 10)),
                            //                 //       Text('Used',style: TextStyle(fontSize: 10)),
                            //                 //
                            //                 //     ],
                            //                 //   ),
                            //                 // )
                            //               ],
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.only(top: 1.0),
                            //               child: Column(
                            //                 mainAxisAlignment: MainAxisAlignment.start,
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   Text(
                            //                     'Air Jordan 1 Dior',
                            //                     style: TextStyle(
                            //                         fontSize: 10,
                            //                         fontWeight: FontWeight.w500),
                            //                   ),
                            //                   Text('425 AED',
                            //                       style: TextStyle(
                            //                           fontSize: 10,
                            //                           fontWeight: FontWeight.bold)),
                            //                   Text('Used',
                            //                       style: TextStyle(
                            //                           fontSize: 10,
                            //                           fontWeight: FontWeight.w200)),
                            //                 ],
                            //               ),
                            //             )
                            //           ],
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  )),
            )
                : Center(
              child: Image.asset(
                "assets/Larg-Size.gif",
                height: 125.0,
                width: 125.0,
              ),
            )),
      );
    });
  }
}

/*
class ProductDetailScreen extends StatefulWidget {
  final ProductsModel? product;
  ProductDetailScreen({this.product});

  @override
  _ProductDetailScreentate createState() => _ProductDetailScreentate();
}

class _ProductDetailScreentate extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  var utilservice = locator<UtilService>();
  CarouselController controller = CarouselController();
  int currentIndex = 0;
  bool isDeletingProduct = false;

  Future<void> _showMyDialog(
    String currentCurrency,
    BuildContext context,
    int productId,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AlertDialog(
              title: Text(
                AppLocalizations.of(context)
                    .translate('makeOffer')
                    .toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.w,
                    fontFamily: "MetropolisExtraBold"),
              ),
              content: Consumer<ProductProvider>(builder: (context, pp, _) {
                return SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(AppLocalizations.of(context)
                          .translate('enterPrice1')),
                      SizedBox(height: 20.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: pp.bidController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('bidAmount');
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: 'Metropolis',
                            letterSpacing: 2.2.w,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffix: Text(
                              currentCurrency,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.w,
                                  fontFamily: "MetropolisExtraBold"),
                            ),
                            // suffixText: "AED",
                            // suffixStyle:  TextStyle(fontWeight: FontWeight.bold,letterSpacing: 2,fontFamily: "MetropolisExtraBold"),
                            fillColor: Color(0xfff3f3f4),
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              actions: <Widget>[
                Consumer<ProductProvider>(builder: (context, pp, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text('Cancel'.toUpperCase()),
                        onPressed: () {
                          pp.bidController.text = '';
                          Navigator.of(context).pop();
                        },
                      ),
                      // Container(height: 60, width: 60, child: JumpingDots()),
                      // pp.isBidding == true
                      //     ? Container(
                      //         height: 60, width: 60, child: JumpingDots())
                      //     :
                      TextButton(
                        child: Text(
                            // AppLocalizations.of(context)
                            //   .translate('offer')
                            "offer".toUpperCase()),
                        onPressed: () async {
                          if (double.parse(pp.bidController.text.trim())
                                  .convertToEuro(context) >
                              pp.productDetail!.highestBid!) {
                            await context
                                .read<ProductProvider>()
                                .makeProductBid(
                                  int.parse(pp.bidController.text),
                                  productId,
                                  context,
                                );
                          } else {
                            utilservice.showToast(
                                'Your bid must be higher than the current bid',
                                ToastGravity.BOTTOM);
                          }
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue, //or set color with: Color(0xFF0000FF)
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, pp, _) {
      return Scaffold(
        bottomNavigationBar: context.read<AuthProvider>().user != null &&
                pp.productDetail != null
            ? pp.productDetail!.user!.id !=
                    context.read<AuthProvider>().user!.id
                ? Container(
                    height: 80,
                    child: Container(
                        child: Padding(
                      padding: EdgeInsets.only(right: 10.w, left: 5.w),
                      child: Row(
                        // mainAxisAlignment:
                        //     MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                if (context.read<AuthProvider>().user != null) {
                                  _showMyDialog(
                                      context
                                          .read<CurrencyProvider>()
                                          .selectedCurrency
                                          .toUpperCase(),
                                      context,
                                      pp.productDetail!.id!);
                                } else {
                                  utilservice.showDialogue(
                                      "Please Login To Bid On Products",
                                      context);
                                }
                              },
                              child: Container(
                                height: 45.h,
                                // width: (MediaQuery.of(context)
                                //             .size
                                //             .width /
                                //         2.5)
                                //     .w,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8.r)),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('makeOffer')
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.1.w,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                if (context.read<AuthProvider>().user != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ConfirmAddress(
                                        product: widget.product,
                                      ),
                                    ),
                                  );
                                }
                                // _showMyDialogPayment();
                              },
                              child: Container(
                                  height: 45.h,
                                  // width: (MediaQuery.of(context)
                                  //             .size
                                  //             .width /
                                  //         2.5)
                                  //     .w,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/authentic.png",
                                            color: Colors.white,
                                            width: 15.w,
                                            height: 15.h,
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('buyNow')
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: 1.12.w,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('verifiedAuthentic'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.12.w,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )

                        // : SizedBox(),
                        ),
                  )
                : null
            : null,
        /*  appBar: pp.productDetail != null
              ? AppBar(
                  toolbarHeight: 50,
                  elevation: 0,
                  actions: [
                    if (context.read<AuthProvider>().user != null)
                      if (pp.productDetail!.user!.id ==
                          context.read<AuthProvider>().user!.id) ...[
                        IconButton(
                          splashColor: Colors.black54,
                          highlightColor: Colors.transparent,
                          splashRadius: 26.r,
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            MyProgressDialog pr = MyProgressDialog(context);
                            pr.show();
                            pp.clearAddProductFormData();
                            for (int i = 0;
                                i < pp.productDetail!.images!.length;
                                i++) {
                              pp.networkImages.add(
                                ProductDetailImageClass(
                                  id: pp.productDetail!.images![i].id,
                                  images: pp.productDetail!.images![i].images,
                                ),
                              );
                              pp.imgeFiles[i].isPicked = true;
                            }

                            pp.selectedCategory = pp.categories.firstWhere(
                              (element) =>
                                  element.name!.toLowerCase() ==
                                  pp.productDetail!.category!.toLowerCase(),
                            );
                            await pp.getSizes(pp.selectedCategory!.id!);
                            pp.prodName.text = pp.productDetail!.name!;
                            pp.prodPrice.text = pp.productDetail!.price!
                                .convertToLocal(context)
                                .round()
                                .toString();
                            pp.selectedBrand = pp.brands.firstWhere((element) =>
                                element.name.toLowerCase() ==
                                pp.productDetail!.brand!.toLowerCase());
                            pp.selectedCondition = pp.productDetail!.condition!;
                            pp.selectedSize = pp.sizes.firstWhere((element) =>
                                element.size.toLowerCase() ==
                                pp.productDetail!.size!.toLowerCase());
                            pp.sizes
                                .firstWhere((element) =>
                                    element.id == pp.selectedSize!.id)
                                .isSelected = true;
                            pp.selectedColor = colorList.firstWhere((element) {
                              return element.colorName.toLowerCase() ==
                                  pp.productDetail!.color!.toLowerCase();
                            });
                            pp.descriptionController.text =
                                pp.productDetail!.description!;
                            colorList
                                .firstWhere((element) =>
                                    element.colorName.toLowerCase() ==
                                    pp.selectedColor!.colorName.toLowerCase())
                                .isSelected = true;
                            pr.hide();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProduct(
                                    // product: widget.product,
                                    ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          splashColor: Colors.red[300],
                          highlightColor: Colors.transparent,
                          splashRadius: 26.r,
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Warning'.toUpperCase()),
                                  content: Text(
                                    "Are you sure, You want to delete this product?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        MyProgressDialog pr =
                                            MyProgressDialog(context);
                                        pr.show();
                                        await pp.deleteProduct(
                                          pp.productDetail!.id!,
                                          context,
                                        );
                                        await pp.getHomeProducts();
                                        pr.hide();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Yes".toUpperCase()),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('No'.toUpperCase()))
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(
                          width: 5.w,
                        )
                      ],
                  ],
                  iconTheme: IconThemeData(color: Colors.black, size: 20),
                  backgroundColor: Colors.white10,
                )
              : null, */
        body: pp.productDetail != null
            ? AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: SingleChildScrollView(
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      // Container(
                      //     child: CarouselSlider.builder(
                      //   options: CarouselOptions(
                      //     aspectRatio: 2.0,
                      //     enlargeCenterPage: false,
                      //     viewportFraction: 1,
                      //   ),
                      //   itemCount: (images.length / 2).round(),
                      //   itemBuilder: (context, index, realIdx) {
                      //     final int first = index * 2;
                      //     final int second = first + 1;
                      //     return Row(
                      //       children: [first, second].map((idx) {
                      //         return Expanded(
                      //           flex: 1,
                      //           child: Container(
                      //             height: 250.h,
                      //             decoration: BoxDecoration(
                      //               color: Colors.white70,
                      //               boxShadow: kElevationToShadow[1],
                      //               borderRadius: BorderRadius.all(
                      //                 Radius.circular(
                      //                   14.r,
                      //                 ),
                      //               ),
                      //             ),
                      //             margin: EdgeInsets.symmetric(
                      //               horizontal: 10.w,
                      //               vertical: 10.h,
                      //             ),
                      //             padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      //             child:
                      //                 Image.asset(images[idx], fit: BoxFit.contain),
                      //           ),
                      //         );
                      //       }).toList(),
                      //     );
                      //   },
                      // )),
                      if (pp.productDetail!.images!.length > 0) ...[
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 50.0,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                              child: CarouselSlider(
                                carouselController: controller,
                                options: CarouselOptions(
                                  height: 350.h,
                                  viewportFraction: 1,
                                  enlargeCenterPage: true,
                                  onPageChanged: (position, reason) {
                                    currentIndex = position;
                                    setState(() {});
                                    if (kDebugMode) {
                                      print("cc $position && $currentIndex");

                                      print("cc $position && $currentIndex");
                                      print(reason);
                                      print(
                                          CarouselPageChangedReason.controller);
                                    }
                                  },
                                  enableInfiniteScroll: false,
                                ),
                                items:
                                    pp.productDetail!.images!.map<Widget>((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                Center(
                                              child: Container(
                                                height: 350.h,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width
                                                    .w,
                                                child: PhotoView(
                                                  imageProvider: NetworkImage(
                                                    i.images ?? '',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                          // Navigator.push(context,
                                          //     MaterialPageRoute(builder: (_) {
                                          //   return DetailScreen(
                                          //     image: i,
                                          //   );
                                          // }));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: i.images ?? '',

                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            // width: (MediaQuery.of(context)
                                            //         .size
                                            //         .width)
                                            //     .w,
                                            // margin: EdgeInsets.only(
                                            //   right: 10.w,
                                            //   bottom: 10.h,
                                            //   left: 5.w,
                                            // ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(
                                                  30.r,
                                                ),
                                                bottomRight: Radius.circular(
                                                  30.r,
                                                ),
                                              ),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              //         JumpingDots(
                                              //   forImage: true,
                                              //   isLoadingShow: true,
                                              // ),
                                              Center(
                                            child: CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              color: Colors.black,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),

                                          // fit: BoxFit.cover,
                                        ),
                                        // Container(
                                        //   width:
                                        //       MediaQuery.of(context).size.width,
                                        //   child: Image.network(
                                        //     i,
                                        //     fit: BoxFit.cover,
                                        // height: 200.h,
                                        // width: 350.w,
                                        //   ),
                                        // ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            if (context.read<AuthProvider>().user != null)
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 50.0,
                                    left: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (pp.productDetail!.user!.id ==
                                          context
                                              .read<AuthProvider>()
                                              .user!
                                              .id) ...[
                                        IconButton(
                                          splashColor: Colors.black54,
                                          highlightColor: Colors.transparent,
                                          splashRadius: 26.r,
                                          icon: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                            ),
                                          ),
                                          onPressed: () async {
                                            MyProgressDialog pr =
                                                MyProgressDialog(context);
                                            pr.show();
                                            pp.clearAddProductFormData();
                                            for (int i = 0;
                                                i <
                                                    pp.productDetail!.images!
                                                        .length;
                                                i++) {
                                              pp.networkImages.add(
                                                ProductDetailImageClass(
                                                  id: pp.productDetail!
                                                      .images![i].id,
                                                  images: pp.productDetail!
                                                      .images![i].images,
                                                ),
                                              );
                                              pp.imgeFiles[i].isPicked = true;
                                            }

                                            pp.selectedCategory =
                                                pp.categories.firstWhere(
                                              (element) =>
                                                  element.name!.toLowerCase() ==
                                                  pp.productDetail!.category!
                                                      .toLowerCase(),
                                            );
                                            await pp.getSizes(
                                                pp.selectedCategory!.id!);
                                            pp.prodName.text =
                                                pp.productDetail!.name!;
                                            pp.prodPrice.text = pp
                                                .productDetail!.price!
                                                .convertToLocal(context)
                                                .round()
                                                .toString();
                                            pp.selectedBrand = pp.brands
                                                .firstWhere((element) =>
                                                    element.name
                                                        .toLowerCase() ==
                                                    pp.productDetail!.brand!
                                                        .toLowerCase());
                                            pp.selectedCondition =
                                                pp.productDetail!.condition!;
                                            pp.selectedSize = pp.sizes
                                                .firstWhere((element) =>
                                                    element.size
                                                        .toLowerCase() ==
                                                    pp.productDetail!.size!
                                                        .toLowerCase());
                                            pp.sizes
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    pp.selectedSize!.id)
                                                .isSelected = true;
                                            pp.selectedColor =
                                                colorList.firstWhere((element) {
                                              return element.colorName
                                                      .toLowerCase() ==
                                                  pp.productDetail!.color!
                                                      .toLowerCase();
                                            });
                                            pp.descriptionController.text =
                                                pp.productDetail!.description!;
                                            colorList
                                                .firstWhere((element) =>
                                                    element.colorName
                                                        .toLowerCase() ==
                                                    pp.selectedColor!.colorName
                                                        .toLowerCase())
                                                .isSelected = true;
                                            pr.hide();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditProduct(
                                                    // product: widget.product,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          splashColor: Colors.red[300],
                                          highlightColor: Colors.transparent,
                                          splashRadius: 26.r,
                                          icon: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Warning'.toUpperCase()),
                                                  content: Text(
                                                    "Are you sure, You want to delete this product?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        MyProgressDialog pr =
                                                            MyProgressDialog(
                                                                context);
                                                        pr.show();
                                                        await pp.deleteProduct(
                                                          pp.productDetail!.id!,
                                                          context,
                                                        );
                                                        await pp
                                                            .getHomeProducts();
                                                        pr.hide();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                          "Yes".toUpperCase()),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                            'No'.toUpperCase()))
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        )
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 50.0, left: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8),
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.black,
                                        size: 25.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              // top: 0.h,

                              // left: MediaQuery.of(context).size.width / 1.2,
                              alignment: Alignment.bottomRight,
                              // alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                  child: Container(
                                    height: 35.h,
                                    width: 35.w,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: 3,
                                          ),
                                        ]),
                                    margin: EdgeInsets.only(
                                        right: 20.w,
                                        top: (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.7)
                                            .h),
                                    child: Center(
                                      child: pp.productDetail!.favourite == true
                                          ? Image.asset(
                                              'assets/finalFire.png',
                                              height: 25.h,
                                              width: 25.w,
                                            )
                                          : Image.asset('assets/Vector1.png'),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (context.read<AuthProvider>().user !=
                                        null) {
                                      if (pp.productDetail!.favourite ==
                                          false) {
                                        // pp.addingIntoFavLocall(
                                        //     pp.productDetail!.favourite);
                                        setState(() {});
                                        pp.productDetail!.favourite = true;
                                        await pp.addToFavoriteProducts(
                                          pp.productDetail!.id!,
                                        );
                                        setState(() {});
                                      } else {
                                        pp.removingFromFavLocall(
                                          pp.productDetail!.id!,
                                        );

                                        setState(() {});
                                        pp.productDetail!.favourite = false;
                                        await pp.removeFromFavoriteProducts(
                                          pp.productDetail!.id!,
                                        );
                                        setState(() {});
                                      }
                                    }
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                          child: DotsIndicator(
                            dotsCount: pp.productDetail!.images!.length,
                            position: currentIndex.toDouble(),
                            decorator: DotsDecorator(
                              spacing: EdgeInsets.only(
                                left: 3.w,
                                right: 3.w,
                              ),
                              size: Size(
                                5.w,
                                5.h,
                              ),
                              activeSize: Size(
                                5.w,
                                5.h,
                              ),
                              color: Colors.grey,
                              activeColor: Colors.black,
                            ),
                          ),
                        ),
                      ],
                      /*Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Container(
                              height: (MediaQuery.of(context).size.height * .25).h,
                              child: InfiniteCarousel.builder(
                                itemCount: images.length,
                                itemExtent: _itemExtent ?? 40,
                                scrollBehavior: kIsWeb
                                    ? ScrollConfiguration.of(context).copyWith(
                                        dragDevices: {
                                          // Allows to swipe in web browsers
                                          PointerDeviceKind.touch,
                                          PointerDeviceKind.mouse
                                        },
                                      )
                                    : null,
                                itemBuilder: (context, itemIndex, realIndex) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0.w,
                                      vertical: 5.h,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.animateToItem(realIndex);
                                        currentIndex = realIndex;
                                        print("cc $realIndex && $currentIndex");
                                        setState(() {});
                                        print("cc $realIndex && $currentIndex");
                                      },
                                      child: Container(
                                        width: 350.w,
                                        height: 500.h,
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(25.r),
                                          // boxShadow: kElevationToShadow[1],
                                          // image: DecorationImage(
                                          //   image: AssetImage(
                                          //     images[itemIndex],
                                          //   ),
                                          //   scale: 1,
                                          //   fit: BoxFit.contain,
                                          // ),
                                        ),
                                        child: Image.asset(
                                          images[itemIndex],
                                          fit: BoxFit.contain,
                                          width: 300,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                loop: _loop,
                                controller: controller,
                                onIndexChanged: (index) {
                                  if (_selectedIndex != index) {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  }
                                },
                              ),
                            )),*/
                      SizedBox(
                        height: 5.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 15.0.h,
                          left: 15.w,
                          right: 15.w,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 1.0.h),
                              width: (MediaQuery.of(context).size.width).w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pp.productDetail!.name!.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "MetropolisBold"),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        "${pp.productDetail!.condition}"
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'MetropolisBold',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 20.h,
                                            decoration: null,
                                            child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('highestBid'),
                                                style: TextStyle(
                                                  fontSize: 17.sp,
                                                  fontFamily: 'MetropolisBold',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black54,
                                                )),
                                          ),
                                          SizedBox(width: 5.w),
                                          // Text('  '),
                                          Container(
                                            height: 20.h,
                                            decoration: pp.productDetail!
                                                        .highestBid! >
                                                    0
                                                ? BoxDecoration(
                                                    color: Colors.orange,
                                                    border: Border.all(
                                                        color: Colors.orange),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      3.r,
                                                    ),
                                                  )
                                                : null,
                                            child: Text(
                                              pp.productDetail!.highestBid ==
                                                      0.0
                                                  ? 'No Bid Yet'
                                                  : '${pp.productDetail!.highestBid!.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency.toUpperCase()}'
                                                      .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontFamily: 'MetropolisBold',
                                                fontWeight: FontWeight.w600,
                                                color: pp.productDetail!
                                                            .highestBid ==
                                                        0.0
                                                    ? Colors.black54
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${context.read<CurrencyProvider>().selectedCurrency.toUpperCase()} ${pp.productDetail!.price!.convertToLocal(context).round()}'
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontFamily: 'MetropolisBold',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            /* if (context.read<AuthProvider>().user !=
                                  null) ...[
                                if (pp.productDetail!.user!.id !=
                                    context.read<AuthProvider>().user!.id)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 10.w, left: 5.w),
                                    child: Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: InkWell(
                                            onTap: () {
                                              if (context
                                                      .read<AuthProvider>()
                                                      .user !=
                                                  null) {
                                                _showMyDialog(
                                                    context
                                                        .read<
                                                            CurrencyProvider>()
                                                        .selectedCurrency
                                                        .toUpperCase(),
                                                    context,
                                                    pp.productDetail!.id!);
                                              } else {
                                                utilservice.showDialogue(
                                                    "Please Login To Bid On Products",
                                                    context);
                                              }
                                            },
                                            child: Container(
                                              height: 45.h,
                                              // width: (MediaQuery.of(context)
                                              //             .size
                                              //             .width /
                                              //         2.5)
                                              //     .w,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r)),
                                              child: Center(
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('makeOffer')
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    letterSpacing: 1.1.w,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Flexible(
                                          child: InkWell(
                                            onTap: () {
                                              if (context
                                                      .read<AuthProvider>()
                                                      .user !=
                                                  null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ConfirmAddress(
                                                      product: widget.product,
                                                    ),
                                                  ),
                                                );
                                              }
                                              // _showMyDialogPayment();
                                            },
                                            child: Container(
                                                height: 45.h,
                                                // width: (MediaQuery.of(context)
                                                //             .size
                                                //             .width /
                                                //         2.5)
                                                //     .w,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          "assets/authentic.png",
                                                          color: Colors.white,
                                                          width: 15.w,
                                                          height: 15.h,
                                                        ),
                                                        SizedBox(
                                                          width: 2.w,
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'buyNow')
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            letterSpacing:
                                                                1.12.w,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'verifiedAuthentic'),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        letterSpacing: 0.12.w,
                                                        fontSize: 10.sp,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // : SizedBox(),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ], */
                            Container(
                              height: 105.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(color: Color(0xff5DB3F5))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.h, left: 12.w),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/authentic.png",
                                          color: Color(0xff5DB3F5),
                                          width: 15.w,
                                          height: 15.h,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate('verifiedAuthentic'),
                                          style: TextStyle(
                                            color: Color(0xff5DB3F5),
                                            fontFamily: 'MetropolisMedium',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.width.w,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 12.0.w, right: 5.w),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate('authenticDetails'),
                                          style: TextStyle(
                                            color: Color(0xff5DB3F5),
                                            fontFamily: 'MetropolisMedium',
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      String url =
                                          "https://laybull.com/authentication-process";
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  WebLaybull(url)));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 12.0.w),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('learnMore'),
                                        style: TextStyle(
                                            color: Color(
                                              0xff5DB3F5,
                                            ),
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Seller'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 2.w,
                                  fontFamily: "MetropolisExtraBold"),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              horizontalTitleGap: 5,
                              leading: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(30.r),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: pp
                                        .productDetail!.user!.profile_picture!,
                                    // height: 20,
                                    // width: 20,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                pp.productDetail!.user!.first_name
                                        .toUpperCase() +
                                    " " +
                                    pp.productDetail!.user!.last_name
                                        .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  // letterSpacing: 2.w,
                                  fontFamily: "MetropolisBold",
                                ),
                              ),
                              trailing: TextButton(
                                onPressed: () async {
                                  if (context.read<AuthProvider>().user !=
                                      null) {
                                    if (context
                                            .read<AuthProvider>()
                                            .isfetchingUserDetail ==
                                        false) {
                                      await context
                                          .read<AuthProvider>()
                                          .getUserById(
                                              pp.productDetail!.user!.id,
                                              context,
                                              false);
                                    }
                                  }
                                },
                                child: Text(
                                  "View Profile".toUpperCase(),
                                  style: TextStyle(
                                    color: Color(0xff5DB3F5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    fontFamily: "MetropolisBold",
                                  ),
                                ),
                              ),
                            ),
                            /*  Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                            .translate('name')
                                            .toUpperCase() +
                                        ' :',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        letterSpacing: 2.w,
                                        fontFamily: "MetropolisBold"),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      print(
                                          "user id ${pp.productDetail!.user!.id}");
                                      if (context.read<AuthProvider>().user !=
                                          null) {
                                        if (context
                                                .read<AuthProvider>()
                                                .isfetchingUserDetail ==
                                            false) {
                                          await context
                                              .read<AuthProvider>()
                                              .getUserById(
                                                  pp.productDetail!.user!.id,
                                                  context,
                                                  false);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 30.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                        vertical: 5.h,
                                      ),
                                      child: Text(
                                        "${pp.productDetail!.user!.first_name} ${pp.productDetail!.user!.last_name}",
                                        style: TextStyle(
                                          color: Color(0xff5DB3F5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          fontFamily: "MetropolisBold",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                           */
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Specification'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 2.w,
                                    fontFamily: "MetropolisExtraBold",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Description'.toUpperCase() + ' :',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      letterSpacing: 2.w,
                                      fontFamily: "MetropolisBold",
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 200, minWidth: 100),
                                    child: Text(
                                      pp.productDetail!.description!
                                          .toUpperCase(),
                                      textAlign: TextAlign.right,
                                      maxLines: 10,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        letterSpacing: 2.w,
                                        fontFamily: "MetropolisBold",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                          .translate('size')
                                          .toUpperCase() +
                                      ' :',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      letterSpacing: 2.w,
                                      fontFamily: "MetropolisBold"),
                                ),
                                Spacer(),
                                Text(
                                  pp.productDetail!.size == ""
                                      ? 'Not Mentioned'
                                      : pp.productDetail!.size != null
                                          ? pp.productDetail!.category!
                                                      .toLowerCase() ==
                                                  'sneakers'
                                              ? "US ${pp.productDetail!.size}"
                                              : "${pp.productDetail!.size}"
                                          : 'Not Mentioned',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    letterSpacing: 2.w,
                                    fontFamily: "MetropolisBold",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                          .translate('color')
                                          .toUpperCase() +
                                      ' :',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      letterSpacing: 2.w,
                                      fontFamily: "MetropolisBold"),
                                ),
                                Spacer(),
                                Text(
                                  pp.productDetail!.color != ""
                                      ? pp.productDetail!.color!
                                      : "Not Given",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      letterSpacing: 2.w,
                                      fontFamily: "MetropolisBold"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Condition'.toUpperCase() + ' :',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 2.w,
                                    fontFamily: "MetropolisBold",
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  pp.productDetail!.condition!.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    letterSpacing: 2.w,
                                    fontFamily: "MetropolisBold",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),

                            SizedBox(
                              height: 25.h,
                            ),

                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: PictureDialog(
                                          key: UniqueKey(),
                                          address: 'assets/sizeguide.jpg',
                                        )));
                              },
                              child: Container(
                                height:
                                    (MediaQuery.of(context).size.height / 16).h,
                                width:
                                    (MediaQuery.of(context).size.width / 1.1).w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)
                                      .translate('sizeGuide')
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'MetropolisBold',
                                    letterSpacing: 1.w,
                                    fontSize: 15.0.sp,
                                  ),
                                )),
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            // Text('RELATED PRODUCTS', style: Textprimary),
                            // Container(
                            //   height: MediaQuery.of(context).size.height / 3.5,
                            //   width: MediaQuery.of(context).size.width,
                            //   //color: Colors.black,
                            //   child: GridView.builder(
                            //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            //         maxCrossAxisExtent: 200,
                            //         // childAspectRatio: (itemWidth / itemHeight),
                            //         crossAxisSpacing: 20,
                            //         mainAxisSpacing: 20),
                            //     physics: NeverScrollableScrollPhysics(),
                            //     itemCount: slideList.length,
                            //     itemBuilder: (BuildContext ctx, index) {
                            //       return Container(
                            //         child: Column(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Stack(
                            //               children: [
                            //                 Column(
                            //                   children: [
                            //                     Container(
                            //                       height: 100,
                            //                       width:
                            //                           MediaQuery.of(context).size.width /
                            //                               2.4,
                            //                       decoration: BoxDecoration(
                            //                         color: Greycolor,
                            //                         borderRadius:
                            //                             BorderRadius.circular(10),
                            //                       ),
                            //                       child:
                            //                           Image.asset(slideList[index].image),
                            //                     ),
                            //                   ],
                            //                 ),
                            //                 Padding(
                            //                   padding: const EdgeInsets.only(
                            //                       left: 120.0, top: 77),
                            //                   child: Container(
                            //                     height: 30,
                            //                     width: 30,
                            //                     decoration: BoxDecoration(
                            //                       color: Colors.white,
                            //                       borderRadius: BorderRadius.circular(20),
                            //                     ),
                            //                     child: Image.asset('assets/fire.png'),
                            //                   ),
                            //                 ),
                            //                 // Padding(
                            //                 //   padding: const EdgeInsets.only(top:123.0),
                            //                 //   child: Column(
                            //                 //     mainAxisAlignment: MainAxisAlignment.start,
                            //                 //     crossAxisAlignment: CrossAxisAlignment.start,
                            //                 //     children: [
                            //                 //       Text('Air Jordan 1 Dior',style: TextStyle(fontSize: 10),),
                            //                 //       Text('425 AED',style: TextStyle(fontSize: 10)),
                            //                 //       Text('Used',style: TextStyle(fontSize: 10)),
                            //                 //
                            //                 //     ],
                            //                 //   ),
                            //                 // )
                            //               ],
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.only(top: 1.0),
                            //               child: Column(
                            //                 mainAxisAlignment: MainAxisAlignment.start,
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   Text(
                            //                     'Air Jordan 1 Dior',
                            //                     style: TextStyle(
                            //                         fontSize: 10,
                            //                         fontWeight: FontWeight.w500),
                            //                   ),
                            //                   Text('425 AED',
                            //                       style: TextStyle(
                            //                           fontSize: 10,
                            //                           fontWeight: FontWeight.bold)),
                            //                   Text('Used',
                            //                       style: TextStyle(
                            //                           fontSize: 10,
                            //                           fontWeight: FontWeight.w200)),
                            //                 ],
                            //               ),
                            //             )
                            //           ],
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  )),
                ),
              )
            : Center(
                child: Image.asset(
                  "assets/Larg-Size.gif",
                  height: 125.0,
                  width: 125.0,
                ),
              ),
      );
    });
  }
}
*/
