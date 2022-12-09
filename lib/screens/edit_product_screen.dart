// ignore_for_file: prefer_final_fields, avoid_function_literals_in_foreach_calls, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/extensions.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/brand_model.dart';
import 'package:laybull_v3/models/categories_model.dart';
import 'package:laybull_v3/models/color_model.dart';
import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/crop_image_widget.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';

import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  var utilService = locator<UtilService>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // await context
        //     .read<ProductProvider>()
        //     .clearAddProductFormData()
        //     .then((value) => Navigator.of(context).pop());
        Navigator.of(context).pop();

        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white10,
          title: Text(
            AppLocalizations.of(context).translate('edit').toUpperCase(),
            style: headingStyle,
          ),
        ),
        body: Consumer<ProductProvider>(builder: (context, pp, _) {
          return GestureDetector(
            onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 18.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CATEGORY",
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(5.0.r),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(AppLocalizations.of(context).translate('selectCategory')),
                        dropdownColor: Colors.grey[100],
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                        iconSize: 12.sp,
                        underline: SizedBox(),
                        style: TextStyle(color: Colors.black, fontSize: 15.sp),
                        value: pp.selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            pp.selectedCategory = newValue as CategoriesModel;
                            context.read<ProductProvider>().sizes.forEach((element) {
                              element.isSelected = false;
                            });
                            pp.selectedSize = null;
                          });
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
                      height: 20.h,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('productName'),
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: 50.h,
                      width: (MediaQuery.of(context).size.width / 1.07).w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                      child: TextField(
                          controller: pp.prodName,
                          style: TextStyle(
                            fontSize: 18.sp,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            hintText: AppLocalizations.of(context).translate('enterProductName'),
                            contentPadding: EdgeInsets.only(left: 10.w),
                            hintStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.grey),
                          )),
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
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "BRAND",
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(
                          AppLocalizations.of(context).translate('selectBrand'),
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
                        value: pp.selectedBrand,
                        onChanged: (brand) {
                          setState(() {
                            print("valueee= ${pp.selectedBrand}");
                            pp.selectedBrand = brand as Brand;
                          });
                        },
                        items: context.read<ProductProvider>().brands.map((brand) {
                          return DropdownMenuItem(
                            value: brand,
                            child: Row(
                              //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        // hint: Text(AppLocalizations.of(context)
                        //     .translate('new')
                        //     .toUpperCase()),
                        dropdownColor: Colors.grey[100],
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                        iconSize: 12.sp,
                        underline: SizedBox(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                        ),
                        value: pp.selectedCondition,
                        onChanged: (newValue) {
                          setState(() {
                            pp.selectedCondition = newValue as String;
                          });
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
                      height: 25.sp,
                    ),
                    Text(
                      "AVAILABLE SIZES (US)",
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    pp.selectedCategory != null
                        ?
                        /*  selectedCategory!.name!.toUpperCase() == "SNEAKERS"
                          ? SizedBox(
                              //color: Colors.grey,
                              height: 50.h,
                              width: (MediaQuery.of(context).size.width / 1.13).w,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: slideSizesOfSneakers.length,
                                  itemBuilder: (_, index) {
                                    return Padding(
                                        padding: EdgeInsets.only(
                                          top: 5.h,
                                          bottom: 6.h,
                                          right: 5.w,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            for (int i = 0;
                                                i < slideSizesOfSneakers.length;
                                                i++) {
                                              if (i != index) {
                                                slideSizesOfSneakers[i].isSelected =
                                                    false;
                                              }
                                            }
                                            setState(() {
                                              slideSizesOfSneakers[index].isSelected =
                                                  !slideSizesOfSneakers[index]
                                                      .isSelected;
                                            });
                                            selectedSize = slideSizesOfSneakers[index];
                                          },
                                          child: Container(
                                            height: 54.h,
                                            width: (MediaQuery.of(context).size.width /
                                                    7.5)
                                                .w,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: slideSizesOfSneakers[index]
                                                          .isSelected
                                                      ? Colors.black
                                                      : Color(0xffD5D5D5)),
                                              borderRadius: BorderRadius.circular(6.r),
                                            ),
                                            child: Center(
                                              child: Text(
                                                slideSizesOfSneakers[index].size,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ));
                                  }),
                            )
                          : */
                        SizedBox(
                            //color: Colors.grey,
                            height: 50.h,
                            width: (MediaQuery.of(context).size.width / 1.13).w,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: context.read<ProductProvider>().sizes.length,
                                itemBuilder: (_, index) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                        top: 5.h,
                                        bottom: 6.h,
                                        right: 5.w,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          for (int i = 0; i < context.read<ProductProvider>().sizes.length; i++) {
                                            if (i != index) {
                                              context.read<ProductProvider>().sizes[i].isSelected = false;
                                            }
                                          }
                                          setState(() {
                                            context.read<ProductProvider>().sizes[index].isSelected = !context.read<ProductProvider>().sizes[index].isSelected;
                                          });
                                          pp.selectedSize = context.read<ProductProvider>().sizes[index];
                                        },
                                        child: Container(
                                          height: 54.h,
                                          width: (MediaQuery.of(context).size.width / 7.5).w,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: context.read<ProductProvider>().sizes[index].isSelected ? Colors.black : Color(0xffD5D5D5)),
                                            borderRadius: BorderRadius.circular(6.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              context.read<ProductProvider>().sizes[index].size,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ));
                                }),
                          )
                        : Container(),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "PRICE",
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: 50.h,
                      width: (MediaQuery.of(context).size.width / 1.07).w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Colors.grey[400]!)),
                      child: TextField(
                        controller: pp.prodPrice,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          contentPadding: EdgeInsets.only(left: 10.w),
                          suffixIcon: SizedBox(
                            height: 40.h,
                            width: 20.w,
                            child: Center(
                              child: Text(
                                '${context.read<CurrencyProvider>().selectedCurrency}'.toUpperCase(),
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
                    Text(
                      "AVAILABLE COLORS",
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      height: 59.h,
                      width: (MediaQuery.of(context).size.width / 1.13).w,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: colorList.length,
                          itemBuilder: (_, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 5.h),
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
                                      width: 40.h,
                                    ),
                                    colorList[index].isSelected
                                        ? Icon(
                                            Icons.done,
                                            color: index == 0 ? Colors.white : Colors.black,
                                            size: 30.sp,
                                          )
                                        : SizedBox(
                                            width: 5.sp,
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
                    Text(
                      "PHOTOS",
                      style: Textprimary,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),

                    /// Photos Data GridView
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: pp.imageFrameTextList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.85),
                        itemBuilder: (context, index) {
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
                                            ? pp.imgeFiles[index].image == null
                                                ? Image.network(
                                                    pp.networkImages[index].images!,
                                                    width: 100.w,
                                                    height: 100.h,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Image.file(
                                                    pp.imgeFiles[index].image!,
                                                    width: 100.w,
                                                    height: 100.h,
                                                    fit: BoxFit.fill,
                                                  )
                                            : Container(
                                                decoration: BoxDecoration(color: Color(0xFFE5F3FD), borderRadius: BorderRadius.circular(0.r)),
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
                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, letterSpacing: 1.1.w),
                              ),
                            ],
                          );
                        }),
                    SizedBox(
                      height: 20.h,
                    ),

                    /// Add Button
                    InkWell(
                      onTap: () async {
                        if (pp.selectedCategory == null) {
                          utilService.showToast('Kindly Select Category', ToastGravity.CENTER);
                        } else if (pp.selectedBrand == null) {
                          utilService.showToast('Kindly Select Brand', ToastGravity.CENTER);
                        } else if (pp.selectedSize == null) {
                          utilService.showToast('Please Select Size', ToastGravity.CENTER);
                        } else if (pp.selectedColor!.isSelected == false) {
                          utilService.showToast('Please Select Color', ToastGravity.CENTER);
                        } else if (pp.prodPrice.text.trim().isEmpty) {
                          utilService.showToast('Please Enter Price', ToastGravity.CENTER);
                        } else if (pp.selectedCondition == 'Select Condition') {
                          utilService.showToast('Please Select Conditon', ToastGravity.CENTER);
                        } else if (pp.prodName.text.trim().isEmpty ||
                            pp.prodPrice.text.trim().isEmpty ||
                            pp.descriptionController.text.trim().isEmpty ||
                            pp.selectedCondition == '' ||
                            pp.selectedColor!.isSelected == false) {
                          utilService.showToast('Kindly Fill All Fields', ToastGravity.CENTER);
                        } else if (pp.imgeFiles.first.isPicked == false || pp.imgeFiles[1].isPicked == false) {
                          utilService.showToast('Appearance And Front Image Is Mandatory', ToastGravity.CENTER);
                        } else {
                          ProductsModel product = ProductsModel(
                            id: pp.productDetail!.id,
                            category_id: pp.selectedCategory!.id,
                            brand_id: pp.selectedBrand!.id,
                            name: pp.prodName.text.trim(),
                            description: pp.descriptionController.text.trim(),
                            price: double.parse(pp.prodPrice.text.trim()).convertToEuro(context),
                            //  feature_image: pp.imgeFiles[0].image!.path,
                            color: pp.selectedColor!.colorName,
                            size_id: pp.selectedSize!.id,
                            condition: pp.selectedCondition,
                          );
                          var pr = MyProgressDialog(context);
                          pr.show();
                          await pp.updateProduct(product, context);
                          pr.hide();
                          Navigator.of(context).pop();
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
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'MetropolisBold',
                            letterSpacing: 0.11.w,
                            fontSize: 12.0.sp,
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
            ),
          );
        }),
      ),
    );
  }

  void _showPicker(context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        // Provider.of<ProductProvider>(context, listen: false).imgFromGallery(index, true);
                        // Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CropImageWidget(
                                      src: ImageSource.gallery,
                                      index: index,
                                    )));
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      // Provider.of<ProductProvider>(context, listen: false).imgFromCamera(index, true);
                      // Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CropImageWidget(
                                    src: ImageSource.camera,
                                    index: index,
                                  )));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
