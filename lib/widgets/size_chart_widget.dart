// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PictureDialog extends StatefulWidget {
  String address;
  PictureDialog({
    Key? key,
    required this.address,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PictureDialog();
  }
}

class _PictureDialog extends State<PictureDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.asset(
            widget.address,
            fit: BoxFit.contain,
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
