// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:laybull_v3/locale/app_localization.dart';

String userLocal = '';

//base euro prices - 8
double deliveryCharges = 8.2;

String cSymbol = '';
var userData;
String? userEmail;
String? userShipmentAddress;
String? userShipmentCity;
String? userShipmentCountry;
String? userShipmentPhone;

void successSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  AppLocalizations.of(context).translate('uploadedSuccessProduct').toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context).translate('successfully').toUpperCase(),
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'MetropolisBold',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('continueSelling'),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      });
}
