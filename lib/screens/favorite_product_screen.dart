// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/widgets/photo_grid_view.dart';
import 'package:laybull_v3/widgets/reusable_widget/favorite_product_gridView.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class FavoriteProductScreen extends StatefulWidget {
  final bool isFromNavBar;
  FavoriteProductScreen({required this.isFromNavBar});
  @override
  _FavoriteProductScreenState createState() => _FavoriteProductScreenState();
}

class _FavoriteProductScreenState extends State<FavoriteProductScreen> {
  var click = false;
  // List<Product> wishlistshow = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, pp, _) {
      return RefreshIndicator(
        onRefresh: () async {
          if (context.read<AuthProvider>().user != null) {
            await pp.getFavoriteProducts();
          }
        },
        child: Scaffold(
            // appBar: AppBar(
            //     elevation: 0,
            //     automaticallyImplyLeading: false,
            //     backgroundColor: Colors.white10,
            //     title: Text(
            //       AppLocalizations.of(context).translate('favorite').toUpperCase(),
            //       style: headingStyle,
            //     )),
            body: context.read<AuthProvider>().user != null
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: pp.isFetchingProducts
                        ? Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: Image.asset(
                                "assets/Larg-Size.gif",
                                height: 125.0,
                                width: 125.0,
                              ),
                            ),
                          )
                        : pp.favoriteProducts.isEmpty
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height * .4,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('nothingToShow'),
                                    style: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 0.2.w,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10),
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width).w,
                                  height: (MediaQuery.of(context).size.height *
                                          1.02)
                                      .h,
                                  child: FavoriteProductGridView(
                                    key: UniqueKey(),
                                    product: pp.favoriteProducts,
                                    // onFavoutireButtonTapped: () async {
                                    //   if (pp.favoriteProducts[index].isFav ==
                                    //       true) {
                                    //     pp.favoriteProducts.removeWhere(
                                    //       (element) => element.isFav == false,
                                    //     );

                                    //     await pp.removeFromFavoriteProducts(
                                    //         pp.favoriteProducts[index].id!);
                                    //     setState(() {});
                                    //   }
                                    // },
                                  ),
                                ),
                              )
                    // ListView.builder(
                    //   itemCount: 1,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return ;
                    //   },
                    // ),
                    )
                : Container()),
      );
    });
  }
}
