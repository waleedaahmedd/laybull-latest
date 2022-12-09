// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers, avoid_types_as_parameter_names

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/dummy_data.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/screens/category_products.dart';
import 'package:laybull_v3/screens/product_detail_screen.dart';
import 'package:laybull_v3/screens/search_screen.dart';

import 'package:laybull_v3/util_services/routes.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_text_field.dart';
import 'package:laybull_v3/widgets/reusable_widget/cache_image.dart';
import 'package:laybull_v3/widgets/reusable_widget/release_calendar_chip.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:laybull_v3/widgets/reusable_widget/item_with_chip_widget.dart';

import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<int> listIndex = [0];
  // var locale;

  final CarouselController _controller = CarouselController();
  TextEditingController searchController = TextEditingController();
  MyProgressDialog? pr;
  var utilService = locator<UtilService>();

  int list_index = 0;

  @override
  Widget build(BuildContext context) {
    // context.read<CurrencyProvider>().setCurrency();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (context.read<AuthProvider>().user != null) {
            await context.read<ProductProvider>().getHomeProducts();
            await context.read<ProductProvider>().getHomeSlider();
            await context.read<ProductProvider>().getCategoriesAndBrand();
          } else {
            await context.read<ProductProvider>().getGuestHomeProducts();
            await context.read<ProductProvider>().getHomeSlider();
            await context.read<ProductProvider>().getCategoriesAndBrand();
          }

          setState(() {});
        },
        child: SingleChildScrollView(
          child: Consumer<ProductProvider>(
            builder: (context, pp, _) {
              return pp.homeData != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (pp.homeSlider.isNotEmpty)
                          CarouselSlider(
                            carouselController: _controller,
                            options: CarouselOptions(
                              aspectRatio: 5.0 / 2.4,
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                              enlargeCenterPage: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  list_index = index;
                                });
                              },
                              autoPlay: true,
                            ),
                            items: pp.homeSlider.map<Widget>((i) {
                              return Builder(builder: (BuildContext context) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height * 0.22,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              opacity: 0.8,
                                              fit: BoxFit.cover,
                                              image: NetworkImage(i.image!),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context).size.height * 0.04,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 30,
                                                  top: 20,
                                                  // bottom: 10,
                                                ),
                                                child: Text(
                                                  i.name!,
                                                  style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10, right: 30),
                                                child: Text(
                                                  i.description!,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    height: 1.4,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 10.w,
                                                  right: 30.w,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await pp.getCategoryDetail(int.parse(i.category_to_redirect!), context);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.only(
                                                          top: 10.h,
                                                          bottom: 10.h,
                                                          left: 10.w,
                                                          right: 10.w,
                                                        ),
                                                        decoration: const BoxDecoration(
                                                          color: Colors.black,
                                                        ),
                                                        child: Text(
                                                          "Buy & Sell Now",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: 'MetropolisMedium',
                                                            fontSize: 13.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomLeft,
                                                      child: Container(
                                                        child: AnimatedSmoothIndicator(
                                                          activeIndex: list_index,
                                                          count: pp.homeSlider.length,
                                                          effect: WormEffect(
                                                            dotHeight: 10.h,
                                                            dotWidth: 10.w,
                                                            activeDotColor: Colors.black,
                                                          ), // your preferred effect
                                                          onDotClicked: (index) {},
                                                        ),
                                                      ),
                                                    ),
                                                    //             Row(
                                                    //   mainAxisAlignment:
                                                    //       MainAxisAlignment.end,
                                                    //   children:
                                                    //       pp.homeSlider.map<Widget>((i) {
                                                    //     return GestureDetector(
                                                    //       onTap: () =>
                                                    //           _controller.animateToPage(),
                                                    //       child: Container(
                                                    //         width: 10,
                                                    //         height: 10,
                                                    //         margin: const EdgeInsets
                                                    //             .symmetric(
                                                    //           vertical: 8.0,
                                                    //           horizontal: 4.0,
                                                    //         ),
                                                    //         decoration: BoxDecoration(
                                                    //           border: Border.all(
                                                    //               width: 1,
                                                    //               color: Theme.of(context)
                                                    //                           .brightness ==
                                                    //                       Brightness.dark
                                                    //                   ? Colors.black
                                                    //                   : Colors
                                                    //                       .grey.shade300),
                                                    //           shape: BoxShape.circle,
                                                    //           color: (Theme.of(context)
                                                    //                           .brightness ==
                                                    //                       Brightness.dark
                                                    //                   ? Colors.black
                                                    //                   : Colors
                                                    //                       .grey.shade300)
                                                    //               .withOpacity(
                                                    //             listIndex.contains(
                                                    //                     entry.key)
                                                    //                 ? 0.7
                                                    //                 : listIndex.contains(
                                                    //                         entry.key)
                                                    //                     ? 0.7
                                                    //                     : listIndex.contains(
                                                    //                             entry.key)
                                                    //                         ? 0.7
                                                    //                         : 0.0,
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //     );
                                                    //   }).toList(),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                            }).toList(),
                          ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context).translate('shopByCategory').toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MetropolisExtraBold',
                                  letterSpacing: 1.5,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            pp.homeData!.categories != null
                                ? Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    height: 35.h,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: pp.homeData!.categories!.length,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            width: 15.w,
                                          );
                                        },
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                              onTap: () async {
                                                // pr = MyProgressDialog(context);
                                                // pr!.show();
                                                // log(pp.homeData!.categories![index].id!.toString());
                                                pp.setProductCategory(pp.homeData!.categories![index].id!);
                                                await pp.getCategoryDetail(pp.homeData!.categories![index].id!, context);
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: pp.categorySelected == pp.homeData!.categories![index].id! ? Colors.black : Colors.grey.shade300,
                                                    borderRadius: BorderRadius.circular(12.r),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 15.w,
                                                  ),
                                                  // padding: EdgeInsets.all(5),
                                                  child: Center(
                                                    child: Text(
                                                      pp.homeData!.categories![index].name != null
                                                          ? pp.homeData!.categories![index].name!.toUpperCase()
                                                          : AppLocalizations.of(context).translate('sneaker').toUpperCase(),

                                                      //category[index].destination,
                                                      style: TextStyle(
                                                        color: pp.categorySelected == pp.homeData!.categories![index].id! ? Colors.white : Colors.black54,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 11.sp,
                                                        fontFamily: "MetropolisRegular",
                                                      ),
                                                    ),
                                                  ))

                                              // Container(
                                              //   padding: EdgeInsets.all(5),
                                              //   child: Column(
                                              //     mainAxisAlignment: MainAxisAlignment.center,
                                              //     children: [
                                              //       Container(
                                              //         // height: 120.h,
                                              //         // width: 120.w,
                                              //         decoration: BoxDecoration(color: Colors.grey.shade200),
                                              //         child: CachedNetworkImage(
                                              //           width: 100.w,
                                              //           height: 100.w,
                                              //           imageUrl: pp.homeData!.categories![index].image!,
                                              //           errorWidget: (context, url, error) => Icon(Icons.error),
                                              //           progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                              //               child: CircularProgressIndicator(
                                              //             color: Colors.grey,
                                              //           )),
                                              //         ),
                                              //       ),
                                              //       SizedBox(
                                              //         height: 10.h,
                                              //       ),
                                              //       Text(
                                              //         pp.homeData!.categories![index].name != null
                                              //             ? pp.homeData!.categories![index].name!.toUpperCase()
                                              //             : AppLocalizations.of(context).translate('sneaker').toUpperCase(),
                                              //         maxLines: 1,
                                              //         overflow: TextOverflow.ellipsis,
                                              //         //category[index].destination,
                                              //         style: TextStyle(
                                              //           fontWeight: FontWeight.bold,
                                              //           fontSize: 11.sp,
                                              //           fontFamily: "MetropolisRegular",
                                              //         ),
                                              //       )
                                              //     ],
                                              //   ),
                                              // )

                                              );
                                        }),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate('releaseCalendar').toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'MetropolisExtraBold',
                                        letterSpacing: 1.5,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    // TextButton(
                                    //   onPressed: () async {
                                    //     // utilService.showToast('Under Development');
                                    //     if (context.read<AuthProvider>().user != null) {
                                    //       await pp.viewAllProductWithPagination(
                                    //         pageNumber: 1,
                                    //         type: 'release_calendar',
                                    //         context: context,
                                    //         alreadyOnScreen: false,
                                    //         navigationTitle: 'Release Calendar',
                                    //       );
                                    //     } else {
                                    //       await pp.viewAllProductWithPaginationGuest(
                                    //         pageNumber: 1,
                                    //         type: 'release_calendar',
                                    //         context: context,
                                    //         alreadyOnScreen: false,
                                    //         navigationTitle: 'Release Calendar',
                                    //       );
                                    //     }
                                    //   },
                                    //   child: Text(
                                    //     AppLocalizations.of(context).translate('viewAll').toUpperCase(),
                                    //     style: TextStyle(
                                    //       letterSpacing: 1.2,
                                    //       fontSize: 12.sp,
                                    //       fontFamily: 'MetropolisExtraBold',
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                pp.homeData!.release != null || pp.homeData!.release!.isNotEmpty
                                    ? ConstrainedBox(
                                        constraints: BoxConstraints(maxHeight: 150.h),
                                        child: ListView.builder(
                                            // padding: EdgeInsets.only(bottom: 10.0.h),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: pp.homeData!.release!.length,
                                            /*separatorBuilder: (context, index) => SizedBox(
                                                  width: 10.w,
                                                ),*/
                                            itemBuilder: (context, index) {
                                              return ReleaseCalendarChip(
                                                dateShow: true,
                                                // onTap: () async {
                                                //   // pr = MyProgressDialog(context);
                                                //   // pr!.show();
                                                //   await pp.getProductDetail(
                                                //       pp.homeData!.release![index].id!,
                                                //       context,
                                                //       false);
                                                // },
                                                onTap: null,
                                                fireOnTap: () {},
                                                key: UniqueKey(),
                                                //  asset: 'assets/images/shoe${index + 1}.png',
                                                productsModel: pp.homeData!.release![index],
                                              );
                                            }),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate('popularProducts').toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'MetropolisExtraBold',
                                        letterSpacing: 1.5,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Navigator.of(context).push(MaterialPageRoute(
                                        //     builder: (BuildContext context) =>
                                        //         CategoryProducts()));
                                        // utilService.showToast('Under Development');
                                        if (context.read<AuthProvider>().user != null) {
                                          await pp.viewAllProductWithPagination(
                                            pageNumber: 1,
                                            type: 'popular_product',
                                            context: context,
                                            alreadyOnScreen: false,
                                            navigationTitle: 'Popular Product',
                                          );
                                        } else {
                                          await pp.viewAllProductWithPaginationGuest(
                                            pageNumber: 1,
                                            type: 'popular_product',
                                            context: context,
                                            alreadyOnScreen: false,
                                            navigationTitle: 'Popular Product',
                                          );
                                        }
                                      },
                                      child: Text(
                                        AppLocalizations.of(context).translate('viewAll').toUpperCase(),
                                        style: TextStyle(
                                          letterSpacing: 1.2.w,
                                          fontFamily: 'MetropolisExtraBold',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                LimitedBox(
                                  maxHeight: 210.h,
                                  child: pp.homeData!.popular != null || pp.homeData!.popular!.isNotEmpty
                                      ? ListView.separated(
                                          padding: EdgeInsets.only(bottom: 0),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: pp.homeData!.popular!.length,
                                          separatorBuilder: (context, index) => SizedBox(
                                                width: 10.w,
                                              ),
                                          itemBuilder: (context, index) {
                                            return ItemWithPriceChip(
                                              dateShow: false,
                                              onTap: () async {
                                                if (context.read<AuthProvider>().user != null) {
                                                  await pp.getProductDetail(pp.homeData!.popular![index].id!, context, false);
                                                } else {
                                                  await pp.getGuestProductDetail(pp.homeData!.popular![index].id!, context, false);
                                                }
                                              },
                                              fireOnTap: () async {},
                                              key: UniqueKey(),
                                              //  asset: 'assets/images/shoe${index + 1}.png',
                                              productsModel: pp.homeData!.popular![index],
                                            );
                                          })
                                      : Container(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate('laybullPicks').toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        fontFamily: 'MetropolisExtraBold',
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // utilService.showToast('Under Development');
                                        if (context.read<AuthProvider>().user != null) {
                                          await pp.viewAllProductWithPagination(
                                            pageNumber: 1,
                                            type: 'laybull_pick',
                                            context: context,
                                            alreadyOnScreen: false,
                                            navigationTitle: 'Laybull Pick',
                                          );
                                        } else {
                                          await pp.viewAllProductWithPaginationGuest(
                                            pageNumber: 1,
                                            type: 'laybull_pick',
                                            context: context,
                                            alreadyOnScreen: false,
                                            navigationTitle: 'Laybull Pick',
                                          );
                                        }
                                      },
                                      child: Text(
                                        AppLocalizations.of(context).translate('viewAll').toUpperCase(),
                                        style: TextStyle(
                                          letterSpacing: 1.2,
                                          fontSize: 12.sp,
                                          fontFamily: 'MetropolisExtraBold',
                                          // fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                LimitedBox(
                                  maxHeight: 210.h,
                                  child: pp.homeData!.laybullPicks != null || pp.homeData!.laybullPicks!.isNotEmpty
                                      ? ListView.separated(
                                          padding: EdgeInsets.only(bottom: 0.h),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: pp.homeData!.laybullPicks!.length,
                                          separatorBuilder: (context, index) => SizedBox(
                                                width: 10.w,
                                              ),
                                          itemBuilder: (context, index) {
                                            return ItemWithPriceChip(
                                              dateShow: false,
                                              onTap: () async {
                                                if (context.read<AuthProvider>().user != null) {
                                                  await pp.getProductDetail(pp.homeData!.laybullPicks![index].id!, context, false);
                                                } else {
                                                  await pp.getGuestProductDetail(pp.homeData!.laybullPicks![index].id!, context, false);
                                                }
                                              },
                                              fireOnTap: () async {},
                                              key: UniqueKey(),
                                              productsModel: pp.homeData!.laybullPicks![index],
                                            );
                                          })
                                      : Container(),
                                ),
                              ], //
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate('recentlyListed').toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        fontFamily: 'MetropolisExtraBold',
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // utilService.showToast('Under Development');
                                        if (context.read<AuthProvider>().user != null) {
                                          await pp.viewAllProductWithPagination(
                                            pageNumber: 1,
                                            type: 'recently_listed',
                                            context: context,
                                            alreadyOnScreen: false,
                                            navigationTitle: 'Recently Listed',
                                          );
                                        } else {
                                          await pp.viewAllProductWithPaginationGuest(
                                            pageNumber: 1,
                                            type: 'recently_listed',
                                            context: context,
                                            alreadyOnScreen: false,
                                            navigationTitle: 'Recently Listed',
                                          );
                                        }
                                      },
                                      child: Text(
                                        AppLocalizations.of(context).translate('viewAll').toUpperCase(),
                                        style: TextStyle(
                                          letterSpacing: 1.2,
                                          fontSize: 12.sp,
                                          fontFamily: 'MetropolisExtraBold',
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                SizedBox(
                                  // height: 180.h,
                                  child: pp.homeData!.latest != null || pp.homeData!.latest!.isNotEmpty
                                      ? GridView.builder(
                                          // padding: EdgeInsets.symmetric(horizontal: 20.w),
                                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 300,
                                            mainAxisExtent: 230,
                                            childAspectRatio: 1,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 40,
                                          ),
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: pp.homeData!.latest!.length,
                                          itemBuilder: (context, index) {
                                            return ItemWithPriceChip(
                                              isGride: true,
                                              dateShow: false,
                                              onTap: () async {
                                                if (context.read<AuthProvider>().user != null) {
                                                  await pp.getProductDetail(pp.homeData!.latest![index].id!, context, false);
                                                } else {
                                                  await pp.getGuestProductDetail(pp.homeData!.latest![index].id!, context, false);
                                                }
                                              },
                                              fireOnTap: () {},
                                              key: UniqueKey(),
                                              //  asset: 'assets/images/shoe${index + 1}.png',
                                              productsModel: pp.homeData!.latest![index],
                                            );
                                          })
                                      // ListView.separated(
                                      //     padding: EdgeInsets.only(bottom: 10.0.h),
                                      //     shrinkWrap: true,
                                      //     scrollDirection: Axis.horizontal,
                                      //     itemCount: pp.homeData!.latest!.length,
                                      //     separatorBuilder: (context, index) => SizedBox(
                                      //           width: 10.w,
                                      //         ),
                                      //     itemBuilder: (context, index) {
                                      //       return ItemWithPriceChip(
                                      //         dateShow: false,
                                      //         onTap: () async {
                                      //           if (context.read<AuthProvider>().user != null) {
                                      //             await pp.getProductDetail(pp.homeData!.latest![index].id!, context, false);
                                      //           } else {
                                      //             await pp.getGuestProductDetail(pp.homeData!.latest![index].id!, context, false);
                                      //           }
                                      //         },
                                      //         fireOnTap: () {},
                                      //         key: UniqueKey(),
                                      //         //  asset: 'assets/images/shoe${index + 1}.png',
                                      //         productsModel: pp.homeData!.latest![index],
                                      //       );

                                      //       /*     Stack(
                                      //               clipBehavior: Clip.none,
                                      //               children: [
                                      //                 Container(
                                      //                   height: 120,
                                      //                   width: 120,
                                      //                   decoration: BoxDecoration(
                                      //                       borderRadius:
                                      //                           BorderRadius.all(
                                      //                               Radius.circular(
                                      //                                   20))),
                                      //                   child: GestureDetector(
                                      //                     onTap: () async {
                                      //                       // pr = MyProgressDialog(context);
                                      //                       // pr!.show();
                                      //                       if (context
                                      //                               .read<
                                      //                                   AuthProvider>()
                                      //                               .user !=
                                      //                           null) {
                                      //                         await pp.getProductDetail(
                                      //                             pp
                                      //                                 .homeData!
                                      //                                 .latest![index]
                                      //                                 .id!,
                                      //                             context,
                                      //                             false);
                                      //                       } else {
                                      //                         await pp
                                      //                             .getGuestProductDetail(
                                      //                                 pp
                                      //                                     .homeData!
                                      //                                     .latest![
                                      //                                         index]
                                      //                                     .id!,
                                      //                                 context,
                                      //                                 false);
                                      //                       }
                                      //                     },
                                      //                     child: CacheImage(
                                      //                       radius: 6.r,
                                      //                       imageUrl: pp
                                      //                           .homeData!
                                      //                           .latest![index]
                                      //                           .feature_image,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //                 /*   Positioned(
                                      //         top: 55.h,
                                      //         left: 85.w,
                                      //         // alignment: Alignment.bottomRight,
                                      //         child: GestureDetector(
                                      //           child: Container(
                                      //             height: 35.h,
                                      //             width: 35.w,
                                      //             decoration: BoxDecoration(
                                      //                 color: Colors.white,
                                      //                 shape: BoxShape.circle,
                                      //                 // ignore: prefer_const_literals_to_create_immutables
                                      //                 boxShadow: [
                                      //                   BoxShadow(
                                      //                     color: Colors.black38,
                                      //                     blurRadius: 3,
                                      //                   ),
                                      //                 ]),
                                      //             margin: EdgeInsets.only(right: 3.w),
                                      //             child: Center(
                                      //               child: pp.homeData!.latest![index]
                                      //                           .isFav ==
                                      //                       true
                                      //                   ? Image.asset(
                                      //                       'assets/finalFire.png',
                                      //                       height: 25.h,
                                      //                       width: 25.w,
                                      //                     )
                                      //                   : Image.asset(
                                      //                       'assets/Vector1.png'),
                                      //             ),
                                      //           ),
                                      //           onTap: () async {
                                      //             if (pp.homeData!.latest![index]
                                      //                     .isFav ==
                                      //                 false) {
                                      //               pp.addingIntoFavLocall(
                                      //                   pp.homeData!.latest![index]);
                                      //               setState(() {});
                                      //               pp.homeData!.latest![index].isFav =
                                      //                   true;
                                      //               await pp.addToFavoriteProducts(pp
                                      //                   .homeData!.latest![index].id!);
                                      //               setState(() {});
                                      //             } else {
                                      //               pp.removingFromFavLocall(pp
                                      //                   .homeData!.latest![index].id!);

                                      //               setState(() {});
                                      //               pp.homeData!.latest![index].isFav =
                                      //                   false;
                                      //               await pp.removeFromFavoriteProducts(
                                      //                   pp.homeData!.latest![index]
                                      //                       .id!);
                                      //               setState(() {});
                                      //             }
                                      //           },
                                      //         ),
                                      //       ),

                                      //  */
                                      //               ],
                                      //             );
                                      //      */
                                      //     })

                                      : Container(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Center(
                        child: Text("404 Not Found!"),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
