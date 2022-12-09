// ignore_for_file: prefer_final_fields, unused_field, unused_local_variable, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:laybull_v3/loader/loader.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/user_model.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/providers/product_provider.dart';
import 'package:laybull_v3/screens/login_screen.dart';
import 'package:laybull_v3/screens/main_dashboard_screen.dart';
import 'package:laybull_v3/screens/welcome_screen.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/storage_service.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';
import 'package:provider/src/provider.dart';

import '../enum.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  StorageService? storageServie = locator<StorageService>();

  List<String> imgText = [
    "The Middle East's marketplace for buying & selling the most sought-after fashion items",
    "Shop the latest and rarest items new & used. ",
    "All items are sent to Laybull's authentication team before being shipped to you",
    // "United Arab Emirates, Saudi Arabia, Oman, India, Bahrain, Kuwait, Lebanon, Jordan & Israel",
  ];
  List<String> imgHeading = [
    "Welcome to Laybull",
    "Explore Items Uploaded Daily",
    "Guaranteed Authentic ",
    // "Our Locations",
  ];
  // SwiperController _controller = SwiperController();

  final List<String> imgList = [
    'Page1.png',
    'page2.png',
    'page3.png',
    // 'page4.png',
  ];

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(
      'assets/$assetName',
      width: width,
      scale: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(
      fontSize: 25.0.sp,
      fontWeight: FontWeight.w700,
      color: Color(
        0xff000000,
      ),
    ));
    // final List<String> titles = [
    //   'Welcome to'
    //   AppLocalizations.of(context)!.translate('welcomeToLaybull').toUpperCase(),
    //   AppLocalizations.of(context)!.translate('exploreItemsUploadedDaily'),
    //   AppLocalizations.of(context)!.translate('guaranteedAuthentic'),
    //   AppLocalizations.of(context)!.translate('ourLocations'),
    // ];
    // final List<String> subtitles = [
    //   AppLocalizations.of(context)!.translate('welcomeDetail'),
    //   AppLocalizations.of(context)!.translate('itemsDetail'),
    //   AppLocalizations.of(context)!.translate('autenticDetail'),
    //   AppLocalizations.of(context)!.translate('locationDetail'),
    // ];
    /* return Scaffold(
      body: Swiper(
        loop: false,
        autoplay: isAutoPlay,
        index: _currentIndex,
        onIndexChanged: (index) async {
          setState(() {
            _currentIndex = index;
          });
          if (index >= titles.length - 1) {
            setState(() {
              isAutoPlay = false;
            });
            await Future.delayed(const Duration(seconds: 1));
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext ctx) => LoginPage()));
          }
        },
        controller: _controller,
        pagination: const SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeColor: Colors.black,
            activeSize: 8.0,
          ),
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return IntroItem(
            title: titles[index],
            subtitle: subtitles[index],
            bg: colors[index],
            imageUrl: "assets/" + image[index],
          );
        },
      ),
    );
  */
    return Scaffold(
      backgroundColor: Colors.white,
      // drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10,
              top: 10,
            ),
            child: TextButton(
              onPressed: () async {
                // if (context.read<AuthProvider>().user != null) {
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (BuildContext context) => BottomNav(
                //       navIndex: 0,
                //     ),
                //   ));
                // } else {
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: (BuildContext context) => LoginPage()));
                // }
                await storageServie!
                    .setBoolData(StorageKeys.first_time.toString(), true);
                if (context.read<AuthProvider>().user != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => BottomNav(
                      navIndex: 0,
                    ),
                  ));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()));
                }
              },
              child: Text(
                "SKIP",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              height: 600.h,
              alignment: Alignment.topCenter,
              child: IntroductionScreen(
                key: introKey,
                globalBackgroundColor: Colors.white,
                pages: [
                  for (int i = 0; i < imgHeading.length; i++) ...[
                    PageViewModel(
                      useScrollView: false,
                      title: imgHeading[i].toUpperCase(),
                      body: imgText[i],
                      image: _buildImage(imgList[i]),
                    ),
                  ],
                ],
                onChange: (int index) {
                  if (index == 2) {
                    Timer(Duration(seconds: 2), () async {
                      await storageServie!
                          .setBoolData(StorageKeys.first_time.toString(), true);
                      if (context.read<AuthProvider>().user != null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => BottomNav(
                            navIndex: 0,
                          ),
                        ));
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()));
                      }
                    });
                  }
                },
                // done: Padding(
                //   padding: const EdgeInsets.all(0.0),
                //   child: TextButton(
                //     style: ButtonStyle(
                //       backgroundColor: MaterialStateProperty.all(Colors.black),
                //     ),
                //     onPressed: () async {
                // if (context.read<AuthProvider>().user != null) {
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (BuildContext context) => BottomNav(
                //       navIndex: 0,
                //     ),
                //   ));
                // } else {
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: (BuildContext context) => LoginPage()));
                // }
                //     },
                //     child: Text(
                //       AppLocalizations.of(context).translate('done'),
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontWeight: FontWeight.w300,
                //         fontSize: 20.sp,
                //       ),
                //     ),
                //   ),
                // ),
                // onDone: () async {
                //   if (context.read<AuthProvider>().user != null) {
                //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: (BuildContext context) => BottomNav(
                //         navIndex: 0,
                //       ),
                //     ));
                //   } else {
                //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                //         builder: (BuildContext context) => LoginPage()));
                //   }
                // },
                showSkipButton: false,
                controlsPosition:
                    Position(left: 0.w, right: 0.w, bottom: -40.h),
                skipOrBackFlex: 0,
                nextFlex: 0,
                showBackButton: false,
                showNextButton: false,
                showDoneButton: false,
                curve: Curves.easeIn,
                controlsMargin: EdgeInsets.all(16.r),
                controlsPadding:
                    EdgeInsets.fromLTRB(0.0.w, 0.0.h, 0.0.w, 30.0.h),
                dotsDecorator: DotsDecorator(
                  spacing: EdgeInsets.only(left: 3.w, right: 3.w),
                  size: Size(10.0.w, 10.0.h),
                  color: Color(0xff1CACE3).withOpacity(0.3),
                  activeSize: Size(22.0.w, 10.0.h),
                ),
              ),
            ),
            // Positioned.fill(
            //   bottom: 50,
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Container(
            //         height: 70,
            //         width: 213,
            //         // ignore: missing_required_param
            //         child: Text("d")),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
