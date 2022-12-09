// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/models/shipping_mode.dart';

class UserModel {
  int id;
  String first_name;
  String last_name;
  String email;
  int? isSeller;
  int? verified_vendor;
  String? city;
  String? country;
  String? profile_picture;
  String? phoneNumber;
  String? contact;
  String? image;
  String? address;
  String? bankName;
  String? IBAN;
  int? followers;
  double? ratting;
  int? ratting_count;
  bool? isFollow;
  int? followings;
  String? accountNumber;
  String? accountHolderName;
  List<ProductsModel>? products;
  ShippingModel? shippingDetail;

  UserModel({
    // this.products,
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.isSeller,
    this.verified_vendor,
    this.city,
    this.country,
    this.profile_picture,
    this.phoneNumber,
    this.contact,
    this.image,
    this.address,
    this.bankName,
    this.IBAN,
    this.followers,
    this.ratting,
    this.ratting_count,
    this.isFollow,
    this.followings,
    this.accountNumber,
    this.accountHolderName,
    this.products,
    this.shippingDetail,
  });

  UserModel copyWith(
      {int? id,
      String? first_name,
      String? last_name,
      String? email,
      int? isSeller,
      int? verified_vendor,
      String? address,
      String? city,
      String? country,
      String? profile_picture,
      String? phoneNumber,
      String? contact,
      int? followers,
      int? followings,
      String? image,
      String? bankName,
      String? IBAN,
      String? accountNumber,
      String? accountHolderName,
      List<ProductsModel>? products}) {
    return UserModel(
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      email: email ?? this.email,
      isSeller: isSeller ?? this.isSeller,
      verified_vendor: verified_vendor ?? this.verified_vendor,
      city: city ?? this.city,
      country: country ?? this.country,
      profile_picture: profile_picture ?? this.profile_picture,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      contact: contact ?? this.contact,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      image: image ?? this.image,
      bankName: bankName ?? this.bankName,
      IBAN: IBAN ?? this.IBAN,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'isSeller': isSeller,
      'verified_vendor': verified_vendor,
      'city': city,
      'country': country,
      'profile_picture': profile_picture,
      'phoneNumber': phoneNumber,
      'contact': contact,
      'image': image,
      'address': address,
      'bankName': bankName,
      'IBAN': IBAN,
      'followers': followers,
      'ratting': ratting,
      'ratting_count': ratting_count,
      'isFollow': isFollow,
      'followings': followings,
      'accountNumber': accountNumber,
      'accountHolderName': accountHolderName,
      // 'products': products.map((x) => x?.toMap()).toList(),
      'shippingDetail': shippingDetail?.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      first_name: map['first_name'] as String,
      last_name: map['last_name'] as String,
      email: map['email'] as String,
      isSeller: map['isSeller'] != null ? map['isSeller'] as int : null,
      verified_vendor: map['verified_vendor'] != null ? map['verified_vendor'] as int : null,
      city: map['city'] != null ? map['city'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      profile_picture: map['profile_picture'] != null ? map['profile_picture'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      contact: map['contact'] != null ? map['contact'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      bankName: map['bankName'] != null ? map['bankName'] as String : null,
      IBAN: map['IBAN'] != null ? map['IBAN'] as String : null,
      followers: map['followers'] != null ? map['followers'] as int : null,
      ratting: map['ratting'] != null ? double.parse(map['ratting'].toString()) : 0.0,
      ratting_count: map['ratting_count'] != null ? map['ratting_count'] as int : 0,
      isFollow: map['is_follow'] != null ? map['is_follow'] as bool : null,
      followings: map['followings'] != null ? map['followings'] as int : null,
      accountNumber: map['accountNumber'] != null ? map['accountNumber'] as String : null,
      accountHolderName: map['accountHolderName'] != null ? map['accountHolderName'] as String : null,
      products: map['products'] != null
          ? List<ProductsModel>.from(
              (map['products'] as List<dynamic>).map<ProductsModel?>(
                (x) => ProductsModel.fromJson(x as Map<String, dynamic>),
              ),
            )
          : null,
      shippingDetail: map['shippingDetail'] != null ? ShippingModel.fromMap(map['shippingDetail'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, first_name: $first_name, last_name: $last_name, email: $email, isSeller: $isSeller, verified_vendor : $verified_vendor ,city: $city, country: $country, profile_picture: $profile_picture, phoneNumber: $phoneNumber, contact: $contact, image: $image, address: $address, bankName: $bankName, IBAN: $IBAN, followers: $followers, ratting: $ratting, ratting_count: $ratting_count, isFollow: $isFollow, followings: $followings, accountNumber: $accountNumber, accountHolderName: $accountHolderName, products: $products, shippingDetail: $shippingDetail)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.email == email &&
        other.isSeller == isSeller &&
        other.verified_vendor == verified_vendor &&
        other.city == city &&
        other.country == country &&
        other.profile_picture == profile_picture &&
        other.phoneNumber == phoneNumber &&
        other.contact == contact &&
        other.image == image &&
        other.address == address &&
        other.bankName == bankName &&
        other.IBAN == IBAN &&
        other.followers == followers &&
        other.ratting == ratting &&
        other.ratting_count == ratting_count &&
        other.isFollow == isFollow &&
        other.followings == followings &&
        other.accountNumber == accountNumber &&
        other.accountHolderName == accountHolderName &&
        listEquals(other.products, products) &&
        other.shippingDetail == shippingDetail;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        email.hashCode ^
        isSeller.hashCode ^
        verified_vendor.hashCode ^
        city.hashCode ^
        country.hashCode ^
        profile_picture.hashCode ^
        phoneNumber.hashCode ^
        contact.hashCode ^
        image.hashCode ^
        address.hashCode ^
        bankName.hashCode ^
        IBAN.hashCode ^
        followers.hashCode ^
        ratting.hashCode ^
        ratting_count.hashCode ^
        isFollow.hashCode ^
        followings.hashCode ^
        accountNumber.hashCode ^
        accountHolderName.hashCode ^
        products.hashCode ^
        shippingDetail.hashCode;
  }
}
