import 'package:laybull_v3/models/categories_model.dart';
import 'package:laybull_v3/models/products_model.dart';


class DashboardModel {
  List<CategoriesModel>? categories;
  List<ProductsModel>? laybullPicks;
  List<ProductsModel>? latest;
  List<ProductsModel>? release;
  List<ProductsModel>? popular;

  DashboardModel({
    this.categories,
    this.laybullPicks,
    this.latest,
    this.release,
    this.popular,
  });

  DashboardModel.fromJson(Map<String, dynamic> json) {
    categories = (json['categories'] as List?)
        ?.map(
            (dynamic e) => CategoriesModel.fromJson(e as Map<String, dynamic>))
        .toList();
    laybullPicks = (json['laybull_picks'] as List?)
        ?.map((dynamic e) => ProductsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    latest = (json['latest'] as List?)
        ?.map((dynamic e) => ProductsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    release = (json['release'] as List?)
        ?.map((dynamic e) => ProductsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    popular = (json['popular'] as List?)
        ?.map((dynamic e) => ProductsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['categories'] = categories?.map((e) => e.toJson()).toList();
    json['laybull_picks'] = laybullPicks?.map((e) => e.toJson()).toList();
    json['latest'] = latest?.map((e) => e.toJson()).toList();
    json['release'] = release?.map((e) => e.toJson()).toList();
    json['popular'] = popular?.map((e) => e.toJson()).toList();
    return json;
  }
}
