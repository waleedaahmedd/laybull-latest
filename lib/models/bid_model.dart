// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'bid_product.dart';

class BidModel {
  int? bidId;
  int? user_id;
  int? product_id;
  int? vendor_id;
  double? price;
  String? status;
  String? counter;
  BidProduct? product;
  BidModel({
    this.bidId,
    this.user_id,
    this.product_id,
    this.vendor_id,
    this.price,
    this.status,
    this.counter,
    this.product,
  });

  // factory BidModel.fromJson(Map<String, dynamic> json) {
  //   return BidModel(
  //       bidId: json["id"],
  //       product_id: json["product_id"],
  //       vendorId: json["vendor_id"],
  //       bidPrice: json["bid_price"],
  //       status: json["status"],
  //       counter: json["counter"],
  //       product:
  //           json["product"] == null ? null : Product.fromJson(json["product"]));
  // }

  BidModel copyWith({
    int? bidId,
    int? user_id,
    int? product_id,
    int? vendor_id,
    double? price,
    String? status,
    String? counter,
    BidProduct? product,
  }) {
    return BidModel(
      bidId: bidId ?? this.bidId,
      user_id: user_id ?? this.user_id,
      product_id: product_id ?? this.product_id,
      vendor_id: vendor_id ?? this.vendor_id,
      price: price ?? this.price,
      status: status ?? this.status,
      counter: counter ?? this.counter,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bidId': bidId,
      'user_id': user_id,
      'product_id': product_id,
      'vendor_id': vendor_id,
      'price': price,
      'status': status,
      'counter': counter,
      'product': product?.toJson(),
    };
  }

  factory BidModel.fromMap(Map<String, dynamic> map) {
    return BidModel(
      bidId: map['bidId'] != null ? map['bidId'] as int : null,
      user_id: map['user_id'] != null ? map['user_id'] as int : null,
      product_id: map['product_id'] != null ? map['product_id'] as int : null,
      vendor_id: map['vendor_id'] != null ? map['vendor_id'] as int : null,
      price: map['price'] != null ? map['price'] as double : null,
      status: map['status'] != null ? map['status'] as String : null,
      counter: map['counter'] != null ? map['counter'] as String : null,
      product: map['product'] != null
          ? BidProduct.fromJson(map['product'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BidModel.fromJson(String source) =>
      BidModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BidModel(bidId: $bidId, user_id: $user_id, product_id: $product_id, vendor_id: $vendor_id, price: $price, status: $status, counter: $counter, product: $product)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BidModel &&
        other.bidId == bidId &&
        other.user_id == user_id &&
        other.product_id == product_id &&
        other.vendor_id == vendor_id &&
        other.price == price &&
        other.status == status &&
        other.counter == counter &&
        other.product == product;
  }

  @override
  int get hashCode {
    return bidId.hashCode ^
        user_id.hashCode ^
        product_id.hashCode ^
        vendor_id.hashCode ^
        price.hashCode ^
        status.hashCode ^
        counter.hashCode ^
        product.hashCode;
  }
}
