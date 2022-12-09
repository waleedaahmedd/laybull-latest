// // // ignore_for_file: unused_element, prefer_const_constructors

// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';

// // import 'package:laybull_v3/constants.dart';
// // import 'package:laybull_v3/dummy_data.dart';
// // import 'package:laybull_v3/locale/app_localization.dart';
// // import 'package:laybull_v3/providers/bidding_provider.dart';
// // import 'package:laybull_v3/providers/currency_provider.dart';
// // import 'package:laybull_v3/providers/product_provider.dart';
// // import 'package:provider/provider.dart';
// // import 'package:laybull_v3/extensions.dart';
// // import 'package:provider/src/provider.dart';

// // class OfferScreen extends StatefulWidget {
// //   @override
// //   _OfferScreenState createState() => _OfferScreenState();
// // }

// // class _OfferScreenState extends State<OfferScreen> {
// //   bool sentvisible = true;
// //   bool recevied = false;
// //   Color colors = Colors.black;
// //   Color textSentColor = Colors.white;
// //   Color textReceivedColor = Colors.black;
// //   Color color = Colors.grey[100]!;

// //   @override
// //   void initState() {
// //     WidgetsBinding.instance?.addPostFrameCallback((_) async {
// //       await Future.delayed(Duration.zero);
// //       await context.read<BidProvider>().getRecievedOffers(true);
// //       await context.read<BidProvider>().getSentOffer(true);
// //     });
// //     super.initState();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<BidProvider>(builder: (context, bp, _) {
// //       return SafeArea(
// //         child: Scaffold(
// //           extendBody: true,
// //           resizeToAvoidBottomInset: true,
// //           appBar: AppBar(
// //               elevation: 0,
// //               iconTheme: const IconThemeData(color: Colors.black),
// //               backgroundColor: Colors.white10,
// //               title: Text(
// //                 AppLocalizations.of(context).translate('offer').toUpperCase(),
// //                 style: headingStyle,
// //               )),
// //           body: Container(
// //             padding: EdgeInsets.only(left: 0.w, right: 0.w, top: 20.h),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     InkWell(
// //                       onTap: () {
// //                         setState(() {
// //                           if (sentvisible != true) {
// //                             textReceivedColor = Colors.black;
// //                             textSentColor = Colors.white;
// //                             colors = Colors.black;
// //                             sentvisible = true;
// //                             recevied = false;
// //                             setState(() {
// //                               color = const Color(0xFFE5E5E5);
// //                             });
// //                           }
// //                         });
// //                       },
// //                       child: Container(
// //                           height: 40.h,
// //                           width: (MediaQuery.of(context).size.width / 2.5).w,
// //                           decoration: BoxDecoration(
// //                               color: colors,
// //                               borderRadius: BorderRadius.circular(10.r)),
// //                           child: Center(
// //                               child: Text(
// //                             AppLocalizations.of(context)
// //                                 .translate('sent')
// //                                 .toUpperCase(),
// //                             style: TextStyle(
// //                                 fontSize: 14.sp,
// //                                 color: textSentColor,
// //                                 letterSpacing: 2.w,
// //                                 fontFamily: "MetropolisExtraBold",
// //                                 fontWeight: FontWeight.bold),
// //                           ))),
// //                     ),
// //                     // const Spacer(),
// //                     InkWell(
// //                       onTap: () {
// //                         setState(() {
// //                           if (recevied != true) {
// //                             color = Colors.black;
// //                             textReceivedColor = Colors.white;
// //                             textSentColor = Colors.black;
// //                             colors = const Color(0xFFE5E5E5);
// //                             recevied = true;
// //                             sentvisible = false;
// //                           }
// //                         });
// //                       },
// //                       child: Container(
// //                           height: 40.h,
// //                           width: (MediaQuery.of(context).size.width / 2.5).w,
// //                           decoration: BoxDecoration(
// //                               color: color,
// //                               borderRadius: BorderRadius.circular(10)),
// //                           child: Center(
// //                               child: Text(
// //                             AppLocalizations.of(context)
// //                                 .translate('received')
// //                                 .toUpperCase(),
// //                             style: TextStyle(
// //                               fontSize: 14.sp,
// //                               color: textReceivedColor,
// //                               fontWeight: FontWeight.bold,
// //                               letterSpacing: 2.w,
// //                               fontFamily: "MetropolisExtraBold",
// //                             ),
// //                           ))),
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(
// //                   height: 30.h,
// //                 ),
// //                 Visibility(
// //                   visible: sentvisible,
// //                   child: Column(
// //                     children: [
// //                       Padding(
// //                         padding: EdgeInsets.only(top: 10.h),
// //                         child: bp.sentBids!.isEmpty
// //                             ? Center(
// //                                 child:
// //                                     Text('No Sent Offer Yet.', style: LiteText),
// //                               )
// //                             : RefreshIndicator(
// //                                 onRefresh: () async {
// //                                   await bp.getSentOffer(true);
// //                                 },
// //                                 child: SizedBox(
// //                                   height:
// //                                       MediaQuery.of(context).size.height * 0.63,
// //                                   child: ListView.separated(
// //                                       separatorBuilder: (context, index) =>
// //                                           SizedBox(
// //                                             height: 20.h,
// //                                           ),
// //                                       itemCount: bp.sentBids!.length,
// //                                       shrinkWrap: true,
// //                                       physics:
// //                                           const NeverScrollableScrollPhysics(),
// //                                       itemBuilder:
// //                                           (BuildContext cntxt, int index) {
// //                                         return GestureDetector(
// //                                           onTap: () async {
// //                                             await context
// //                                                 .read<ProductProvider>()
// //                                                 .getProductDetail(
// //                                                   bp.sentBids![index]
// //                                                       .product_id!,
// //                                                   context,
// //                                                   false,
// //                                                 );
// //                                           },
// //                                           child: Container(
// //                                             height: 130.h,
// //                                             padding: EdgeInsets.symmetric(
// //                                                 horizontal: 20.w),
// //                                             decoration: BoxDecoration(
// //                                                 color: const Color(0xffF4F4F4),
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(
// //                                                         10.r)),
// //                                             child: Row(
// //                                               children: [
// //                                                 Container(
// //                                                   width: 120.w,
// //                                                   margin: EdgeInsets.symmetric(
// //                                                     vertical: 10.h,
// //                                                   ),
// //                                                   child: ClipRRect(
// //                                                     borderRadius:
// //                                                         BorderRadius.circular(
// //                                                             10.r),
// //                                                     child: CachedNetworkImage(
// //                                                       imageUrl: bp
// //                                                           .sentBids![index]
// //                                                           .product!
// //                                                           .featured_image!,
// //                                                       progressIndicatorBuilder: (context,
// //                                                               url,
// //                                                               downloadProgress) =>
// //                                                           CircularProgressIndicator(
// //                                                               value:
// //                                                                   downloadProgress
// //                                                                       .progress),
// //                                                       errorWidget: (context,
// //                                                               url, error) =>
// //                                                           Icon(Icons.error),
// //                                                     ),
// //                                                   ),
// //                                                 ),
// //                                                 SizedBox(
// //                                                   width: 30.w,
// //                                                 ),
// //                                                 Column(
// //                                                   mainAxisAlignment:
// //                                                       MainAxisAlignment.start,
// //                                                   crossAxisAlignment:
// //                                                       CrossAxisAlignment.start,
// //                                                   children: [
// //                                                     SizedBox(
// //                                                       height: 10.h,
// //                                                     ),
// //                                                     Container(
// //                                                       constraints:
// //                                                           BoxConstraints(
// //                                                               maxWidth: 180.w),
// //                                                       child: Text(
// //                                                         bp
// //                                                                 .sentBids![
// //                                                                     index]
// //                                                                 .product!
// //                                                                 .name ??
// //                                                             '',
// //                                                         style: TextStyle(
// //                                                           fontWeight:
// //                                                               FontWeight.w700,
// //                                                           fontSize: 16.sp,
// //                                                         ),
// //                                                         overflow: TextOverflow
// //                                                             .ellipsis,
// //                                                       ),
// //                                                     ),
// //                                                     SizedBox(
// //                                                       height: 8.h,
// //                                                     ),
// //                                                     Text(
// //                                                       '${bp.sentBids![index].product!.condition} | ${bp.sentBids![index].product!.size}',
// //                                                       style: TextStyle(
// //                                                         color: Colors.grey,
// //                                                       ),
// //                                                     ),
// //                                                     SizedBox(
// //                                                       height: 8.h,
// //                                                     ),
// //                                                     Text(
// //                                                       "${bp.sentBids![index].price!.convertToLocal(cntxt).round()} ${cntxt.read<CurrencyProvider>().selectedCurrency}"
// //                                                           .toUpperCase(),
// //                                                       style: TextStyle(
// //                                                         fontWeight:
// //                                                             FontWeight.w600,
// //                                                         fontSize: 14.sp,
// //                                                       ),
// //                                                     ),
// //                                                     SizedBox(
// //                                                       height: 8.h,
// //                                                     ),
// //                                                     InkWell(
// //                                                       onTap: () {},
// //                                                       child: Container(
// //                                                         height: 30.h,
// //                                                         width: 100.w,
// //                                                         decoration:
// //                                                             BoxDecoration(
// //                                                                 // color: Colors.green,
// //                                                                 color: bp.sentBids![index].status ==
// //                                                                             null ||
// //                                                                         bp.sentBids![index].status ==
// //                                                                             'pending'
// //                                                                     ? Colors
// //                                                                         .orange
// //                                                                     : bp.sentBids![index].status!.toUpperCase() ==
// //                                                                             "Accept"
// //                                                                                 .toUpperCase()
// //                                                                         ? Colors
// //                                                                             .green
// //                                                                         : Colors
// //                                                                             .red,
// //                                                                 borderRadius:
// //                                                                     BorderRadius
// //                                                                         .circular(
// //                                                                   5.r,
// //                                                                 )),
// //                                                         child: Center(
// //                                                             child: Text(
// //                                                           bp.sentBids![index]
// //                                                                           .status ==
// //                                                                       null ||
// //                                                                   bp
// //                                                                           .sentBids![
// //                                                                               index]
// //                                                                           .status ==
// //                                                                       'pending'
// //                                                               ? AppLocalizations
// //                                                                       .of(cntxt)
// //                                                                   .translate(
// //                                                                       'Pending')
// //                                                               : bp.sentBids![index].status!
// //                                                                           .toUpperCase() ==
// //                                                                       "Accept"
// //                                                                           .toUpperCase()
// //                                                                   ? AppLocalizations.of(
// //                                                                           cntxt)
// //                                                                       .translate(
// //                                                                           'Accepted')
// //                                                                   : AppLocalizations.of(
// //                                                                           cntxt)
// //                                                                       .translate(
// //                                                                           'Rejected'),
// //                                                           style: TextStyle(
// //                                                               color:
// //                                                                   Colors.white),
// //                                                         )),
// //                                                       ),
// //                                                     )
// //                                                   ],
// //                                                 )
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         );
// //                                       }),
// //                                 ),
// //                               ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Visibility(
// //                   visible: recevied,
// //                   child: Column(
// //                     children: [
// //                       Padding(
// //                         padding: EdgeInsets.only(top: 10.h),
// //                         child: bp.recievedBids!.isEmpty
// //                             ? Center(
// //                                 child: Text(
// //                                   'No Offer Recieved Yet.',
// //                                   style: LiteText,
// //                                 ),
// //                               )
// //                             : RefreshIndicator(
// //                                 onRefresh: () async {
// //                                   await bp.getRecievedOffers(true);
// //                                 },
// //                                 child: SizedBox(
// //                                   height:
// //                                       MediaQuery.of(context).size.height * 0.63,
// //                                   child: ListView.separated(
// //                                       separatorBuilder: (context, index) =>
// //                                           SizedBox(
// //                                             height: 20.h,
// //                                           ),
// //                                       itemCount: bp.recievedBids!.length,
// //                                       shrinkWrap: true,
// //                                       itemBuilder:
// //                                           (BuildContext ctxt, int index) {
// //                                         return GestureDetector(
// //                                           onTap: () async {
// //                                             await context
// //                                                 .read<ProductProvider>()
// //                                                 .getProductDetail(
// //                                                   bp.recievedBids![index]
// //                                                       .product_id!,
// //                                                   context,
// //                                                   false,
// //                                                 );
// //                                           },
// //                                           child: Container(
// //                                             padding: EdgeInsets.symmetric(
// //                                                 horizontal: 20.w,
// //                                                 vertical: 20.h),
// //                                             // height: 170,
// //                                             decoration: BoxDecoration(
// //                                                 color: const Color(0xffF4F4F4),
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(
// //                                                         10.r)),
// //                                             child: Column(
// //                                               children: [
// //                                                 Row(
// //                                                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                                                   children: [
// //                                                     Container(
// //                                                       width: 120.w,
// //                                                       height: 80.h,
// //                                                       margin:
// //                                                           EdgeInsets.symmetric(
// //                                                               vertical: 5.h),
// //                                                       child: ClipRRect(
// //                                                         child: SizedBox(
// //                                                             width: 120.w,
// //                                                             height: 80.h,
// //                                                             child: Center(
// //                                                               child:
// //                                                                   CachedNetworkImage(
// //                                                                 imageUrl: bp
// //                                                                     .recievedBids![
// //                                                                         index]
// //                                                                     .product!
// //                                                                     .featured_image!,
// //                                                                 progressIndicatorBuilder: (context,
// //                                                                         url,
// //                                                                         downloadProgress) =>
// //                                                                     CircularProgressIndicator(
// //                                                                         value: downloadProgress
// //                                                                             .progress),
// //                                                                 errorWidget: (context,
// //                                                                         url,
// //                                                                         error) =>
// //                                                                     Icon(Icons
// //                                                                         .error),
// //                                                               ),
// //                                                             )),
// //                                                         borderRadius:
// //                                                             BorderRadius
// //                                                                 .circular(10.r),
// //                                                       ),
// //                                                     ),
// //                                                     SizedBox(
// //                                                       width: 30.w,
// //                                                     ),
// //                                                     Column(
// //                                                       crossAxisAlignment:
// //                                                           CrossAxisAlignment
// //                                                               .start,
// //                                                       children: [
// //                                                         Container(
// //                                                           constraints:
// //                                                               BoxConstraints(
// //                                                                   maxWidth:
// //                                                                       180.w),
// //                                                           child: Text(
// //                                                             bp
// //                                                                     .recievedBids![
// //                                                                         index]
// //                                                                     .product!
// //                                                                     .name ??
// //                                                                 '',
// //                                                             style: TextStyle(
// //                                                               fontWeight:
// //                                                                   FontWeight
// //                                                                       .w700,
// //                                                               fontSize: 16.sp,
// //                                                             ),
// //                                                             overflow:
// //                                                                 TextOverflow
// //                                                                     .ellipsis,
// //                                                           ),
// //                                                         ),
// //                                                         SizedBox(
// //                                                           height: 8.h,
// //                                                         ),
// //                                                         Text(
// //                                                           "${bp.recievedBids![index].product!.condition} | ${bp.recievedBids![index].product!.size}",
// //                                                           style: TextStyle(
// //                                                               color: Color(
// //                                                                   0xffB0B0B0)),
// //                                                         ),
// //                                                         SizedBox(
// //                                                           height: 8.h,
// //                                                         ),
// //                                                         Text(
// //                                                           "${bp.recievedBids![index].price!.convertToLocal(ctxt).round()} ${ctxt.read<CurrencyProvider>().selectedCurrency}"
// //                                                               .toUpperCase(),
// //                                                           style: TextStyle(
// //                                                             fontWeight:
// //                                                                 FontWeight.w600,
// //                                                             fontSize: 14.sp,
// //                                                           ),
// //                                                         ),
// //                                                       ],
// //                                                     )
// //                                                   ],
// //                                                 ),
// //                                                 SizedBox(
// //                                                   height: 10.h,
// //                                                 ),
// //                                                 bp.recievedBids![index]
// //                                                                 .status ==
// //                                                             null ||
// //                                                         bp.recievedBids![index]
// //                                                                 .status ==
// //                                                             'pending'
// //                                                     ? Row(
// //                                                         mainAxisAlignment:
// //                                                             MainAxisAlignment
// //                                                                 .spaceEvenly,
// //                                                         children: [
// //                                                           bp.recievedBids![index]
// //                                                                       .counter ==
// //                                                                   null
// //                                                               ? Expanded(
// //                                                                   child:
// //                                                                       GestureDetector(
// //                                                                     child:
// //                                                                         Container(
// //                                                                       height:
// //                                                                           30,
// //                                                                       decoration: BoxDecoration(
// //                                                                           color: Colors
// //                                                                               .black,
// //                                                                           borderRadius:
// //                                                                               BorderRadius.circular(3)),
// //                                                                       child: Center(
// //                                                                           child: Text(
// //                                                                         AppLocalizations.of(ctxt)
// //                                                                             .translate('cOUNTEROFFER'),
// //                                                                         style: const TextStyle(
// //                                                                             color:
// //                                                                                 Colors.white,
// //                                                                             fontSize: 9),
// //                                                                       )),
// //                                                                     ),
// //                                                                     onTap: () {
// //                                                                       _showMyDialog(
// //                                                                           index,
// //                                                                           ctxt
// //                                                                               .read<CurrencyProvider>()
// //                                                                               .selectedCurrency
// //                                                                               .toUpperCase(),
// //                                                                           bp.recievedBids![index].bidId!);
// //                                                                     },
// //                                                                   ),
// //                                                                 )
// //                                                               : const SizedBox(),
// //                                                           SizedBox(
// //                                                             width: bp
// //                                                                         .recievedBids![
// //                                                                             index]
// //                                                                         .counter ==
// //                                                                     null
// //                                                                 ? 3.w
// //                                                                 : 0.w,
// //                                                           ),
// //                                                           Expanded(
// //                                                             child:
// //                                                                 GestureDetector(
// //                                                                     child:
// //                                                                         Container(
// //                                                                       height:
// //                                                                           30.h,
// //                                                                       decoration:
// //                                                                           BoxDecoration(
// //                                                                         border: Border.all(
// //                                                                             color:
// //                                                                                 Colors.green),
// //                                                                         borderRadius:
// //                                                                             BorderRadius.circular(
// //                                                                           3.r,
// //                                                                         ),
// //                                                                       ),
// //                                                                       child: Center(
// //                                                                           child: Text(
// //                                                                         AppLocalizations.of(ctxt)
// //                                                                             .translate(
// //                                                                           'ACCEPT',
// //                                                                         ),
// //                                                                         style: const TextStyle(
// //                                                                             color:
// //                                                                                 Colors.green,
// //                                                                             fontSize: 10),
// //                                                                       )),
// //                                                                     ),
// //                                                                     onTap:
// //                                                                         () async {}),
// //                                                           ),
// //                                                           const SizedBox(
// //                                                             width: 3,
// //                                                           ),
// //                                                           Expanded(
// //                                                             child:
// //                                                                 GestureDetector(
// //                                                               onTap:
// //                                                                   () async {},
// //                                                               child: Container(
// //                                                                 height: 30,
// //                                                                 width: 100,
// //                                                                 decoration: BoxDecoration(
// //                                                                     border: Border.all(
// //                                                                         color: Colors
// //                                                                             .red),
// //                                                                     borderRadius:
// //                                                                         BorderRadius.circular(
// //                                                                             3)),
// //                                                                 child: Center(
// //                                                                     child: Text(
// //                                                                   AppLocalizations.of(
// //                                                                           context)
// //                                                                       .translate(
// //                                                                           'REJECT'),
// //                                                                   style: const TextStyle(
// //                                                                       color: Colors
// //                                                                           .red,
// //                                                                       fontSize:
// //                                                                           10),
// //                                                                 )),
// //                                                               ),
// //                                                             ),
// //                                                           ),
// //                                                         ],
// //                                                       )
// //                                                     : Row(
// //                                                         children: [
// //                                                           Container(
// //                                                             padding: EdgeInsets
// //                                                                 .symmetric(
// //                                                               vertical: 5.h,
// //                                                               horizontal: 10.w,
// //                                                             ),
// //                                                             decoration: BoxDecoration(
// //                                                                 borderRadius:
// //                                                                     BorderRadius
// //                                                                         .circular(5
// //                                                                             .r),
// //                                                                 border: Border.all(
// //                                                                     color: Colors
// //                                                                         .green,
// //                                                                     width:
// //                                                                         1.w)),
// //                                                             child: Center(
// //                                                               child: Text(
// //                                                                 AppLocalizations.of(
// //                                                                         context)
// //                                                                     .translate(
// //                                                                   'Rejected',
// //                                                                 ),
// //                                                               ),
// //                                                             ),
// //                                                             // width: MediaQuery.of(context).size.width*.2,
// //                                                           ),
// //                                                         ],
// //                                                         mainAxisAlignment:
// //                                                             MainAxisAlignment
// //                                                                 .center,
// //                                                       ),
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         );
// //                                       }),
// //                                 ),
// //                               ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       );
// //     });
// //   }

// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _bidController = TextEditingController();
// //   Future<void> _showMyDialog(
// //       int index, String currentCurrency, int bidId) async {
// //     return showDialog<void>(
// //       context: context,
// //       barrierDismissible: false, // user must tap button!
// //       builder: (BuildContext context) {
// //         return Form(
// //           key: _formKey,
// //           child: AlertDialog(
// //             title: Text(AppLocalizations.of(context).translate('countOffer')),
// //             content: SingleChildScrollView(
// //               child: ListBody(
// //                 children: <Widget>[
// //                   const Text('Enter Price'),
// //                   SizedBox(height: 20.h),
// //                   TextFormField(
// //                       keyboardType: TextInputType.number,
// //                       controller: _bidController,
// //                       inputFormatters: [
// //                         FilteringTextInputFormatter.digitsOnly,
// //                       ],
// //                       validator: (value) {
// //                         if (value!.isEmpty) {
// //                           return 'Please enter Counter Offer amount';
// //                         }
// //                         return null;
// //                       },
// //                       style: TextStyle(
// //                           fontSize: 15.sp,
// //                           fontFamily: 'Metropolis',
// //                           letterSpacing: 2.2.w),
// //                       decoration: InputDecoration(
// //                           border: InputBorder.none,
// //                           suffix: Text(
// //                             currentCurrency,
// //                             style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 letterSpacing: 2.w,
// //                                 fontFamily: "MetropolisExtraBold"),
// //                           ),
// //                           fillColor: const Color(0xfff3f3f4),
// //                           filled: true)),
// //                 ],
// //               ),
// //             ),
// //             actions: <Widget>[
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   TextButton(
// //                     child:
// //                         Text(AppLocalizations.of(context).translate('cancel')),
// //                     onPressed: () {
// //                       Navigator.of(context).pop();
// //                     },
// //                   ),
// //                   TextButton(
// //                     child: Text(AppLocalizations.of(context).translate('send')),
// //                     onPressed: () async {
// //                       if (_formKey.currentState!.validate()) {
// //                         FocusScope.of(context).unfocus();
// //                         context.read<BidProvider>().makeCounterOffer(
// //                             _bidController.text.trim(), bidId, context);
// //                         Navigator.pop(context);
// //                       }
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }



// CarouselSlider(
//         carouselController: _controller,
//         options: CarouselOptions(
//           aspectRatio: 5 / 9,
//           enableInfiniteScroll: false,
//           viewportFraction: 1,
//           enlargeCenterPage: false,
//           onPageChanged: (index, reason) {
//             setState(
//               () {
//                 if (_current == 0 && index == 1) {
//                   listIndex.add(index);
//                 } else if (_current == 1 && index == 0) {
//                   listIndex.remove(_current);
//                 } else if (_current == 1 && index == 2) {
//                   listIndex.add(index);
//                 } else if (_current == 2 && index == 1) {
//                   listIndex.remove(_current);
//                 } else if (_current == 2 && index == 3) {
//                   listIndex.add(index);
//                 } else if (_current == 3 && index == 2) {
//                   listIndex.remove(_current);
//                 } else if (_current == 3 && index == 4) {
//                   listIndex.add(index);
//                 } else if (_current == 4 && index == 3) {
//                   listIndex.remove(_current);
//                 } else if (_current == 4 && index == 5) {
//                   listIndex.add(index);
//                 } else if (_current == 5 && index == 4) {
//                   listIndex.remove(_current);
//                 }
//                 _current = index;
//               },
//             );
//           },
//           autoPlay: true,
//         ),
//         items: imgList
//             .map(
//               (item) => Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Column(
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: MediaQuery.of(context).size.height * 0.44,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             opacity: 0.8,
//                             fit: BoxFit.cover,
//                             image: NetworkImage(item),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.25,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                 left: 30,
//                                 right: 30,
//                                 top: 20,
//                                 // bottom: 10,
//                               ),
//                               child: Text(
//                                 item == "Fear of God Essentials"
//                                     ? "Fear of God Essentials"
//                                     : item == "Fear of God Essentials"
//                                         ? "Fear of God Essentials"
//                                         : item == "Fear of God Essentials"
//                                             ? "Fear of God Essentials"
//                                             : "Fear of God Essentials",
//                                 style: const TextStyle(
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 30, right: 30),
//                               child: Text(
//                                 item == "The Spring 2022 Collection"
//                                     ? "The Spring 2022 Collection"
//                                     : item == "The Spring 2022 Collection"
//                                         ? "The Spring 2022 Collection"
//                                         : item == "The Spring 2022 Collection"
//                                             ? "The Spring 2022 Collection"
//                                             : "The Spring 2022 Collection",
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   height: 1.4,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 30, right: 30),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.only(
//                                         top: 10,
//                                         bottom: 10,
//                                         left: 30,
//                                         right: 30),
//                                     decoration: const BoxDecoration(
//                                       color: Colors.black,
//                                     ),
//                                     child: const Text(
//                                       "Buyer & Sell Now",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children:
//                                         textList.asMap().entries.map((entry) {
//                                       return GestureDetector(
//                                         onTap: () => _controller
//                                             .animateToPage(entry.key),
//                                         child: Container(
//                                           width: 10,
//                                           height: 10,
//                                           margin: const EdgeInsets.symmetric(
//                                             vertical: 8.0,
//                                             horizontal: 4.0,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 width: 1,
//                                                 color: Theme.of(context)
//                                                             .brightness ==
//                                                         Brightness.dark
//                                                     ? Colors.black
//                                                     : Colors.grey.shade300),
//                                             shape: BoxShape.circle,
//                                             color:
//                                                 (Theme.of(context).brightness ==
//                                                             Brightness.dark
//                                                         ? Colors.black
//                                                         : Colors.grey.shade300)
//                                                     .withOpacity(
//                                               listIndex.contains(entry.key)
//                                                   ? 0.7
//                                                   : listIndex
//                                                           .contains(entry.key)
//                                                       ? 0.7
//                                                       : listIndex.contains(
//                                                               entry.key)
//                                                           ? 0.7
//                                                           : 0.0,
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Container(
//                       //   height: MediaQuery.of(context).size.height * 0.6,
//                       //   decoration: BoxDecoration(
//                       //     image: DecorationImage(
//                       //       fit: BoxFit.cover,
//                       //       image: NetworkImage(
//                       //         item ==
//                       //                 "https://cdn.shopify.com/s/files/1/0202/5884/8822/products/K22ST722-RWH_1_1024x.jpg?v=1652707450,"
//                       //             ? "https://cdn.shopify.com/s/files/1/0202/5884/8822/products/K22ST722-RWH_1_1024x.jpg?v=1652707450,"
//                       //             : item ==
//                       //                     "https://cdn.shopify.com/s/files/1/0202/5884/8822/products/K22ST722-RWH_1_1024x.jpg?v=1652707450,"
//                       //                 ? "https://cdn.shopify.com/s/files/1/0202/5884/8822/products/K22ST722-RWH_1_1024x.jpg?v=1652707450,"
//                       //                 : item ==
//                       //                         'https://cdn.shopify.com/s/files/1/0202/5884/8822/products/K22ST722-RWH_1_1024x.jpg?v=1652707450'
//                       //                     ? "https://cdn.shopify.com/s/files/1/0202/5884/8822/products/K22ST722-RWH_1_1024x.jpg?v=1652707450"
//                       //                     : "https://cdn.shopify.com/s/files/1/0202/5884/8822/products/K22ST722-RWH_1_1024x.jpg?v=1652707450",
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//             .toList(),
//       ),
