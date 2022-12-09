// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_function_literals_in_foreach_calls

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/models/brand_model.dart';
import 'package:laybull_v3/models/categories_model.dart';
import 'package:laybull_v3/models/color_model.dart';
import 'package:laybull_v3/models/size_list_model.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/widgets/size_chart_widget.dart';
import 'package:provider/src/provider.dart';

class BottomSheetExample extends StatefulWidget {
  const BottomSheetExample({
    Key? key,
  }) : super(key: key);
  @override
  _BottomSheetExampleState createState() => _BottomSheetExampleState();
}

class _BottomSheetExampleState extends State<BottomSheetExample> {
  TextEditingController minValue = TextEditingController();
  TextEditingController maxValue = TextEditingController();

  @override
  void initState() {
    colorList.forEach((color) {
      color.isSelected = false;
    });
    context.read<ProductProvider>().brands.forEach((brand) {
      brand.isSelected = false;
    });
    context.read<ProductProvider>().sizes.forEach((size) {
      size.isSelected = false;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: GestureDetector(
        onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            // height: (MediaQuery.of(context).size.height / 1.1).h,
            color: Color(0xff757575),
            child: Container(
              padding: EdgeInsets.all(20.0.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0.r),
                  topRight: Radius.circular(30.0.r),
                ),
              ),
              child: Column(
                // shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    child: Divider(
                      height: 1.h,
                      thickness: 5.w,
                      indent: 100,
                      endIndent: 100,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('setFilters').toUpperCase(),
                    style: Textprimary,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('brand').toUpperCase(),
                    style: Textprimary,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: 59.h,
                    width: (MediaQuery.of(context).size.width / 1.13).w,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: context.read<ProductProvider>().brands.length,
                        itemBuilder: (BuildContext context, index) {
                          context.read<ProductProvider>().brands[index].isSelected = context.read<ProductProvider>().brands[index].isSelected;
                          return Padding(
                              padding: EdgeInsets.only(
                                left: 5.0.w,
                                top: 5.h,
                                bottom: 6.h,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  for (int i = 0; i < context.read<ProductProvider>().brands.length; i++) {
                                    if (i != index) {
                                      context.read<ProductProvider>().brands[i].isSelected = false;
                                    }
                                  }
                                  setState(() {
                                    context.read<ProductProvider>().brands[index].isSelected = !context.read<ProductProvider>().brands[index].isSelected;
                                    context.read<ProductProvider>().selectedBrand = context.read<ProductProvider>().brands[index];
                                  });
                                },
                                child: Container(
                                  height: 54.h,
                                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                                  // width: MediaQuery.of(context).size.width / 2.8,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: context.read<ProductProvider>().brands[index].isSelected ? Colors.black : Color(0xffD5D5D5),
                                    ),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: CachedNetworkImage(
                                            imageUrl: context.read<ProductProvider>().brands[index].image,
                                            fit: BoxFit.contain,

                                            imageBuilder: (context, imageProvider) => Container(
                                              height: 50.h,
                                              width: 50.w,
                                              // margin: EdgeInsets.only(
                                              //   right: 10.w,
                                              //   bottom: 10.h,
                                              //   left: 5.w,
                                              // ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                // borderRadius:
                                                //     BorderRadius.circular(12.r),
                                                // shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                              height: 50.h,
                                              width: 50.w,
                                              // margin: EdgeInsets.only(
                                              //   right: 10.w,
                                              //   bottom: 10.h,
                                              //   left: 5.w,
                                              // ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                // borderRadius:
                                                //     BorderRadius.circular(12.r),
                                                // shape: BoxShape.circle,
                                              ),
                                              child: Center(child: CircularProgressIndicator(color: Colors.grey, value: downloadProgress.progress)),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                                height: 50.h,
                                                width: 50.w,
                                                // margin: EdgeInsets.only(
                                                //   right: 10.w,
                                                //   bottom: 10.h,
                                                //   left: 5.w,
                                                // ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  // borderRadius:
                                                  //     BorderRadius.circular(12.r),
                                                  // shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.error)),
                                            // fit: BoxFit.cover,
                                          ),

                                          // Image.network(
                                          //   context
                                          //       .read<ProductProvider>()
                                          //       .brands[index]
                                          //       .image, // "https://cdn.britannica.com/94/193794-050-0FB7060D/Adidas-logo.jpg",
                                          //   fit: BoxFit.cover,
                                          // ),
                                          // margin: EdgeInsets.only(
                                          //   top: 5.h,
                                          //   left: 5.w,
                                          //   bottom: 5.h,
                                          // ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        }),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('color').toUpperCase(),
                    style: Textprimary,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: 59.h,
                    width: (MediaQuery.of(context).size.width / 1.13).w,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: colorList.length,
                        itemBuilder: (_, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 5.w),
                            child: GestureDetector(
                              onTap: () {
                                // for (int i = 0; i < colorList.length; i++) {
                                //   if (i != index) {
                                //     colorList[i].isSelected = false;
                                //   }
                                // }
                                // setState(() {
                                //   colorList[index].isSelected =
                                //       !colorList[index].isSelected;
                                //   selectedColor = colorList[index];
                                // });
                                for (int i = 0; i < colorList.length; i++) {
                                  if (i != index) {
                                    colorList[i].isSelected = false;
                                  }
                                }
                                setState(() {
                                  colorList[index].isSelected = !colorList[index].isSelected;
                                });
                                context.read<ProductProvider>().selectedColor = colorList[index];
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black45,
                                        width: 0.5.w,
                                      ),
                                      shape: BoxShape.circle,
                                      color: Color(colorList[index].colorValue),
                                    ),
                                    height: 40.h,
                                    width: 40.w,
                                  ),
                                  colorList[index].isSelected
                                      ? Icon(
                                          Icons.done,
                                          color: index == 0 ? Colors.white : Colors.black,
                                          size: 30.sp,
                                        )
                                      : SizedBox(
                                          width: 5.w,
                                        )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('category').toUpperCase(),
                    style: Textprimary,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(5.0.r),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Text(
                        AppLocalizations.of(context).translate('selectCategory'),
                      ),
                      dropdownColor: Colors.grey[100],
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 20.sp,
                        color: Colors.black,
                      ),
                      iconSize: 12.sp,
                      underline: SizedBox(),
                      style: TextStyle(color: Colors.black, fontSize: 15.sp),
                      value: context.read<ProductProvider>().selectedCategory,
                      onChanged: (newValue) async {
                        context.read<ProductProvider>().selectedCategory = newValue as CategoriesModel;
                        setState(() {});

                        await context.read<ProductProvider>().getSizes(context.read<ProductProvider>().selectedCategory!.id!);
                        setState(() {});
                        // setState(() {
                        //   selectedCategory = newValue;
                        //   print(selectedCategory.id);
                        //   getSizesByCategoryId(selectedCategory.id);
                        //   slideSizesOfSneakers.forEach((element) {
                        //     element.isSelected = false;
                        //   });
                        //   slideSizesExceptSneakers.forEach((element) {
                        //     element.isSelected = false;
                        //   });
                        //   selectedSize = null;
                        // });
                      },
                      items: context.read<ProductProvider>().categories.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Row(
                            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(valueItem.name!),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    // AppLocalizations.of(context).translate('sizes(us)')
                    "Sizes(US)".toUpperCase(),
                    style: Textprimary,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  context.read<ProductProvider>().sizes.isNotEmpty
                      ? SizedBox(
                          //color: Colors.grey,
                          height: 50.h,
                          width: (MediaQuery.of(context).size.width / 1.13).w,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: context.read<ProductProvider>().sizes.length,
                              itemBuilder: (_, index) {
                                return Padding(
                                    padding: EdgeInsets.only(top: 5.h, bottom: 6.h, right: 5.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        // for (int i = 0;
                                        //     i <
                                        //         context
                                        //             .read<ProductProvider>()
                                        //             .sizes
                                        //             .length;
                                        //     i++) {
                                        //   if (i != index) {
                                        //     context
                                        //         .read<ProductProvider>()
                                        //         .sizes[i]
                                        //         .isSelected = false;
                                        //   }
                                        // }
                                        // setState(() {
                                        //   context
                                        //           .read<ProductProvider>()
                                        //           .sizes[index]
                                        //           .isSelected =
                                        //       !context
                                        //           .read<ProductProvider>()
                                        //           .sizes[index]
                                        //           .isSelected;
                                        // });
                                        // selectedSize = context
                                        //     .read<ProductProvider>()
                                        //     .sizes[index];
                                        for (int i = 0; i < context.read<ProductProvider>().sizes.length; i++) {
                                          if (i != index) {
                                            context.read<ProductProvider>().sizes[i].isSelected = false;
                                          }
                                        }
                                        setState(() {
                                          context.read<ProductProvider>().sizes[index].isSelected = !context.read<ProductProvider>().sizes[index].isSelected;
                                        });
                                        context.read<ProductProvider>().selectedSize = context.read<ProductProvider>().sizes[index];
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                                        // height: 54.h,
                                        // width: (MediaQuery.of(context).size.width / 7.5).w,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: context.read<ProductProvider>().sizes[index].isSelected ? Colors.black : Color(0xffD5D5D5)),
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            context.read<ProductProvider>().sizes[index].size,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
                              }),
                        )
                      : Container(),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('priceRange').toUpperCase(),
                    style: Textprimary,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          height: 45.h,
                          width: (MediaQuery.of(context).size.width / 3).w,
                          child: TextFormField(
                            controller: minValue,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: 'Metropolis',
                              letterSpacing: 2.2.w,
                            ),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context).translate('min') + ': ${context.read<CurrencyProvider>().cSymbol}',
                              // "Min",
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                            ),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 45.h,
                          width: (MediaQuery.of(context).size.width / 3).w,
                          child: TextFormField(
                            controller: maxValue,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: 'Metropolis',
                              letterSpacing: 2.2.w,
                            ),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context).translate('max') + ': ${context.read<CurrencyProvider>().cSymbol}',
                              // "Max",
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height * .05).h,
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
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await context.read<ProductProvider>().searchProductWithFilter(
                            categoryid:
                                context.read<ProductProvider>().selectedCategory != null ? context.read<ProductProvider>().selectedCategory!.id.toString() : '',
                            brandId: context.read<ProductProvider>().selectedBrand != null ? context.read<ProductProvider>().selectedBrand!.id.toString() : '',
                            color: context.read<ProductProvider>().selectedColor != null ? context.read<ProductProvider>().selectedColor!.colorName : '',
                            sizeId: context.read<ProductProvider>().selectedSize != null ? context.read<ProductProvider>().selectedSize!.id.toString() : '',
                            minPrice: minValue.text.trim().isNotEmpty ? minValue.text.trim() : '',
                            maxPrice: maxValue.text.trim().isNotEmpty ? maxValue.text.trim() : '',
                          );
                      context.read<ProductProvider>().selectedCategory = null;
                      context.read<ProductProvider>().selectedBrand = null;
                      context.read<ProductProvider>().selectedColor = null;
                      context.read<ProductProvider>().selectedSize = null;
                      minValue.clear();
                      maxValue.clear();

                      Navigator.pop(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * .058,
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context).translate('applyFilters').toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.w,
                          fontSize: 12.sp,
                        ),
                      )),
                    ),

                    // child: Container(
                    //   alignment: Alignment.bottomCenter,
                    //   height: MediaQuery.of(context).size.height/13,
                    //   width: MediaQuery.of(context).size.width/1.1,
                    //   decoration: BoxDecoration(
                    //     color: Colors.black,
                    //     borderRadius: BorderRadius.circular(6),
                    //   ),
                    //   child: Center(
                    //       child: Text('SEARCH',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),
                    //       )),
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
