// ignore_for_file: missing_required_param, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/widgets/filters_bottom_sheet.dart';
import 'package:laybull_v3/widgets/photo_grid_view.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_text_field.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // searchs.clear();
  }

  // MyProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    // pr = MyProgressDialog(context);
    return Consumer<ProductProvider>(builder: (context, pp, _) {
      return WillPopScope(
        onWillPop: () {
          pp.selectedBrand = null;
          pp.selectedCategory = null;
          pp.selectedColor = null;
          pp.selectedSize = null;
          pp.searchedProducts.clear();
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
              backgroundColor: Colors.white10,
              title: Text(
                AppLocalizations.of(context).translate('search').toUpperCase(),
                style: headingStyle,
              )),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 13.0,
                  top: 10,
                ),
                child: Column(
                  children: [
                    // Container(
                    //   height: (MediaQuery.of(context).size.height * .06).h,
                    //   width: MediaQuery.of(context).size.width.w,
                    //   margin: EdgeInsets.only(left: 2.w, right: 20.w),
                    //   decoration: BoxDecoration(
                    //     color: const Color(0xffF4F4F4),
                    //     borderRadius: BorderRadius.circular(10.r),
                    //   ),
                    //   child: Padding(
                    //     padding: EdgeInsets.only(left: 10.0.w),
                    //     child: TextField(
                    //       controller: name,
                    //       decoration: InputDecoration(
                    //         hintStyle: TextStyle(fontSize: 14.sp),
                    //         hintText:
                    //             AppLocalizations.of(context).translate('search'),
                    //         // "Search",
                    //         alignLabelWithHint: true,
                    //         prefixIcon: Padding(
                    //           padding: EdgeInsets.only(top: 5.0.h),
                    //           child: Icon(
                    //             Icons.search,
                    //             color: Colors.black,
                    //             size: 18.sp,
                    //           ),
                    //         ),
                    //         border: InputBorder.none,
                    //         //contentPadding: EdgeInsets.all(20),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      // height: (MediaQuery.of(context).size.height * .07).h,
                      child: AppTextField(
                        controller: searchController,
                        textInputType: null,
                        hintText:
                            AppLocalizations.of(context).translate('search'),
                        isReadyOnly: false,
                        callback: null,
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    pp.isSearching == false
                        ? pp.searchedProducts.isNotEmpty
                            ? ProductGridView(
                                product: pp.searchedProducts,
                                isfavScreen: false,
                                onFavoutireButtonTapped: () {
                                  setState(() {});
                                },
                              )
                            : Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        .2),
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)
                                      .translate('noProductFound'),
                                  style: const TextStyle(color: Colors.black),
                                )),
                              )
                        : Center(
                            child: Image.asset(
                              "assets/Larg-Size.gif",
                              height: 125.0,
                              width: 125.0,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: (MediaQuery.of(context).size.height * .136).h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      searchController.clear();
                    });
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => BottomSheetExample(),
                    );
                    setState(() {});
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        // color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5.r)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .translate('filters')
                              .toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 10.sp),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        SizedBox(
                          height: 10.h,
                          width: 10.w,
                          child: Column(
                            children: [
                              Image.asset('assets/filter2.png'),
                              Image.asset('assets/filter1.png'),
                              Image.asset('assets/filter2.png'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height * .003).h,
                ),
                InkWell(
                  onTap: pp.isSearching == false
                      ? () async {
                          if (searchController.text.trim().isNotEmpty) {
                            await pp
                                .searchProduct(searchController.text.trim());
                          }
                        }
                      : null,
                  child: Container(
                    margin:
                        EdgeInsets.only(left: 20.w, right: 20.w, bottom: 15.h),
                    height: (MediaQuery.of(context).size.height * .05).h,
                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context).translate('search'),
                      // "Search".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
