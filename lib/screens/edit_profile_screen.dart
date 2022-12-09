import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/country_model.dart';
import 'package:laybull_v3/providers/auth_provider.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_black_button.dart';
import 'package:laybull_v3/widgets/reusable_widget/app_text_field.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var utilService = locator<UtilService>();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Future.delayed(Duration.zero);
      await context.read<AuthProvider>().getCountries(context);
      context.read<AuthProvider>().selectedCountry =
          context.read<AuthProvider>().countries.where((element) => element.name == context.read<AuthProvider>().user!.country).first;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white10,
        title: Text(
          'Edit Profile'.toUpperCase(),
          style: headingStyle,
        ),
      ),
      backgroundColor: Colors.white,
      body: Consumer<AuthProvider>(builder: (context, ap, _) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 25.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 75.h,
                      width: 75.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0.w,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5.0.r)),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            ap.showPicker(
                              context,
                            );
                            //     .then((value) {
                            //   if (value == false) {
                            //     setState(() {
                            //       ap.user!.profile_picture = null;
                            //     });
                            //   }
                            // });
                            setState(() {});
                          },
                          child: Container(
                            child: ap.user!.profile_picture == null
                                ? ap.imageFile != null
                                    ? Image.file(
                                        ap.profileImg!,
                                        width: 100.w,
                                        height: 100.h,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(
                                        decoration: BoxDecoration(color: const Color(0xFFE5F3FD), borderRadius: BorderRadius.circular(0.r)),
                                        width: 100.w,
                                        height: 100.h,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      )
                                : Image.network(
                                    ap.user!.profile_picture!,
                                    width: 100.w,
                                    height: 100.h,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 25.h,
              ),

              /// First Name+
              AppTextField(
                controller: ap.firstNameControllerForSG,
                hintText: AppLocalizations.of(context).translate('enterFirstName'),
                width: (MediaQuery.of(context).size.width / 1.07).w,
              ),
              SizedBox(
                height: 25.h,
              ),
              AppTextField(
                controller: ap.lastNameControllerForSG,
                hintText: AppLocalizations.of(context).translate('enterLasttName'),
                width: (MediaQuery.of(context).size.width / 1.07).w,
              ),

              SizedBox(
                height: 25.h,
              ),

              /// Email
              AppTextField(
                isReadyOnly: true,
                controller: ap.emailControllerForSG,
                // textInputType: TextInputType.emailAddress,
                hintText: AppLocalizations.of(context).translate('enterEmail'),
                width: (MediaQuery.of(context).size.width / 1.07).w,
              ),
              SizedBox(
                height: 25.h,
              ),

              /// Phone Number
              AppTextField(
                controller: ap.phoneControllerForSG,
                textInputType: TextInputType.phone,
                hintText: AppLocalizations.of(context).translate('enterPhoneNumber'),
                // textInputType: TextInputType.number,
                width: (MediaQuery.of(context).size.width / 1.07).w,
              ),
              SizedBox(
                height: 25.h,
              ),

              /// Country
              ap.isCountryFetched == true
                  ? Container(
                      // margin: EdgeInsets.symmetric(horizontal: 20.0.w),
                      height: 55,
                      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xfff3f3f4),
                        // border: Border.all(color:Colors.grey[400]),
                        borderRadius: BorderRadius.circular(10.0.r),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(
                          ap.selectedCountry == null ? AppLocalizations.of(context).translate('enterCountry') : ap.selectedCountry!.name!.toUpperCase(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: 'aveb',
                            letterSpacing: 2.2.w,
                          ),
                        ),
                        dropdownColor: Colors.grey[100],
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                        iconSize: 12,
                        underline: const SizedBox(),
                        style: TextStyle(color: Colors.black, fontSize: 15.sp),
                        value: ap.selectedCountry,
                        onChanged: (newValue) {
                          print("value = $ap.selectedCountry");
                          ap.selectedCountry = newValue as CountryModel?;
                          setState(() {});
                        },
                        items: ap.countries.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Row(
                              children: <Widget>[
                                Text(valueItem.name!),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : SizedBox(height: 10.h),
              SizedBox(
                height: 25.h,
              ),

              /// City
              AppTextField(
                controller: ap.cityControllerForSG,
                hintText: AppLocalizations.of(context).translate('enterCity'),
                width: (MediaQuery.of(context).size.width / 1.07).w,
              ),
              SizedBox(
                height: 25.h,
              ),

              /// Address
              AppTextField(
                controller: ap.addressControllerForSG,
                // textInputType: TextInputType.streetAddress,
                hintText: AppLocalizations.of(context).translate('enterAddress'),
                width: (MediaQuery.of(context).size.width / 1.07).w,
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('becomeSeller'),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      color: Colors.black,
                      letterSpacing: 2.2.w,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Checkbox(
                    value: ap.isSeller,
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    // onChanged: (value) {
                    //   setState(() {
                    //     ap.isSeller = value!;
                    //     ap.accountNumberControllerForSG.clear();
                    //     ap.accountNameControllerForSG.clear();
                    //     ap.accountHolderPhoneControllerForSG.clear();
                    //     ap.bankNameControllerForSG.clear();
                    //   });

                    // }),
                    onChanged: null,
                  ),
                ],
              ),
              SizedBox(
                height: ap.isSeller ? 10.h : 0,
              ),
              ap.isSeller
                  ? Column(
                      children: [
                        /// Bank Name
                        AppTextField(
                          controller: ap.bankNameControllerForSG,
                          hintText: AppLocalizations.of(context).translate('enterBankName'),
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                        ),

                        SizedBox(
                          height: 25.h,
                        ),

                        /// IBAN
                        AppTextField(
                          controller: ap.ibanNumberControllerForSG,
                          hintText: AppLocalizations.of(context).translate('enterIban'),
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                        ),

                        SizedBox(
                          height: 25.h,
                        ),

                        /// Account Number
                        AppTextField(
                          controller: ap.accountNumberControllerForSG,
                          hintText: AppLocalizations.of(context).translate('enterAccountNumber'),
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),

                        /// Account Holder Name
                        AppTextField(
                          controller: ap.accountNameControllerForSG,
                          hintText: AppLocalizations.of(context).translate('enterAccountHolderName'),
                          width: (MediaQuery.of(context).size.width / 1.07).w,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),

                        // GestureDetector(
                        //   onTap: null,
                        //   child: Padding(
                        //     padding: EdgeInsets.only(left: 12.0.w),
                        //     child: Text(
                        //         AppLocalizations.of(context)
                        //             .translate('whyWeNeedThis'),
                        //         style: const TextStyle(
                        //             color: const Color(
                        //               0xff5DB3F5,
                        //             ),
                        //             decoration: TextDecoration.underline)),
                        //   ),
                        // )
                      ],
                    )
                  : const SizedBox(),
              SizedBox(
                height: 10.h,
              ),

              /// SignUp Button
              Container(
                padding: EdgeInsets.only(right: 62.h),
                // height: 100,
                child: AppBlackButton(
                  onTap: () async {
                    // if (ap.profileImg == null) {
                    //   await ap.updateUser(
                    //     firstName: ap.firstNameControllerForSG.text,
                    //     lastName: ap.lastNameControllerForSG.text,
                    //     email: ap.emailControllerForSG.text,
                    //     phoneNumber: ap.phoneControllerForSG.text,
                    //     country: ap.selectedCountry!.name!,
                    //     city: ap.cityControllerForSG.text,
                    //     address: ap.addressControllerForSG.text,
                    //     bankName: ap.bankNameControllerForSG.text,
                    //     accountHolderName:
                    //         ap.accountHolderPhoneControllerForSG.text,
                    //     accountNumber: ap.accountNumberControllerForSG.text,
                    //     IBAN: ap.ibanNumberControllerForSG.text,
                    //     becomeSeller: ap.isSeller,
                    //     profilePic: null,
                    //     context: context,
                    //   );
                    // } else {

                    await ap.updateUser(
                      firstName: ap.firstNameControllerForSG.text,
                      lastName: ap.lastNameControllerForSG.text,
                      email: ap.emailControllerForSG.text,
                      phoneNumber: ap.phoneControllerForSG.text,
                      country: ap.selectedCountry!.name!,
                      city: ap.cityControllerForSG.text,
                      address: ap.addressControllerForSG.text,
                      bankName: ap.bankNameControllerForSG.text,
                      accountHolderName: ap.accountNameControllerForSG.text,
                      accountNumber: ap.accountNumberControllerForSG.text,
                      IBAN: ap.ibanNumberControllerForSG.text,
                      becomeSeller: ap.isSeller,
                      profilePic: ap.profileImg,
                      context: context,
                    );
                    // }
                  },
                  btnText: 'Save',
                  height: 40.h,
                  width: 250.w,
                ),
              ),

              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        );
      }),
    );
  }
}
