// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, missing_required_param

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/widgets/reusable_widget/jumping_dots.dart';
import 'package:laybull_v3/widgets/view_all_product_grid_view.dart';
import 'package:provider/provider.dart';

import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/models/categories_model.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/widgets/photo_grid_view.dart';

class HomeProductViewAllScreen extends StatefulWidget {
  String title;
  String type;
  HomeProductViewAllScreen({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  State<HomeProductViewAllScreen> createState() => _HomeProductViewAllScreenState();
}

class _HomeProductViewAllScreenState extends State<HomeProductViewAllScreen> {
  var scroll = ScrollController();
  int page = 2;

  @override
  void initState() {
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        if (context.read<AuthProvider>().user != null) {
          context.read<ProductProvider>().viewAllProductWithPagination(alreadyOnScreen: true, pageNumber: page, type: widget.type, context: context);
          setState(() {
            page++;
          });
        } else {
          context.read<ProductProvider>().viewAllProductWithPaginationGuest(alreadyOnScreen: true, pageNumber: page, type: widget.type, context: context);
          setState(() {
            page++;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scroll.removeListener(() {});
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, pp, _) {
      print(pp.isFetchingViewAll);
      return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white10,
            title: Text(
              pp.homeAllProductList != null ? widget.title : 'Fetching ...',
              style: headingStyle,
            )),
        body: pp.homeAllProductList != null
            ? SingleChildScrollView(
                controller: scroll,
                // physics: NeverScrollableScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.only(top: 18.h, left: 18.w, right: 18.w),
                  // height: MediaQuery.of(context).size.height.h,
                  width: MediaQuery.of(context).size.width.w,
                  child: pp.homeAllProductList!.isNotEmpty
                      ? Column(children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          // ignore: avoid_unnecessary_containers
                          Container(
                            child: ViewAllProductGridView(
                              // controller: scroll,
                              isViewAllrelease: widget.title == 'Release Calendar' ? true : false,
                              key: UniqueKey(),
                              product: pp.homeAllProductList,
                              onFavoutireButtonTapped: null,
                              isfavScreen: false,
                            ),
                          ),
                          if (pp.ispaginationDataLoading == true) ...[
                            SizedBox(
                              height: 30,
                              child: Center(
                                child: JumpingDots(
                                  isLoadingShow: false,
                                ),
                              ),
                            ),
                          ],
                          SizedBox(
                            height: 50,
                          )
                        ])
                      : Center(
                          child: Text(
                            "This category has no products.",
                            textAlign: TextAlign.center,
                            style: Textprimary,
                          ),
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
