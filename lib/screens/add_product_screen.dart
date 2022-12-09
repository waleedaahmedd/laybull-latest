// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/globals.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/models/brand_model.dart';
import 'package:laybull_v3/models/categories_model.dart';
import 'package:laybull_v3/models/color_model.dart';
import 'package:laybull_v3/models/image_model.dart';
import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/models/size_list_model.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/crop_image_widget.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';
import 'package:laybull_v3/widgets/reusable_widget/jumping_dots.dart';
import 'package:laybull_v3/widgets/size_chart_widget.dart';
import 'package:provider/provider.dart';
import 'package:laybull_v3/extensions.dart';
import 'package:shimmer/shimmer.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var utilService = locator<UtilService>();
  MyProgressDialog? pr;

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      for (var color in colorList) {
        color.isSelected = false;
      }
      context.read<ProductProvider>().brands.forEach((brand) {
        brand.isSelected = false;
      });
      context.read<ProductProvider>().sizes.forEach((size) {
        size.isSelected = false;
      });

      // await context.read<ProductProvider>().getCategoriesAndBrand();
    });

    context.read<ProductProvider>().selectedCondition = context.read<ProductProvider>().listCond[0];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pr = MyProgressDialog(context);
    return WillPopScope(
      onWillPop: () {
        // context.read<ProductProvider>().clearAddProductFormData();
        context.read<ProductProvider>().selectedCategory = null;
        context.read<ProductProvider>().sizes = [];
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white10,
            title: Text(
              'Sell'.toUpperCase(),
              style: headingStyle,
            )),
        body: GestureDetector(
          onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          child: Consumer<ProductProvider>(builder: (context, pp, _) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 18.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category'.toUpperCase(),
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),

                    pp.categories.isNotEmpty
                        ? Container(
                            height: pp.filedHeight.h,
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[400]!),
                              borderRadius: BorderRadius.circular(5.0.r),
                            ),
                            child: DropdownButton<CategoriesModel>(
                              isExpanded: true,
                              hint: Text(AppLocalizations.of(context).translate('selectCategory')),
                              dropdownColor: Colors.grey[100],
                              icon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 20.sp,
                                color: Colors.black,
                              ),
                              value: pp.selectedCategory,
                              iconSize: 12.sp,
                              underline: SizedBox(),
                              style: TextStyle(color: Colors.black, fontSize: 15.sp),
                              onChanged: (newValue) async {
                                // pp.selectedCategory = null;
                                pp.selectedCategory = newValue as CategoriesModel;
                                setState(() {});

                                await pp.getSizes(pp.selectedCategory!.id!);

                                if (pp.selectedCategory!.name!.toLowerCase() == 'sneakers') {
                                  pp.isCategory = false;
                                  pp.imgeFiles = [
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                  ];
                                  pp.imageFrameTextList = [
                                    AppLocalizations.of(context).translate('appearance'),
                                    AppLocalizations.of(context).translate('front'),
                                    AppLocalizations.of(context).translate('leftShot'),
                                    AppLocalizations.of(context).translate('rightShot'),
                                    AppLocalizations.of(context).translate('backShot'),
                                    AppLocalizations.of(context).translate('boxLabel'),
                                    AppLocalizations.of(context).translate('extras'),
                                    AppLocalizations.of(context).translate('other'),
                                  ];
                                } else {
                                  pp.isCategory = false;
                                  pp.imgeFiles = [
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                    ImageClass(isPicked: false, image: null),
                                  ];
                                  pp.imageFrameTextList = [
                                    AppLocalizations.of(context).translate('appearance'),
                                    AppLocalizations.of(context).translate('front'),
                                    AppLocalizations.of(context).translate('leftShot'),
                                    AppLocalizations.of(context).translate('rightShot'),
                                    AppLocalizations.of(context).translate('backShot'),
                                    AppLocalizations.of(context).translate('boxLabel'),
                                    AppLocalizations.of(context).translate('extras'),
                                    AppLocalizations.of(context).translate('other'),
                                  ];
                                }

                                for (var element in pp.sizes) {
                                  element.isSelected = false;
                                }
                                // for (var element in slideSizesExceptSneakers) {
                                //   element.isSelected = false;
                                // }
                                pp.selectedSize = null;
                                setState(() {});
                              },
                              items: pp.categories.map((valueItem) {
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
                          )
                        : SizedBox(
                            width: 200.0,
                            height: 100.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.red,
                              highlightColor: Colors.yellow,
                              child: Text(
                                'Fetching',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('productName').toUpperCase(),
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        controller: pp.prodName,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          hintText: AppLocalizations.of(context).translate('enterProductName'),
                          contentPadding: EdgeInsets.only(left: 10.w),
                          hintStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Description'.toUpperCase(),
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                        controller: pp.descriptionController,
                        minLines: 1,
                        maxLength: 500,
                        maxLines: 6,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          hintText: 'Enter Description',
                          contentPadding: EdgeInsets.only(
                            left: 10.w,
                            bottom: 5.h,
                            top: 5.h,
                          ),
                          hintStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('brand').toUpperCase(),
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: pp.filedHeight.h,
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(5.0.r),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(AppLocalizations.of(context).translate('selectBrand')),
                        dropdownColor: Colors.grey[100],
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                        iconSize: 12.sp,
                        underline: SizedBox(),
                        style: TextStyle(color: Colors.black, fontSize: 15.sp),
                        value: pp.selectedBrand,
                        onChanged: (brand) {
                          pp.selectedBrand = brand as Brand;
                          setState(() {});
                        },
                        items: pp.brands.map((brand) {
                          return DropdownMenuItem(
                            value: brand,
                            child: Row(
                              children: <Widget>[
                                Text(brand.name),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('condition').toUpperCase(),
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),

                    Container(
                      height: pp.filedHeight.h,
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(5.0.r),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text(AppLocalizations.of(context).translate('used')),
                        dropdownColor: Colors.grey[100],
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                        iconSize: 12.sp,
                        underline: SizedBox(),
                        style: TextStyle(color: pp.selectedCondition == 'Select Condition' ? Colors.grey : Colors.black, fontSize: 15.sp),
                        value: pp.selectedCondition,
                        onChanged: (newValue) {
                          pp.selectedCondition = newValue as String;
                          setState(() {});
                        },
                        items: pp.listCond.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Row(
                              //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(valueItem),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      'Sizes (US)'.toUpperCase(),
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    pp.sizes.length > 0
                        ? SizedBox(
                            height: 50.h,
                            width: (MediaQuery.of(context).size.width / 1.13).w,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: pp.sizes.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                      padding: EdgeInsets.only(top: 5.h, bottom: 6.h, right: 5.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          for (int i = 0; i < pp.sizes.length; i++) {
                                            if (i != index) {
                                              pp.sizes[i].isSelected = false;
                                            }
                                          }
                                          setState(() {
                                            pp.sizes[index].isSelected = !pp.sizes[index].isSelected;
                                          });
                                          pp.selectedSize = pp.sizes[index];
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: pp.sizes[index].isSelected ? Colors.black : Color(0xffD5D5D5)),
                                            borderRadius: BorderRadius.circular(6.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              pp.selectedCategory != null
                                                  ?
                                                  // ? pp.selectedCategory!.name!
                                                  //             .toLowerCase() ==
                                                  //         'sneakers'
                                                  //     ? 'US ${pp.sizes[index].size}'
                                                  pp.sizes[index].size
                                                  : '',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ));
                                }),
                          )
                        : Container(),
                    /* : Container(
                            //color: Colors.grey,
                            height: 50.h,
                            width: (MediaQuery.of(context).size.width / 1.13).w,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: pp.slideSizesExceptSneakers.length,
                                itemBuilder: (_, index) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.h, bottom: 6.h, right: 5.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          for (int i = 0;
                                              i < slideSizesExceptSneakers.length;
                                              i++) {
                                            if (i != index) {
                                              slideSizesExceptSneakers[i]
                                                  .isSelected = false;
                                            }
                                          }
                                          setState(() {
                                            slideSizesExceptSneakers[index]
                                                    .isSelected =
                                                !slideSizesExceptSneakers[index]
                                                    .isSelected;
                                          });
                                          selectedSize =
                                              slideSizesExceptSneakers[index];
                                        },
                                        child: Container(
                                          height: 54.h,
                                          width:
                                              (MediaQuery.of(context).size.width /
                                                      7.5)
                                                  .w,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    slideSizesExceptSneakers[index]
                                                            .isSelected
                                                        ? Colors.black
                                                        : Color(0xffD5D5D5)),
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              slideSizesExceptSneakers[index].size,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ));
                                }),
                          ),*/
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('price').toUpperCase(),
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      // height: filedHeight,
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: pp.prodPrice,
                        onChanged: (value) {
                          setState(() {});
                        },
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Price',
                          fillColor: Colors.grey,
                          contentPadding: EdgeInsets.only(left: 10.w),
                          hintStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.grey),
                          suffixIcon: SizedBox(
                            width: 30.h,
                            child: Center(
                              child: Text(
                                context.read<CurrencyProvider>().selectedCurrency.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    if (pp.prodPrice.text != '')
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SubTotal'.toUpperCase(),
                                style: textSecondary,
                              ),
                              Text(
                                '${pp.prodPrice.text} ${context.read<CurrencyProvider>().selectedCurrency}'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Seller fee'.toUpperCase() + " :",
                                style: textSecondary,
                              ),
                              Text(
                                '${(double.parse(pp.prodPrice.text) * 10 / 100).round()} ${context.read<CurrencyProvider>().selectedCurrency}'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delievery Charges'.toUpperCase() + " :",
                                style: textSecondary,
                              ),
                              Text(
                                '${deliveryCharges.convertToLocal(context).round()} ${context.read<CurrencyProvider>().selectedCurrency}'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total'.toUpperCase() + " :",
                                style: textSecondary,
                              ),
                              Text(
                                '${(double.parse(pp.prodPrice.text.trim()) - (double.parse(pp.prodPrice.text.trim()) * 10 / 100) - deliveryCharges.convertToLocal(context).round()).round()} ${context.read<CurrencyProvider>().selectedCurrency}'
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      'Color'.toUpperCase(),
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      height: pp.filedHeight.h,
                      width: (MediaQuery.of(context).size.width / 1.13).w,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: colorList.length,
                          itemBuilder: (_, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 5.w),
                              child: GestureDetector(
                                onTap: () {
                                  for (int i = 0; i < colorList.length; i++) {
                                    if (i != index) {
                                      colorList[i].isSelected = false;
                                    }
                                  }
                                  setState(() {
                                    colorList[index].isSelected = !colorList[index].isSelected;
                                  });
                                  pp.selectedColor = colorList[index];
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
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('photos').toUpperCase(),
                          style: Textprimary,
                        ),
                        GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: PictureDialog(
                                        address: 'assets/PhotoguideLaybull.jpg',
                                      )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                AppLocalizations.of(context).translate('photoGuid'),
                                style: TextStyle(fontSize: 13.sp, color: Colors.blue),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    //..................................................................................................
                    /// Photos Data GridView
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: pp.isCategory ? 8 : 5,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.85),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height: 75.h,
                                  width: 75.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.0.w,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0.r)),
                                  ),
                                  child: Center(
                                    child: GestureDetector(
                                      onLongPress: () {
                                        setState(() {
                                          pp.imgeFiles[index].isPicked = false;
                                          pp.imgeFiles[index].image = null;
                                        });
                                      },
                                      onTap: () {
                                        _showPicker(context, index);
                                      },
                                      child: Container(
                                        child: pp.imgeFiles[index].isPicked
                                            ? Image.file(
                                                pp.imgeFiles[index].image!,
                                                width: 100.w,
                                                height: 100.h,
                                                fit: BoxFit.fill,
                                              )
                                            : Container(
                                                decoration: BoxDecoration(color: Color(0xFFE5F3FD), borderRadius: BorderRadius.circular(0)),
                                                width: 100.w,
                                                height: 100.h,
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                pp.imageFrameTextList[index],
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.1.w,
                                ),
                              ),
                            ],
                          );
                        }),

                    //this part will now be dublicated....................................................................
                    SizedBox(
                      height: 10.h,
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
                      height: 10.h,
                    ),

                    /// Add Button
                    IgnorePointer(
                      ignoring: pp.isAddingProduct,
                      child: InkWell(
                        onTap: () async {
                          if (pp.selectedCategory == null) {
                            utilService.showToast('Kindly Select Category', ToastGravity.CENTER);
                          } else if (pp.selectedBrand == null) {
                            utilService.showToast('Kindly Select Brand', ToastGravity.CENTER);
                          } else if (pp.selectedSize!.isSelected == false) {
                            utilService.showToast('Please Select Size', ToastGravity.CENTER);
                          } else if (pp.selectedColor!.isSelected == false) {
                            utilService.showToast('Please Select Color', ToastGravity.CENTER);
                          } else if (pp.selectedCondition == 'Select Condition') {
                            utilService.showToast('Please Select Conditon', ToastGravity.CENTER);
                          } else if (pp.prodPrice.text.trim().isEmpty) {
                            utilService.showToast('Please Enter Price', ToastGravity.CENTER);
                          } else if (pp.prodName.text.trim().isEmpty ||
                              pp.prodPrice.text.trim().isEmpty ||
                              pp.descriptionController.text.trim().isEmpty ||
                              pp.selectedCondition == '' ||
                              pp.selectedColor!.isSelected == false) {
                            utilService.showToast('Kindly Fill All Fields', ToastGravity.CENTER);
                          } else if (pp.imgeFiles.first.isPicked == false || pp.imgeFiles[1].isPicked == false) {
                            utilService.showToast('Appearance And Front Image Is Mandatory', ToastGravity.CENTER);
                          } else {
                            // pr!.show();
                            ProductsModel product = ProductsModel(
                              category_id: pp.selectedCategory!.id,
                              brand_id: pp.selectedBrand!.id,
                              name: pp.prodName.text.trim(),
                              description: pp.descriptionController.text.trim(),
                              price: double.parse(pp.prodPrice.text.trim()),
                              feature_image: pp.imgeFiles[0].image!.path,
                              color: pp.selectedColor!.colorName,
                              size_id: pp.selectedSize!.id,
                              condition: pp.selectedCondition,
                            );
                            await pp.addProduct(product, context);

                            pp.clearAddProductFormData();
                          }
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                          height: 45.h,
                          margin: EdgeInsets.only(bottom: 5.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5.0.r),
                          ),
                          child: pp.isAddingProduct == true
                              ? JumpingDots(
                                  isLoadingShow: false,
                                )
                              : Text(
                                  AppLocalizations.of(context).translate('add').toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.normal,
                                    // fontFamily: 'MetropolisBold',
                                    letterSpacing: 0.11.w,
                                    fontSize: 12.0.sp,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text(AppLocalizations.of(context).translate('photoLibrary')),
                      onTap: () {
                        print('tap');
                        // Provider.of<ProductProvider>(context, listen: false).imgFromGallery(index, false);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CropImageWidget(
                                      src: ImageSource.gallery,
                                      index: index,
                                    )));
                        // Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text(AppLocalizations.of(context).translate('camera')),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CropImageWidget(
                                    src: ImageSource.camera,
                                    index: index,
                                  )));
                      // Provider.of<ProductProvider>(context, listen: false).imgFromCamera(index, false);
                      // Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
