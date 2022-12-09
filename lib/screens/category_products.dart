// ignore_for_file: prefer_const_constructors, missing_required_param

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/models/categories_model.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/widgets/photo_grid_view.dart';
import 'package:provider/provider.dart';

class CategoryProducts extends StatefulWidget {
  const CategoryProducts({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, pp, _) {
      return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white10,
            title: Text(
              pp.categoryDetail != null
                  ? pp.categoryDetail!.name!
                  : 'Fetching ...',
              style: headingStyle,
            )),
        body: pp.categoryDetail != null
            ? Container(
                padding: EdgeInsets.only(top: 18.h, left: 8.w, right: 8.w),
                height: MediaQuery.of(context).size.height.h,
                // width: MediaQuery.of(context).size.width.w,
                child: pp.categoryDetail!.products.length > 1
                    ? ListView(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          // ignore: avoid_unnecessary_containers
                          Container(
                            child: ProductGridView(
                              key: UniqueKey(),
                              product: pp.categoryDetail!.products,
                              onFavoutireButtonTapped: null,
                              isfavScreen: false,
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: Text(
                          "This category has no products.",
                          textAlign: TextAlign.center,
                          style: Textprimary,
                        ),
                      ),
              )
            : Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Image.asset(
                    "assets/Larg-Size.gif",
                    height: 125.0,
                    width: 125.0,
                  ),
                ),
              ),
      );
    });
  }
}
