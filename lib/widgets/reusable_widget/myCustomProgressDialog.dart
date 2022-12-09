// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:laybull_v3/locale/app_localization.dart';

// import 'package:progress_dialog/progress_dialog.dart';
// import 'dart:ui';

// class MyProgressDialog {
//   ProgressDialog? progressDialog;
//   MyProgressDialog(BuildContext context) {
//     progressDialog = ProgressDialog(
//       context,
//       isDismissible: false,
//       type: ProgressDialogType.Normal,
//       // textDirection: TextDirection.rtl,
//     );
//     progressDialog!.style(
//       borderRadius: 10.0,
//       message: AppLocalizations.of(context).translate('loading').toUpperCase(),
//       messageTextStyle: TextStyle(
//         fontSize: 14,
//         color: Colors.black,
//         fontWeight: FontWeight.bold,
//         letterSpacing: 2,
//         fontFamily: "MetropolisExtraBold",
//       ),
//       backgroundColor: Colors.white,
//       child: Image.asset(
//         "assets/Larg-Size.gif",
//       ),
//       elevation: 10.0,
//       insetAnimCurve: Curves.easeInOut,
//     );
//   }
//   show() {
//     progressDialog!.show();
//   }

//   hide() {
//     progressDialog!.hide();
//   }
// }
