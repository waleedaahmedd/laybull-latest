// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/categories_model.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:provider/src/provider.dart';

class SliderItemWIdget extends StatelessWidget {
  final CategoriesModel sliderData;
  SliderItemWIdget({
    required this.sliderData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    
     Padding(
      padding: EdgeInsets.only(left: 0.0.w),
      child: Stack(
        children: [
          SizedBox(
              height: 180.h,
              width: 370.w,
              child: Image.asset(
                'assets/images/banner_bg.jpg',
                fit: BoxFit.fitWidth,
              )),
          Container(
            height: 180.h,
            width: 340.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(15.r),
              ),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 150.w),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Center(
                          child: Text(
                            sliderData.name!, //"New items with free shipping",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: 100.w,
                      child: ElevatedButton(
                        onPressed: () async {
                          await context
                              .read<ProductProvider>()
                              .getCategoryDetail(
                                  int.parse(sliderData.category_to_redirect!),
                                  context);
                        },
                        child: Text(
                          AppLocalizations.of(context).translate('buyNow'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.yellow,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.0.h),
                  child: SizedBox(
                    height: 160.h,
                    width: 180.w,
                    child: Transform.rotate(
                      angle: 69.3,
                      child: Image.network(
                        sliderData.image!, //'assets/images/banner_shoes.png',
                        // scale: 2,
                        fit: BoxFit.contain,
                        // height: 160.h,
                        // width: 190.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
