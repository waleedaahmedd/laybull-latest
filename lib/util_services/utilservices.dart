import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:laybull_v3/constants.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/screens/login_screen.dart';
import 'package:path_provider/path_provider.dart';

import 'package:provider/src/provider.dart';

class UtilService {
  bool? isConnected;

  Future<void> checkConnection() async {
    isConnected = await InternetConnectionChecker().hasConnection;
    StreamSubscription<InternetConnectionStatus> listener = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            // ignore: avoid_print

            isConnected = true;

            break;
          case InternetConnectionStatus.disconnected:
            // MyProgressDialog(context).hide();

            isConnected = false;

            break;
        }
      },
    );
    await Future<void>.delayed(const Duration(seconds: 90));
    await listener.cancel();
  }

  Future<File> imageCompression(File imageToCompress) async {
    final dir = await getTemporaryDirectory();
    final targetPath = dir.path + "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
    final File result = await FlutterImageCompress.compressAndGetFile(
      imageToCompress.path,
      targetPath,
      quality: 20,
    ) as File;

    print(result.lengthSync());
    print('Size before compress ${imageToCompress.lengthSync()}');
    print('Size after compress ${result.lengthSync()}');
    return result;
  }

  showToast(String msg, ToastGravity position) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: position,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showDialogue(String msg, BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).translate('notification'),
          style: headingStyle,
        ),
        content: Text(
          msg,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w100,
            letterSpacing: 0.5,
            fontFamily: "MetropolisBold",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context).translate('cancel'),
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.sp,
                letterSpacing: 1.2,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Future.delayed(const Duration(seconds: 0), () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              });
            },
            child: Text(
              AppLocalizations.of(context).translate('okay'),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
      context: context,
    );
  }
}
