// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HomeCategoryModel {
  int? id;
  String? featured_image;
  String? name;
  String? condition;
  String? size;
  double? price;
  HomeCategoryModel({
    this.id,
    this.featured_image,
    this.name,
    this.condition,
    this.size,
    this.price,
  });

  HomeCategoryModel copyWith({
    int? id,
    String? featured_image,
    String? name,
    String? condition,
    String? size,
    double? price,
  }) {
    return HomeCategoryModel(
      id: id ?? this.id,
      featured_image: featured_image ?? this.featured_image,
      name: name ?? this.name,
      condition: condition ?? this.condition,
      size: size ?? this.size,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'featured_image': featured_image,
      'name': name,
      'condition': condition,
      'size': size,
      'price': price,
    };
  }

  factory HomeCategoryModel.fromMap(Map<String, dynamic> map) {
    return HomeCategoryModel(
      id: map['id'] != null ? map['id'] as int : null,
      featured_image: map['featured_image'] != null ? map['featured_image'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      condition: map['condition'] != null ? map['condition'] as String : null,
      size: map['size'] != null ? map['size'] as String : null,
      price: map['price'] != null ? map['price'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeCategoryModel.fromJson(String source) =>
      HomeCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HomeCategoryModel(id: $id, featured_image: $featured_image, name: $name, condition: $condition, size: $size, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is HomeCategoryModel &&
      other.id == id &&
      other.featured_image == featured_image &&
      other.name == name &&
      other.condition == condition &&
      other.size == size &&
      other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      featured_image.hashCode ^
      name.hashCode ^
      condition.hashCode ^
      size.hashCode ^
      price.hashCode;
  }
}
