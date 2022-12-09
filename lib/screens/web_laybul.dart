// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';

class WebLaybull extends StatefulWidget {
  String url;

  WebLaybull(this.url);

  @override
  _WebLaybullState createState() => _WebLaybullState();
}

class _WebLaybullState extends State<WebLaybull> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
       var count = 0;
        Navigator.popUntil(context, (route) {
          return count++ == 2;
        });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('Laybull', style: headingStyle),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
