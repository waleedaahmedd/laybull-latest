// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_element, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/payment_provider.dart';
import 'package:laybull_v3/screens/confirm_address_screen.dart';
import 'package:laybull_v3/screens/login_screen.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/dummy_data.dart';
import 'package:laybull_v3/extensions.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/providers/bidding_provider.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';

class OfferScreen extends StatefulWidget {
  final bool? comingfromDashBoard;
  const OfferScreen({
    Key? key,
    this.comingfromDashBoard,
  }) : super(key: key);
  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  bool sentvisible = true;
  bool recevied = false;
  Color colors = Colors.black;
  Color textSentColor = Colors.white;
  Color textReceivedColor = Colors.black;
  Color color = Colors.grey[100]!;
  var utilService = locator<UtilService>();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Future.delayed(Duration.zero);
      if (context.read<AuthProvider>().user != null) {
        await context.read<BidProvider>().getRecievedOffers(true);
        await context.read<BidProvider>().getSentOffer(true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Consumer<BidProvider>(builder: (context, bp, _) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: widget.comingfromDashBoard == false
              ? AppBar(
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.black),
                  backgroundColor: Colors.white10,
                  title: Text(
                    AppLocalizations.of(context).translate('offer').toUpperCase(),
                    style: headingStyle,
                  ))
              : null,
          body: context.read<AuthProvider>().user != null
              ? RefreshIndicator(
                  onRefresh: () async {
                    if (sentvisible == true) {
                      await bp.getSentOffer(true);
                    } else {
                      await bp.getRecievedOffers(true);
                    }
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.only(left: 0.w, right: 0.w, top: 20.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (sentvisible != true) {
                                      textReceivedColor = Colors.black;
                                      textSentColor = Colors.white;
                                      colors = Colors.black;
                                      sentvisible = true;
                                      recevied = false;
                                      setState(() {
                                        color = const Color(0xFFE5E5E5);
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                    height: 40.h,
                                    width: (MediaQuery.of(context).size.width / 2.5).w,
                                    decoration: BoxDecoration(color: colors, borderRadius: BorderRadius.circular(10.r)),
                                    child: Center(
                                        child: Text(
                                      AppLocalizations.of(context).translate('sent').toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: textSentColor,
                                          letterSpacing: 2.w,
                                          fontFamily: "MetropolisExtraBold",
                                          fontWeight: FontWeight.bold),
                                    ))),
                              ),
                              // const Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (recevied != true) {
                                      color = Colors.black;
                                      textReceivedColor = Colors.white;
                                      textSentColor = Colors.black;
                                      colors = const Color(0xFFE5E5E5);
                                      recevied = true;
                                      sentvisible = false;
                                    }
                                  });
                                },
                                child: Container(
                                    height: 40.h,
                                    width: (MediaQuery.of(context).size.width / 2.5).w,
                                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                      AppLocalizations.of(context).translate('received').toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: textReceivedColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.w,
                                        fontFamily: "MetropolisExtraBold",
                                      ),
                                    ))),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Visibility(
                            visible: sentvisible,
                            child: bp.isFetchingBids == true
                                ? Center(
                                    child: Image.asset(
                                      "assets/Larg-Size.gif",
                                      height: 125.0,
                                      width: 125.0,
                                    ),
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        // height: MediaQuery.of(context).size.height/1.4,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                              top: 10.h,
                                            ),
                                            child: bp.sentBids!.isEmpty
                                                ? Center(
                                                    child: Text('No Sent Offer Yet.', style: LiteText),
                                                  )
                                                : ListView.separated(
                                                    separatorBuilder: (context, index) => SizedBox(
                                                          height: 20.h,
                                                        ),
                                                    itemCount: bp.sentBids!.length,
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemBuilder: (BuildContext cntxt, int index) {
                                                      return Dismissible(
                                                        key: UniqueKey(),
                                                        background: Container(
                                                          alignment: AlignmentDirectional.centerEnd,
                                                          color: Colors.red,
                                                          child: Padding(
                                                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(
                                                                  Icons.delete,
                                                                  color: Colors.white,
                                                                ),
                                                                SizedBox(height: 10.h),
                                                                Text(
                                                                  AppLocalizations.of(cntxt).translate('delete'),
                                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        direction:
                                                            bp.sentBids![index].status == 'pending' ? DismissDirection.horizontal : DismissDirection.none,
                                                        confirmDismiss: (DismissDirection direction) async {
                                                          return bp.sentBids![index].status == 'pending'
                                                              ? showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      title: Text(AppLocalizations.of(cntxt).translate('confirm')),
                                                                      content: Text(AppLocalizations.of(cntxt).translate('deleteConfirm')),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                            onPressed: () async {
                                                                              Navigator.of(context).pop(true);
                                                                              await bp.deleteSentOffer(
                                                                                bp.sentBids![index].bidId!,
                                                                              );
                                                                              setState(() {});
                                                                            },
                                                                            child: Text(AppLocalizations.of(cntxt).translate('delete').toUpperCase())),
                                                                        TextButton(
                                                                          onPressed: () => Navigator.of(context).pop(false),
                                                                          child: Text(AppLocalizations.of(cntxt).translate('cancel').toUpperCase()),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                )
                                                              : null;
                                                        },
                                                        // onDismissed: (DismissDirection
                                                        //     direction) async {

                                                        // },
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await context.read<ProductProvider>().getProductDetail(
                                                                  bp.sentBids![index].product_id!,
                                                                  context,
                                                                  false,
                                                                );
                                                          },
                                                          child: Container(
                                                            height: 130.h,
                                                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                            decoration:
                                                                BoxDecoration(color: const Color(0xffF4F4F4), borderRadius: BorderRadius.circular(10.r)),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 120.w,
                                                                  margin: EdgeInsets.symmetric(
                                                                    vertical: 10.h,
                                                                  ),
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(10.r),
                                                                    child: CachedNetworkImage(
                                                                      imageUrl: bp.sentBids![index].product!.featured_image!,
                                                                      fit: BoxFit.cover,
                                                                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                                          child:
                                                                              CircularProgressIndicator(color: Colors.grey, value: downloadProgress.progress)),
                                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 30.w,
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    SizedBox(
                                                                      height: 10.h,
                                                                    ),
                                                                    Container(
                                                                      constraints: BoxConstraints(maxWidth: 180.w),
                                                                      child: Text(
                                                                        bp.sentBids![index].product!.name ?? '',
                                                                        style: TextStyle(
                                                                          fontWeight: FontWeight.w700,
                                                                          fontSize: 16.sp,
                                                                        ),
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8.h,
                                                                    ),
                                                                    Text(
                                                                      '${bp.sentBids![index].product!.condition} | ${bp.sentBids![index].product!.size}',
                                                                      style: TextStyle(
                                                                        color: Colors.grey,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8.h,
                                                                    ),
                                                                    Text(
                                                                      "${bp.sentBids![index].price!.convertToLocal(cntxt).round()} ${cntxt.read<CurrencyProvider>().selectedCurrency}"
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8.h,
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        if (bp.sentBids![index].status != null) {
                                                                          if (bp.sentBids![index].status!.toUpperCase() == 'Accept'.toUpperCase()) {
                                                                            // context.read<PaymentProvider>().buyNowPayment(
                                                                            //       bp.sentBids![index].product_id!,
                                                                            //       bp.sentBids![index].price!,
                                                                            //       context,
                                                                            //     );
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => ConfirmAddress(
                                                                                  product: null,
                                                                                  bidProduct: bp.sentBids![index].product!,
                                                                                  bidProductId: bp.sentBids![index].product_id!,
                                                                                  bidProductPrice: bp.sentBids![index].price!,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                        height: 30.h,
                                                                        width: 100.w,
                                                                        decoration: BoxDecoration(
                                                                            // color: Colors.green,
                                                                            color: bp.sentBids![index].status == null || bp.sentBids![index].status == 'pending'
                                                                                ? Colors.orange
                                                                                : bp.sentBids![index].status!.toUpperCase() == "Accept".toUpperCase()
                                                                                    ? Colors.green
                                                                                    : Colors.red,
                                                                            borderRadius: BorderRadius.circular(
                                                                              5.r,
                                                                            )),
                                                                        child: Center(
                                                                            child: Text(
                                                                          bp.sentBids![index].status == null || bp.sentBids![index].status == 'pending'
                                                                              ? AppLocalizations.of(cntxt).translate('Pending')
                                                                              : bp.sentBids![index].status!.toUpperCase() == "Accept".toUpperCase()
                                                                                  ? AppLocalizations.of(cntxt).translate('Accepted')
                                                                                  : AppLocalizations.of(cntxt).translate('Rejected'),
                                                                          style: TextStyle(color: Colors.white),
                                                                        )),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    })),
                                      ),
                                      SizedBox(
                                        height: 50.h,
                                      ),
                                    ],
                                  ),
                          ),
                          Visibility(
                            visible: recevied,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: bp.recievedBids!.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No Offer Recieved Yet.',
                                            style: LiteText,
                                          ),
                                        )
                                      : ListView.separated(
                                          separatorBuilder: (context, index) => SizedBox(
                                                height: 20.h,
                                              ),
                                          itemCount: bp.recievedBids!.length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext ctxt, int index) {
                                            return bp.recievedBids![index].status == null || bp.recievedBids![index].status == 'pending'
                                                ? Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                                                    // height: 170,
                                                    decoration: BoxDecoration(color: const Color(0xffF4F4F4), borderRadius: BorderRadius.circular(10.r)),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Container(
                                                              width: 120.w,
                                                              height: 80.h,
                                                              margin: EdgeInsets.symmetric(vertical: 5.h),
                                                              child: ClipRRect(
                                                                child: SizedBox(
                                                                    width: 120.w,
                                                                    height: 80.h,
                                                                    child: Center(
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: bp.recievedBids![index].product!.featured_image!,
                                                                        fit: BoxFit.cover,
                                                                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                                            child: CircularProgressIndicator(
                                                                                color: Colors.grey, value: downloadProgress.progress)),
                                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                                      ),
                                                                    )),
                                                                borderRadius: BorderRadius.circular(10.r),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 30.w,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  constraints: BoxConstraints(maxWidth: 180.w),
                                                                  child: Text(
                                                                    bp.recievedBids![index].product!.name ?? '',
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 16.sp,
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8.h,
                                                                ),
                                                                Text(
                                                                  "${bp.recievedBids![index].product!.condition} | ${bp.recievedBids![index].product!.size}",
                                                                  style: TextStyle(color: Color(0xffB0B0B0)),
                                                                ),
                                                                SizedBox(
                                                                  height: 8.h,
                                                                ),
                                                                // Text(
                                                                //   '${bp.recievedBids![index].counter!}',
                                                                //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: Colors.red),
                                                                // )
                                                                Text(
                                                                  bp.recievedBids![index].counter != null
                                                                      ? "${double.parse(bp.recievedBids![index].counter!).convertToLocal(ctxt).round()} ${ctxt.read<CurrencyProvider>().selectedCurrency}"
                                                                      : "${bp.recievedBids![index].price!.convertToLocal(ctxt).round()} ${ctxt.read<CurrencyProvider>().selectedCurrency}"
                                                                          .toUpperCase(),
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14.sp,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        if (bp.recievedBids![index].status == null || bp.recievedBids![index].status == 'pending')
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              bp.recievedBids![index].counter == null || bp.recievedBids![index].counter == ''
                                                                  ? Expanded(
                                                                      child: GestureDetector(
                                                                        child: Container(
                                                                          height: 30.h,
                                                                          decoration:
                                                                              BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(3.r)),
                                                                          child: Center(
                                                                              child: Text(
                                                                            AppLocalizations.of(ctxt).translate('cOUNTEROFFER'),
                                                                            style: TextStyle(color: Colors.white, fontSize: 9.sp),
                                                                          )),
                                                                        ),
                                                                        onTap: () {
                                                                          _showMyDialog(index, ctxt.read<CurrencyProvider>().selectedCurrency.toUpperCase(),
                                                                              bp.recievedBids![index].bidId!);
                                                                        },
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                                              SizedBox(
                                                                width: bp.recievedBids![index].counter == null ? 3.w : 0.w,
                                                              ),
                                                              Expanded(
                                                                child: GestureDetector(
                                                                    child: Container(
                                                                      height: 30.h,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.green,
                                                                        border: Border.all(color: Colors.green),
                                                                        borderRadius: BorderRadius.circular(
                                                                          3.r,
                                                                        ),
                                                                      ),
                                                                      child: Center(
                                                                          child: Text(
                                                                        AppLocalizations.of(ctxt).translate(
                                                                          'ACCEPT',
                                                                        ),
                                                                        style: const TextStyle(color: Colors.white, fontSize: 10),
                                                                      )),
                                                                    ),
                                                                    onTap: () async {
                                                                      await bp.acceptOffer(
                                                                        bp.recievedBids![index].bidId!,
                                                                      );
                                                                    }),
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              Expanded(
                                                                child: GestureDetector(
                                                                  onTap: () async {
                                                                    await bp.rejectOffer(
                                                                      bp.recievedBids![index].bidId!,
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    height: 30,
                                                                    width: 100,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.red,
                                                                        border: Border.all(color: Colors.red),
                                                                        borderRadius: BorderRadius.circular(3)),
                                                                    child: Center(
                                                                        child: Text(
                                                                      AppLocalizations.of(context).translate('REJECT'),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 10),
                                                                    )),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        // : Row(
                                                        //     children: [
                                                        //       Container(
                                                        //         padding: EdgeInsets
                                                        //             .symmetric(
                                                        //           vertical: 5.h,
                                                        //           horizontal:
                                                        //               10.w,
                                                        //         ),
                                                        //         decoration: BoxDecoration(
                                                        //             borderRadius:
                                                        //                 BorderRadius
                                                        //                     .circular(5
                                                        //                         .r),
                                                        //             border: Border.all(
                                                        //                 color: Colors
                                                        //                     .green,
                                                        //                 width:
                                                        //                     1.w)),
                                                        //         child: Center(
                                                        //           child: Text(
                                                        //             AppLocalizations.of(
                                                        //                     context)
                                                        //                 .translate(
                                                        //               'Rejected',
                                                        //             ),
                                                        //           ),
                                                        //         ),
                                                        //         // width: MediaQuery.of(context).size.width*.2,
                                                        //       ),
                                                        //     ],
                                                        //     mainAxisAlignment:
                                                        //         MainAxisAlignment
                                                        //             .center,
                                                        //   ),
                                                      ],
                                                    ),
                                                  )
                                                : Container();
                                          }),
                                ),
                                SizedBox(
                                  height: 50.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              // : utilService.showDialogue('Please Login', ctx),
              : Container()
          // : Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         const Text(
          //           "Please Login",
          //           style: TextStyle(
          //             color: Colors.black,
          //             fontSize: 50,
          //           ),
          //         ),
          //         SizedBox(
          //           height: 10.h,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             TextButton(
          //               onPressed: () {
          //                 Navigator.of(context).pop();
          //               },
          //               child: const Text('Cancel'),
          //             ),
          //             TextButton(
          //               onPressed: () {
          //                 Future.delayed(Duration(seconds: 0), () {
          //                   Navigator.of(context).pushAndRemoveUntil(
          //                     MaterialPageRoute(
          //                       builder: (BuildContext context) =>
          //                           LoginPage(),
          //                     ),
          //                     (route) => false,
          //                   );
          //                 });
          //               },
          //               child: Text('Ok'),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          );
    });
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bidController = TextEditingController();
  Future<void> _showMyDialog(int index, String currentCurrency, int bidId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text(AppLocalizations.of(context).translate('countOffer')),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text('Enter Price'),
                  SizedBox(height: 20.h),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _bidController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Counter Offer amount';
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 15.sp, fontFamily: 'Metropolis', letterSpacing: 2.2.w),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          suffix: Text(
                            currentCurrency,
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.w, fontFamily: "MetropolisExtraBold"),
                          ),
                          fillColor: const Color(0xfff3f3f4),
                          filled: true)),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text(AppLocalizations.of(context).translate('cancel')),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(AppLocalizations.of(context).translate('send')),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        context.read<BidProvider>().makeCounterOffer(_bidController.text.trim(), bidId, context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
