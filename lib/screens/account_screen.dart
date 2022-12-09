// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, unnecessary_string_interpolations, prefer_const_constructors_in_immutables, unnecessary_null_comparison,

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/Product.dart';
import 'package:laybull_v3/models/user_follower_model.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/bidding_provider.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/screens/become_seller_screen.dart';
import 'package:laybull_v3/screens/edit_profile_screen.dart';
import 'package:laybull_v3/screens/faq_screen.dart';
import 'package:laybull_v3/screens/offer_screen.dart';
import 'package:laybull_v3/screens/selling_screen.dart';
import 'package:laybull_v3/screens/sold_products_screen.dart';
import 'package:laybull_v3/screens/web_laybul.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/main_account_drawer.dart';
import 'package:laybull_v3/widgets/photo_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:laybull_v3/extensions.dart';

class AccountScreen extends StatefulWidget {
  final int? userId;
  final bool comingFromDashboard;

  AccountScreen({
    Key? key,
    this.userId,
    required this.comingFromDashboard,
  }) : super(key: key);
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

enum SingingCharacter { english, arabic }

class _AccountScreenState extends State<AccountScreen> {
  showListFollowers(List<UserFollower> list) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (ctx) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.r),
              topLeft: Radius.circular(20.r),
            ),
            child: Container(
                color: Colors.white,
                height: (MediaQuery.of(context).size.height * .6).h,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      height: 55.h,
                      child: Center(
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context).translate('following').toUpperCase(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                // fontFamily: 'MetropolisMedium',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Divider(
                        height: 2.h,
                      ),
                    ),
                    Expanded(
                      child: list.isNotEmpty
                          ? ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(top: 10.h, left: 10.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image:
                                                  //  list[index].profilePic !=
                                                  //         null
                                                  //     ? NetworkImage(
                                                  //         list[index].profilePic,
                                                  //         scale: 1.0,
                                                  //       )
                                                  //     :
                                                  AssetImage('assets/page2.png'),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "${list[index].userName}",
                                        // style: LiteText,
                                      ),
                                    ],
                                  ),
                                );
                              })
                          : Center(
                              child: Text(
                                AppLocalizations.of(context).translate('nofollowing').toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  // fontFamily: 'MetropolisMedium',
                                ),
                              ),
                            ),
                    ),
                  ],
                )),
          );
        });
  }

  double _userRatingResult = 0.0;
  var utilService = locator<UtilService>();
  _showRatingDialogue(double initialRating, int id) async {
    // double rating = 3.5;
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AlertDialog(
              title: Text(
                'RATE USER',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.w,
                  // fontFamily: "MetropolisExtraBold",
                ),
              ),
              content: Container(
                // height: 23,
                // width: MediaQuery.of(context).size.width,
                child: RatingBar.builder(
                  initialRating: initialRating,
                  minRating: 0.5,
                  glow: false,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  updateOnDrag: true,
                  itemCount: 5,
                  maxRating: 5,
                  itemSize: 45,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    // print(value);
                    setState(() {
                      initialRating = value;
                    });
                    print(initialRating);
                  },
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
                        child: Text(AppLocalizations.of(context).translate('rate')),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await context.read<AuthProvider>().rateUser(id, initialRating, context);
                        }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  var scaffolKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print("kalf ${widget.comingFromDashboard}");
    var currencyConversion = context.read<CurrencyProvider>();

    return
        //  isLoading
        //     ? Container(
        //         color: Colors.white,
        //         height: MediaQuery.of(context).size.height,
        //         child: Center(
        //           child: Image.asset(
        //             "assets/Larg-Size.gif",
        //             height: 125.0,
        //             width: 125.0,
        //           ),
        //         ),
        //       )
        //     :
        Consumer<AuthProvider>(builder: (context, ap, _) {
      return ap.isfetchingUserDetail == true
          ? Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Center(
                child: Image.asset(
                  "assets/Larg-Size.gif",
                  height: 125.0,
                  width: 125.0,
                ),
              ),
            )
          : Scaffold(
              appBar: widget.comingFromDashboard == true
                  ? null
                  : AppBar(
                      iconTheme: IconThemeData(color: Colors.black),
                      // leading: widget.comingFromDashboard == false
                      //     ? widget.userId == ap.user!.id
                      //         ? IconButton(
                      //             icon: Icon(Icons.menu),
                      //             onPressed: () {
                      //               scaffolKey.currentState!.openDrawer();
                      //             },
                      //           )
                      //         : null
                      //     : null,
                      elevation: 0,
                      backgroundColor: Colors.white10,
                      automaticallyImplyLeading: widget.comingFromDashboard == true ? false : true,
                      title: widget.comingFromDashboard == false
                          ? Text(
                              AppLocalizations.of(context).translate('account').toUpperCase(),
                              style: headingStyle,
                            )
                          : null,
                    ),
              key: scaffolKey,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        // Container(
                        //   child: Image.asset(
                        //     'assets/profileBack.jpg',
                        //     height: 200.h,
                        //     width: MediaQuery.of(context).size.width.w,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 18.0.r),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Center(
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(60.r),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: widget.userId == ap.user!.id
                                          ? ap.user!.profile_picture.toString()
                                          : ap.fetchedUser != null
                                              ? ap.fetchedUser!.profile_picture.toString()
                                              : '',
                                      height: 30,
                                      width: 30,
                                      // progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      //     Center(child: CircularProgressIndicator(color: Colors.grey, value: downloadProgress.progress)),
                                      errorWidget: (context, url, error) => Icon(
                                        Icons.error,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.userId != ap.user!.id) ...[
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (ap.fetchedUser!.isFollow == true) {
                                      ap.unFollowUser(
                                        ap.fetchedUser!.id,
                                        context,
                                        ap.user!.id,
                                      );
                                    } else {
                                      ap.followUser(
                                        ap.fetchedUser!.id,
                                        context,
                                        ap.user!.id,
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 28.h,
                                    width: 103.w,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                    child: Center(
                                        child: Text(
                                      ap.isfetchingUserDetail
                                          ? ''
                                          : ap.fetchedUser!.isFollow == false
                                              ? AppLocalizations.of(context).translate('follow').toUpperCase()
                                              : AppLocalizations.of(context)
                                                  .translate(
                                                    'following',
                                                  )
                                                  .toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        letterSpacing: 1.2.w,
                                        // fontFamily:
                                        //     'MetropolisRegular',
                                      ),
                                    )),
                                  ),
                                ),
                              ],

                              // SizedBox(
                              //   height: 15.w,
                              // ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // SizedBox(height: 5.h),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Text('${ap.user!.verified_vendor.toString()}'),
                                          // Text('${ap.fetchedUser!.verified_vendor.toString()}'),
                                          // Text('${ap.fetchedUser!.first_name.toString()}'),
                                          if (widget.userId != ap.user!.id)
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.check_circle_rounded, color: Colors.transparent),
                                            ),
                                          widget.userId == ap.user!.id
                                              ? IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (BuildContext context) => EditProfileScreen(
                                                            // profileUrl: ap.user!.profile_picture,
                                                            )));

                                                    ap.clearSignUpFields();
                                                    ap.emailControllerForSG.text = ap.user!.email;
                                                    ap.firstNameControllerForSG.text = ap.user!.first_name;
                                                    ap.lastNameControllerForSG.text = ap.user!.last_name;
                                                    ap.phoneControllerForSG.text = ap.user!.phoneNumber.toString();
                                                    ap.editedProfilePicUrl = ap.user!.profile_picture;
                                                    ap.selectedCountry = ap.countries.where((element) => element.name == ap.user!.country).first;
                                                    ap.user!.country;
                                                    ap.cityControllerForSG.text = ap.user!.city!;
                                                    ap.addressControllerForSG.text = ap.user!.address.toString();
                                                    ap.isSeller = ap.user!.isSeller == 1 ? true : false;
                                                    if (ap.isSeller == true) {
                                                      ap.bankNameControllerForSG.text = ap.user!.bankName ?? '';
                                                      ap.ibanNumberControllerForSG.text = ap.user!.IBAN ?? '';
                                                      ap.accountNumberControllerForSG.text = ap.user!.accountNumber ?? '';
                                                      ap.accountNameControllerForSG.text = ap.user!.accountHolderName ?? '';
                                                    }
                                                  },
                                                )
                                              : Container(),
                                          Text(
                                            widget.userId == ap.user!.id
                                                ? '${ap.user!.first_name} ${ap.user!.last_name}'
                                                : ap.fetchedUser != null
                                                    ? '${ap.fetchedUser!.first_name} ${ap.fetchedUser!.last_name}'
                                                    : '',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          if (widget.userId == ap.user!.id)
                                            ap.user!.verified_vendor == 1
                                                ? IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.check_circle_rounded, color: Colors.blue),
                                                  )
                                                : IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.check_circle_rounded, color: Colors.transparent),
                                                  ),
                                          if (widget.userId != ap.user!.id)
                                            ap.fetchedUser!.verified_vendor == 1
                                                ? IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.check_circle_rounded, color: Colors.blue),
                                                  )
                                                : IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.check_circle_rounded, color: Colors.transparent),
                                                  ),
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 10.h,
                                      // ),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () => widget.userId == ap.user!.id
                                                ? null
                                                : _showRatingDialogue(widget.userId != ap.user!.id ? ap.fetchedUser!.ratting! : ap.user!.ratting!,
                                                    widget.userId != ap.user!.id ? ap.fetchedUser!.id : 0),
                                            child: Container(
                                              height: 23.h,
                                              child: RatingBar.builder(
                                                onRatingUpdate: (rate) {
                                                  return;
                                                },
                                                initialRating: widget.userId != ap.user!.id ? ap.fetchedUser!.ratting! : ap.user!.ratting!,
                                                glow: false,
                                                tapOnlyMode: true,
                                                itemSize: 34.h,
                                                minRating: 0.5,
                                                direction: Axis.vertical,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                maxRating: 5,
                                                itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                ignoreGestures: true,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            widget.userId != ap.user!.id ? '(${ap.fetchedUser!.ratting_count})' : '(${ap.user!.ratting_count})',
                                            style: LiteText,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Text("0"),
                                              SizedBox(height: 05.h),
                                              Text(
                                                'Sales',
                                                style: LiteText,
                                              )
                                            ],
                                          ),
                                          SizedBox(width: 10.w),
                                          Column(
                                            children: [
                                              Text(
                                                ap.user!.id != widget.userId ? '${ap.fetchedUser!.followers}' : '${ap.user!.followers}',
                                              ),
                                              SizedBox(height: 05.h),
                                              Text(
                                                AppLocalizations.of(context).translate('followers'),
                                                style: LiteText,
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 10.w),
                                          GestureDetector(
                                            onTap: ap.user!.id != widget.userId ? null : () {},
                                            child: Column(
                                              children: [
                                                Text(
                                                  widget.userId != ap.user!.id ? '${ap.fetchedUser!.followings}' : '${ap.user!.followings}',
                                                ),
                                                SizedBox(height: 05.h),
                                                Text(
                                                  AppLocalizations.of(context).translate(
                                                    'following',
                                                  ),
                                                  style: LiteText,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Container(
                                child: Divider(
                                  color: Color(0xffF4F4F4),
                                  height: 5.h,
                                  thickness: 1.r,
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 0.0.h,
                                  // left: 8.w,
                                  // right: 8.w,
                                ),
                                child: Container(
                                  // height: MediaQuery.of(context).size.height*1.3,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      widget.userId == ap.user!.id
                                          ? InkWell(
                                              onTap: () {
                                                ap.user!.isSeller == 0
                                                    ? Navigator.of(context)
                                                        .push(MaterialPageRoute(builder: (BuildContext context) => BecomeSeller(userId: ap.user!.id)))
                                                    : null;
                                              },
                                              child: Container(
                                                width: (MediaQuery.of(context).size.width / 1.07).w,
                                                height: 45.h,
                                                margin: EdgeInsets.only(bottom: 15.h),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.circular(5.0.r),
                                                ),
                                                child: Text(
                                                  ap.user!.isSeller == 0
                                                      ? AppLocalizations.of(context).translate('becomeSeller').toUpperCase()
                                                      : 'You are already a seller!'.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: 2.w,
                                                    // fontFamily:
                                                    //     "MetropolisExtraBold",
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(context).translate('selling').toUpperCase(),
                                                          style: Textprimary,
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        Text(
                                                          '',
                                                          style: LiteText,
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => Selling(
                                                                sellingProducts: ap.fetchedUser!.products!.where((element) => element.sold == 0).toList(),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.all(12.0.r),
                                                          child: Text(
                                                            AppLocalizations.of(context).translate('viewAll').toUpperCase(),
                                                            style: TextStyle(
                                                              color: Color(0xff5DB3F5),
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 12.sp,
                                                              fontFamily: "MetropolisBold",
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                ap.fetchedUser!.products!.isEmpty
                                                    ? Container(
                                                        height: 170.h,
                                                        decoration: BoxDecoration(
                                                          color: Color(
                                                            0xffF4F4F4,
                                                          ),
                                                          borderRadius: BorderRadius.circular(
                                                            10.r,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            AppLocalizations.of(context).translate('noProducts'),
                                                            style: LiteText,
                                                          ),
                                                        ),
                                                      )
                                                    : ProductGridView(
                                                        product: ap.fetchedUser!.products!.length > 2
                                                            ? [ap.fetchedUser!.products![0], ap.fetchedUser!.products![1]]
                                                            : ap.fetchedUser!.products!,
                                                        onFavoutireButtonTapped: null,
                                                        isfavScreen: false,
                                                      ),
                                                Divider(
                                                  color: Color(0xffF4F4F4),
                                                  height: 5.h,
                                                  thickness: 1.r,
                                                ),
                                              ],
                                            ),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      if (widget.userId == ap.user!.id) ...[
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(context).translate('selling').toUpperCase(),
                                                      style: Textprimary,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text(
                                                      '',
                                                      style: LiteText,
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => Selling(
                                                            sellingProducts: ap.user!.products!.where((element) => element.sold == 0).toList(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.all(12.0.r),
                                                      child: Text(
                                                        AppLocalizations.of(context).translate('viewAll').toUpperCase(),
                                                        style: TextStyle(
                                                          color: Color(0xff5DB3F5),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12.sp,
                                                          fontFamily: "MetropolisBold",
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            ap.user!.products!.isEmpty
                                                ? Container(
                                                    height: 170.h,
                                                    decoration: BoxDecoration(
                                                      color: Color(
                                                        0xffF4F4F4,
                                                      ),
                                                      borderRadius: BorderRadius.circular(
                                                        10.r,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        AppLocalizations.of(context).translate('noProducts'),
                                                        style: LiteText,
                                                      ),
                                                    ),
                                                  )
                                                : ProductGridView(
                                                    product:
                                                        ap.user!.products!.length > 2 ? [ap.user!.products![0], ap.user!.products![1]] : ap.user!.products!,
                                                    onFavoutireButtonTapped: null,
                                                    isfavScreen: false,
                                                  ),
                                            Divider(
                                              color: Color(0xffF4F4F4),
                                              height: 5.h,
                                              thickness: 1.r,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8.0.r),
                                              child: Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(context)
                                                            .translate('offers')
                                                            // "Offers"
                                                            .toUpperCase(),
                                                        style: Textprimary,
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Text(
                                                        context.read<BidProvider>().recievedBids != null
                                                            ? context.read<BidProvider>().recievedBids!.length.toString()
                                                            : 0.toString(),
                                                        style: LiteText,
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext context) => OfferScreen(
                                                            comingfromDashBoard: false,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        12.0.r,
                                                      ),
                                                      child: Text(
                                                        AppLocalizations.of(context).translate('viewAll').toUpperCase(),
                                                        style: TextStyle(
                                                          color: Color(0xff5DB3F5),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12.sp,
                                                          fontFamily: "MetropolisBold",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Container(
                                                height: 170.h,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffF4F4F4),
                                                  borderRadius: BorderRadius.circular(
                                                    10.r,
                                                  ),
                                                ),
                                                child: context.read<BidProvider>().sentBids != null
                                                    ? context.read<BidProvider>().sentBids!.isNotEmpty
                                                        ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Container(
                                                                width: 120.w,
                                                                margin: EdgeInsets.symmetric(vertical: 20.h),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(10.r),
                                                                  child: Image.network(
                                                                    context.read<BidProvider>().sentBids![0].product!.featured_image!,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 15.w,
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                // ignore: prefer_const_literals_to_create_immutables
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10.h,
                                                                  ),
                                                                  Text(
                                                                    context.read<BidProvider>().sentBids![0].product!.name ?? '',
                                                                    style: TextStyle(
                                                                        // fontFamily:
                                                                        //     'MetropolisMedium',
                                                                        letterSpacing: 1.2,
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: 16.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 8.h,
                                                                  ),
                                                                  Text(
                                                                    AppLocalizations.of(context).translate('new'),
                                                                    style: TextStyle(color: Colors.grey),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 8.h,
                                                                  ),
                                                                  Text(
                                                                    "${context.read<CurrencyProvider>().selectedCurrency} ${context.read<BidProvider>().sentBids![0].price ?? 0}",
                                                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10.h,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {},
                                                                    child: Container(
                                                                      height: 30,
                                                                      width: 100,
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.green),
                                                                        borderRadius: BorderRadius.circular(
                                                                          3.r,
                                                                        ),
                                                                      ),
                                                                      child: Center(
                                                                          child: Text(
                                                                        context.read<BidProvider>().sentBids![0].status == 'pending'
                                                                            ? 'Pending'
                                                                            : AppLocalizations.of(context).translate(
                                                                                'ACCEPT',
                                                                              ),
                                                                        style: TextStyle(color: Colors.green, fontSize: 10),
                                                                      )),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        : Container(
                                                            height: 170.h,
                                                            decoration: BoxDecoration(color: Color(0xffF4F4F4), borderRadius: BorderRadius.circular(10.r)),
                                                            child: Center(
                                                              child: Text(
                                                                "No Products",
                                                              ),
                                                            ),
                                                          )
                                                    : Container(
                                                        height: 170.h,
                                                        decoration: BoxDecoration(color: Color(0xffF4F4F4), borderRadius: BorderRadius.circular(10.r)),
                                                        child: Center(
                                                          child: Text(
                                                            "No Products",
                                                          ),
                                                        ),
                                                      )),
                                          ],
                                        )
                                      ],
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0.r),
                                            child: Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Sold".toUpperCase(),
                                                      style: Textprimary,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text(
                                                      "${ap.listOfSold.length}",
                                                      style: LiteText,
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                ap.listOfSold.isEmpty
                                                    ? SizedBox()
                                                    : InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => SoldProducts(
                                                                      listSold: ap.listOfSold,
                                                                    )),
                                                          );
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(context).translate('viewAll'),
                                                          // AppLocalizations.of(
                                                          //         context)!
                                                          //     .translate(
                                                          //         'viewAll'),
                                                          style: TextStyle(fontSize: 11.sp, color: Colors.blue),
                                                        )),
                                              ],
                                            ),
                                          ),
                                          ap.listOfSold.isEmpty
                                              ? Container(
                                                  height: 170.h,
                                                  decoration: BoxDecoration(color: Color(0xffF4F4F4), borderRadius: BorderRadius.circular(10.r)),
                                                  child: Center(
                                                    child: Text(
                                                      "No Products",
                                                    ),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  itemCount: ap.listOfSold.length > 2 ? 2 : ap.listOfSold.length,
                                                  shrinkWrap: true,
                                                  physics: BouncingScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    return Container(
                                                      height: 170.h,
                                                      margin: EdgeInsets.symmetric(vertical: 3.h),
                                                      decoration: BoxDecoration(color: Color(0xffF4F4F4), borderRadius: BorderRadius.circular(10.r)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Container(
                                                            width: 120.w,
                                                            margin: EdgeInsets.symmetric(vertical: 20.h),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(10.r),
                                                              child: ap.listOfSold.isNotEmpty && ap.listOfSold[index].featureImage != null
                                                                  ? Image.network(
                                                                      '',
                                                                      fit: BoxFit.cover,
                                                                    )
                                                                  : Image.asset('assets/bigshoe.png'),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 15.w,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: (MediaQuery.of(context).size.height * .02).h,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    '${ap.listOfSold[index].updatedAt.toString().substring(0, 10)}',
                                                                    style: TextStyle(color: Colors.grey),
                                                                    textAlign: TextAlign.end,
                                                                  ),
                                                                ],
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                              ),
                                                              SizedBox(
                                                                height: 10.h,
                                                              ),
                                                              Text(
                                                                ap.listOfSold.isNotEmpty ? ap.listOfSold[index].name : 'Product',
                                                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
                                                              ),
                                                              SizedBox(
                                                                height: 8.h,
                                                              ),
                                                              Text(
                                                                ap.listOfSold.isNotEmpty
                                                                    ? ap.listOfSold[index].condition + " | " + ap.listOfSold[index].size
                                                                    : "New",
                                                                style: TextStyle(color: Colors.grey),
                                                              ),
                                                              SizedBox(
                                                                height: 8.h,
                                                              ),
                                                              Text(
                                                                ap.listOfSold.isNotEmpty
                                                                    ? double.parse(ap.listOfSold[index].price).convertToLocal(context).toStringAsFixed(2) +
                                                                        " " +
                                                                        currencyConversion.selectedCurrency.toUpperCase()
                                                                    : "${context.read<CurrencyProvider>().selectedCurrency} 3000",
                                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
                                                              ),
                                                              SizedBox(
                                                                height: 10.h,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                        ],
                                      ),
                                      widget.userId == ap.user!.id
                                          ? Column(
                                              children: [
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(8.0.r),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            // AppLocalizations.of(
                                                            //         context)!
                                                            //     .translate(
                                                            //         'ordered')
                                                            "Ordered".toUpperCase(),
                                                            style: Textprimary,
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Text(
                                                            "${ap.listOfPurchased.length}",
                                                            style: LiteText,
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      ap.listOfPurchased.isEmpty
                                                          ? SizedBox()
                                                          : InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => SoldProducts(
                                                                            listSold: ap.listOfPurchased,
                                                                            isSold: false,
                                                                          )),
                                                                );
                                                              },
                                                              child: Text(
                                                                // AppLocalizations.of(
                                                                //         context)!
                                                                //     .translate(
                                                                //         'viewAll'),
                                                                AppLocalizations.of(context).translate('viewAll'),
                                                                style: TextStyle(fontSize: 11.sp, color: Colors.blue),
                                                              )),
                                                    ],
                                                  ),
                                                ),
                                                if (ap.listOfPurchased.isEmpty)
                                                  Container(
                                                    height: 170.h,
                                                    decoration: BoxDecoration(color: Color(0xffF4F4F4), borderRadius: BorderRadius.circular(10.r)),
                                                    child: Center(
                                                      child: Text("No Products"),
                                                    ),
                                                  )
                                                else
                                                  ListView.builder(
                                                    itemCount: ap.listOfPurchased.length > 2 ? 2 : ap.listOfPurchased.length,
                                                    shrinkWrap: true,
                                                    physics: BouncingScrollPhysics(),
                                                    itemBuilder: (context, index) {
                                                      return Container(
                                                        height: 170.h,
                                                        width: (MediaQuery.of(context).size.width).w,
                                                        margin: EdgeInsets.symmetric(vertical: 3.h),
                                                        decoration: BoxDecoration(color: Color(0xffF4F4F4), borderRadius: BorderRadius.circular(10.r)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Container(
                                                              width: 120.w,
                                                              margin: EdgeInsets.symmetric(vertical: 20.h),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(10.r),
                                                                child: ap.listOfPurchased.isNotEmpty && ap.listOfPurchased[index].featureImage != null
                                                                    ? Image.network(
                                                                        '',
                                                                        fit: BoxFit.cover,
                                                                      )
                                                                    : Image.asset(
                                                                        'assets/bigshoe.png',
                                                                      ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 15.w,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: (MediaQuery.of(context).size.height * .02).h,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: 50.w,
                                                                      ),
                                                                      Text(
                                                                        '${ap.listOfPurchased[index].updatedAt.toString().substring(0, 10)}',
                                                                        style: TextStyle(color: Colors.grey),
                                                                        textAlign: TextAlign.end,
                                                                      ),
                                                                    ],
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10.h,
                                                                  ),
                                                                  Text(
                                                                    ap.listOfPurchased.isNotEmpty ? ap.listOfPurchased[index].name : 'Product',
                                                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 8.h,
                                                                  ),
                                                                  Text(
                                                                    ap.listOfPurchased.isNotEmpty
                                                                        ? ap.listOfPurchased[index].condition + " | " + ap.listOfPurchased[index].size
                                                                        : "New",
                                                                    style: TextStyle(color: Colors.grey),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 8.h,
                                                                  ),
                                                                  Text(
                                                                    ap.listOfPurchased.isNotEmpty
                                                                        ? double.parse(ap.listOfPurchased[index].price)
                                                                                .convertToLocal(context)
                                                                                .toStringAsFixed(2) +
                                                                            " " +
                                                                            currencyConversion.selectedCurrency.toUpperCase()
                                                                        : "${context.read<CurrencyProvider>().selectedCurrency} 3000",
                                                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10.h,
                                                                  ),
                                                                  Container(
                                                                    height: 30.h,
                                                                    width: 100.w,
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(3.r)),
                                                                    child: Center(
                                                                        child: Text(
                                                                      ap.listOfPurchased[index].status.toString(),
                                                                      style: TextStyle(color: Colors.black, fontSize: 12.sp),
                                                                      textAlign: TextAlign.center,
                                                                    )),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                widget.userId == ap.user!.id
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          // String url =
                                                          //     "https://laybull.com/get-support";
                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FAQScreen()));
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
                                                            AppLocalizations.of(context)
                                                                .translate('getSupport')

                                                                // "Get Support"
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              letterSpacing: 2.w,
                                                              // fontFamily:
                                                              //     "MetropolisExtraBold",
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        // userLocal == "ar"
                        //     ? Positioned(
                        //         top: 115,
                        //         right: 20,
                        //         child: ClipRRect(
                        //           borderRadius: BorderRadius.circular(10),
                        //           child: CircleAvatar(
                        //             backgroundColor: Colors.transparent,
                        //             radius: 50,
                        //             backgroundImage: jsonData["user"]["detail"]
                        //                         ["image"] !=
                        //                     null
                        //                 ? NetworkImage(
                        //                     jsonData["user"]["detail"]["image"],
                        //                   )
                        //                 : AssetImage('assets/page2.png'),
                        //           ),
                        //         ),
                        //       )
                        //     : Positioned(
                        //         top: 115,
                        //         left: 20,
                        //         child: ClipRRect(
                        //           borderRadius: BorderRadius.circular(10),
                        //           child: CircleAvatar(
                        //             backgroundColor: Colors.transparent,
                        //             radius: 55,
                        //             backgroundImage: jsonData["user"]["detail"]
                        //                         ["image"] !=
                        //                     null
                        //                 ? NetworkImage(
                        //                     jsonData["user"]["detail"]["image"],
                        //                   )
                        //                 : AssetImage('assets/page2.png'),
                        //           ),
                        //         ),
                        //       ),
                        // // Align(
                        //   alignment: Alignment.topRight,
                        //   child: Container(
                        //     margin: EdgeInsets.only(
                        //       top: 5,
                        //     ),
                        //     child: GestureDetector(
                        //       onTap: () {
                        //         scaffolKey.currentState.openEndDrawer();
                        //       },
                        //       child: Card(
                        //         elevation: 30,
                        //         shadowColor: Colors.grey,
                        //         child: Container(
                        //           width: 70,
                        //           height: 45,
                        //           child: Center(
                        //               child: Icon(
                        //             Icons.menu,
                        //             color: Colors.black,
                        //           )),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        //adil logut and notification start code
                        // widget.userId == myUserId
                        //     ? Align(
                        //         alignment: Alignment.topRight,
                        //         child: Container(
                        //           margin: EdgeInsets.only(
                        //             top: 5,
                        //           ),
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               MyApp.sharedPreferences.clear();
                        //               Navigator.of(context).popUntil(
                        //                   (predicate) => predicate.isFirst);
                        //               Navigator.of(context).pushReplacement(
                        //                 MaterialPageRoute(
                        //                     builder: (context) =>
                        //                         LoginPage()),
                        //               );
                        //             },
                        //             child: Card(
                        //               elevation: 5,
                        //               shadowColor: Colors.grey,
                        //               child: Container(
                        //                 width: 70,
                        //                 height: 45,
                        //                 child: Center(
                        //                     child: Icon(
                        //                   Icons.logout,
                        //                   color: Colors.black,
                        //                 )),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : SizedBox(),
                        // widget.isFromBottomNav
                        //     ? Align(
                        //         alignment: Alignment.topLeft,
                        //         child: Container(
                        //           margin: EdgeInsets.only(
                        //             top: 5,
                        //           ),
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               AppRoutes.push(
                        //                   context,
                        //                   NotficationScreen.Notification(
                        //                     isFromProfile: true,
                        //                   ));
                        //             },
                        //             child: Card(
                        //               elevation: 5,
                        //               shadowColor: Colors.grey,
                        //               child: Container(
                        //                 width: 70,
                        //                 height: 45,
                        //                 child: Center(
                        //                   child: FlutterBadge(
                        //                     itemCount: _notificationProvider
                        //                         .getCount(),
                        //                     badgeTextColor: Colors.white,
                        //                     badgeColor: Colors.black38,
                        //                     textSize: 16,
                        //                     borderRadius: 100,
                        //                     icon: Icon(
                        //                       Icons
                        //                           .notifications_none_rounded,
                        //                       size: 30,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : Align(
                        //         alignment: Alignment.topLeft,
                        //         child: Container(
                        //           margin: EdgeInsets.only(
                        //             top: 5,
                        //           ),
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               Navigator.pop(context);
                        //             },
                        //             child: Card(
                        //               elevation: 5,
                        //               shadowColor: Colors.grey,
                        //               child: Container(
                        //                 width: 70,
                        //                 height: 45,
                        //                 child: Center(
                        //                     child: Image.asset(
                        //                   'assets/ARROW.png',
                        //                 )),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //adil logut and notification end code
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
