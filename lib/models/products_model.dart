// ignore_for_file: non_constant_identifier_names

class ProductsModel {
  int? id;
  int? category_id;
  int? brand_id;
  String? name;
  double? price;
  String? category;
  String? color;
  int? size_id;
  String? size;

  String? release_date;
  String? condition;
  String? description;
  int? discount;
  int? sold;
  String? feature_image;
  bool? isFav;

  ProductsModel({
    this.id,
    this.category_id,
    this.brand_id,
    this.name,
    this.size,
    this.price,
    this.release_date,
    this.color,
    this.size_id,
    this.condition,
    this.description,
    this.category,
    this.discount,
    this.sold,
    this.feature_image,
    this.isFav,
  });

  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    category_id = json['category_id'] as int?;
    category = json['category'] as String? ?? '';
    release_date =
        json['release_date'] == null ? null : json['release_date'] as String?;
    brand_id = json['brand_id'] as int? ?? 0;
    name = json['name'] as String? ?? '';
    price =
        json['price'] != null ? double.parse(json['price'].toString()) : 0.0;
    color = json['color'] as String? ?? '';
    size_id = json['size_id'] as int? ?? 0;
    condition = json['condition'] as String? ?? '';
    description = json['description'] as String? ?? '';
    size = json['size'] as String? ?? '';
    discount = json['discount'] as int?;
    sold = json['sold'] as int? ?? 0;
    isFav = json['favourite'] as bool? ?? false;
    feature_image = json['featured_image'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['category_id'] = category_id;
    json['brand_id'] = brand_id;
    json['name'] = name;
    json['release_date'] = release_date;
    json['price'] = price;
    json['color'] = color;
    json['size_id'] = size_id;
    json['category'] = category;
    json['condition'] = condition;
    json['description'] = description;
    json['discount'] = discount;
    json['sold'] = sold;
    json['favourite'] = isFav;
    json['feature_image'] = feature_image;
    return json;
  }
}
