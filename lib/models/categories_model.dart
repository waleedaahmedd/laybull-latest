// ignore_for_file: non_constant_identifier_names

class CategoriesModel {
  int? id;
  String? name;
  String? description;
  String? image;
  String? category_to_redirect;

  CategoriesModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.category_to_redirect,
  });

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String? ?? '';
    description = json['description'] as String? ?? '';
    image = json['image'] as String? ?? '';
    category_to_redirect = json['category_to_redirect'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['description'] = description;
    json['image'] = image;
    json['category_to_redirect'] = category_to_redirect;
    return json;
  }
}
