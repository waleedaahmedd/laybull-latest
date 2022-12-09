// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/widgets/photo_grid_view.dart';
import 'package:laybull_v3/extensions.dart';

import '../constants.dart';

class Selling extends StatefulWidget {
  final List<ProductsModel>? sellingProducts;
  Selling({this.sellingProducts});
  @override
  _SellingState createState() => _SellingState();
}

class _SellingState extends State<Selling> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white10,
          title: Text(
            AppLocalizations.of(context).translate('selling').toUpperCase(),
            style: headingStyle,
          )),
      body: Padding(
        padding: EdgeInsets.all(18.0.h),
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12.0.h),
                child: ProductGridView(
                  product: widget.sellingProducts,
                  onFavoutireButtonTapped: () {
                    setState(() {});
                  },
                  isfavScreen: false,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
