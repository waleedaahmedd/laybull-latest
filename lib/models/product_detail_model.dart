// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:laybull_v3/models/user_model.dart';

class ProductDetail {
  int? id;
  String? category;
  String? brand;
  String? name;
  double? price;
  String? color;
  String? size;
  String? condition;
  String? description;
  int? discount;
  bool? favourite;
  int? sold;
  String? featuredImage;
  double? highestBid;
  List<ProductDetailImageClass>? images;
  UserModel? user;

  ProductDetail({
    this.id,
    this.category,
    this.brand,
    this.name,
    this.price,
    this.color,
    this.size,
    this.condition,
    this.favourite,
    this.description,
    this.discount,
    this.sold,
    this.featuredImage,
    this.highestBid,
    this.images,
    this.user,
  });

  ProductDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    category = json['category'] as String? ?? '';
    brand = json['brand'] as String? ?? '';
    name = json['name'] as String? ?? '';
    favourite = json['favourite'] as bool? ?? false;
    price =
        json['price'] != null ? double.parse(json['price'].toString()) : 0.0;
    color = json['color'] as String? ?? '';
    size = json['size'] as String? ?? '';
    condition = json['condition'] as String? ?? '';
    description = json['description'] as String? ?? '';
    discount = json['discount'] as int? ?? 0;
    sold = json['sold'] as int? ?? 0;
    featuredImage = json['featured_image'] as String? ?? '';
    highestBid = double.parse(
        json['highest_bid'] != null ? json['highest_bid'].toString() : '0.0');
    images = json['images'] != null
        ? List<ProductDetailImageClass>.from(
            (json['images'] as List<dynamic>).map<ProductDetailImageClass?>(
              (x) => ProductDetailImageClass.fromMap(x as Map<String, dynamic>),
            ),
          )
        : null;
    //  (json['images'] as List?)
    //     ?.map((dynamic e) => e as ProductDetailImageClass)
    //     .toList();
    user = json['user'] != null ? UserModel.fromMap(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['category'] = category;
    json['brand'] = brand;
    json['name'] = name;
    json['price'] = price;
    json['color'] = color;
    json['size'] = size;
    json['favourite'] = favourite;
    json['condition'] = condition;
    json['description'] = description;
    json['discount'] = discount;
    json['sold'] = sold;
    json['featured_image'] = featuredImage;
    json['highest_bid'] = highestBid;
    json['images'] = images;
    json['user'] = user?.toMap();
    return json;
  }
}

class ProductDetailImageClass {
  int? id;
  String? images;
  ProductDetailImageClass({
    this.id,
    this.images,
  });

  ProductDetailImageClass copyWith({
    int? id,
    String? url,
  }) {
    return ProductDetailImageClass(
      id: id ?? this.id,
      images: url ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'url': images,
    };
  }

  factory ProductDetailImageClass.fromMap(Map<String, dynamic> map) {
    return ProductDetailImageClass(
      id: map['id'] != null ? map['id'] as int : null,
      images: map['images'] != null ? map['images'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDetailImageClass.fromJson(String source) =>
      ProductDetailImageClass.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProductDetailImageClass(id: $id, url: $images)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductDetailImageClass &&
        other.id == id &&
        other.images == images;
  }

  @override
  int get hashCode => id.hashCode ^ images.hashCode;
}
