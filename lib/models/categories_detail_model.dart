import 'dart:convert';

import 'package:laybull_v3/models/categories_model.dart';
import 'package:laybull_v3/models/products_model.dart';

class CategoryDetail {
  int? id;
  String? name;
  String? image;
  List<ProductsModel> products;
  CategoryDetail({
    this.id,
    this.name,
    this.image,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'products': products.map((x) => x.toJson()).toList(),
    };
  }

  factory CategoryDetail.fromMap(Map<String, dynamic> map) {
    return CategoryDetail(
      id: map['id'] as int?,
      name: map['name'] as String?,
      image: map['image'] as String?,
      products: List<ProductsModel>.from(
          map['products']?.map((x) => ProductsModel.fromJson(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryDetail.fromJson(Map<String, dynamic> source) =>
      CategoryDetail.fromMap(source);
}
