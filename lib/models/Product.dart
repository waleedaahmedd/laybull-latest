// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

class Product {
  int categoryId;
  int id;
  String featureImage;
  int vendorId;
  List<dynamic> images;
  String type;
  int brandId;
  String status;
  String popular;
  String name;
  String price;
  String color;
  String size;
  String condition;
  String discount;
  String originalPrice;
  String tags;
  String pusblish;
  String payment;
  String warrenty;
  String shortDesc;
  String fulldesc;
  bool isFavourite;
  String bidPrice;
  String updatedAt;
  String vendorName;

  Product({
    required this.categoryId,
    required this.id,
    required this.brandId,
    required this.vendorId,
    required this.type,
    required this.status,
    required this.popular,
    required this.name,
    required this.price,
    required this.featureImage,
    required this.discount,
    required this.originalPrice,
    required this.images,
    required this.tags,
    required this.pusblish,
    required this.shortDesc,
    required this.fulldesc,
    required this.payment,
    required this.warrenty,
    required this.color,
    this.isFavourite = false,
    required this.size,
    required this.condition,
    required this.bidPrice,
    required this.updatedAt,
    required this.vendorName,
  });

  factory Product.fromJson(Map<String, dynamic> jsonData) {
    return Product(
      id: jsonData['id'],
      categoryId: jsonData['category_id'],
      brandId: jsonData['brand_id'],
      vendorId: jsonData['vendor_id'],
      type: jsonData["type"],
      status: jsonData['status'],
      popular: jsonData['popular'],
      name: jsonData['name'],
      price: jsonData['price'],
      featureImage: jsonData["vendorName"] != null
          ? jsonData['feature_image']
          : "uploads/productImages/${jsonData['feature_image']}",
      images: jsonData['images'] != null ? jsonData['images'] : [""],
      color: jsonData['color'],
      size: jsonData["size"],
      condition: jsonData["condition"],
      discount: jsonData['discount'],
      originalPrice: jsonData['original_price'],
      tags: jsonData['tags'],
      pusblish: jsonData['pusblish'],
      shortDesc: jsonData['short_desc'] ?? "",
      fulldesc: jsonData['fulldesc'] ?? "",
      payment: jsonData['payment'],
      warrenty: jsonData['warrenty'],
      isFavourite: jsonData["likes"] == null
          ? false
          : jsonData["likes"]["is_like"] == 1
              ? true
              : false,
      bidPrice: jsonData["bid_price"] ?? "",
      updatedAt: jsonData["updated_at"] ?? "",
      vendorName: jsonData["vendorName"] != null
          ? jsonData["vendorName"]
          : jsonData["user"] != null
              ? jsonData["user"]["name"]
              : "",
    );
  }

  static Map<String, dynamic> toMap(Product cart) => {
        'category_id': cart.categoryId,
        'id': cart.id,
        'brand_id': cart.brandId,
        'vendor_id': cart.vendorId,
        'type': cart.type,
        'status': cart.status,
        'popular': cart.popular,
        'name': cart.name,
        'price': cart.price,
        'feature_image': cart.featureImage,
        'discount': cart.discount,
        "images": cart.images,
        'original_price': cart.originalPrice,
        'tags': cart.tags,
        'pusblish': cart.pusblish,
        'short_desc': cart.shortDesc,
        'fulldesc': cart.fulldesc,
        'payment': cart.payment,
        'warrenty': cart.warrenty,
        'color': cart.color,
        'isFavourite': cart.isFavourite,
        "updated_at": cart.updatedAt,
        "vendorName": cart.vendorName,
        "condition": cart.condition,
        "size": cart.size,
      };
  static String encodeMusics(List<Product> cart) {
    return json.encode(
      cart.map<Map<dynamic, dynamic>>((music) => Product.toMap(music)).toList(),
    );
  }

  static List<Product> decodeMusics(String musics) {
    if (musics != null) {
      return (json.decode(musics) as List<dynamic>)
          .map<Product>((item) => Product.fromJson(item))
          .toList();
    } else {
      // return new List();
      return [];
    }
  }
}
