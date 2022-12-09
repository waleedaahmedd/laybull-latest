// ignore_for_file: non_constant_identifier_names

class BidProduct {
  int? id;
  int? userId;
  String? name;
  String? condition;
  int? isSold;
  String? size;
  String? featured_image;

  BidProduct(
      {this.id,
      this.userId,
      this.name,
      this.condition,
      this.isSold,
      this.featured_image,
      this.size});

  BidProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    condition = json['condition'];
    isSold = json['sold'];
    featured_image = json['featured_image'];
    size = json['size_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['condition'] = condition;
    data['featured_image'] = featured_image;
    data['isSold'] = isSold;
    data['size'] = size;
    return data;
  }
}
