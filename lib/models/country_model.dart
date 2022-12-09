// class CountryModel {
//   final int? countryId;
//   final String? countryName;
//   final String? countryCurrencyLabel;
//   final double? shippingPrice;
//   final double? priceDifference;
//   final String? countryISOCode;

//   CountryModel(
//       {this.countryId,
//       this.countryName,
//       this.shippingPrice,
//       this.countryCurrencyLabel,
//       this.priceDifference,
//       this.countryISOCode});

//   factory CountryModel.fromJson(Map<String, dynamic> json) {
//     return CountryModel(
//       countryId: json['id'],
//       countryName: json["country_name"],
//       shippingPrice: double.parse(json["country_scharges"].toString()),
//       countryCurrencyLabel: json["country_sname"],
//       countryISOCode: json["country_code"],
//       priceDifference: double.parse(json["price_with"].toString()),
//     );
//   }
// }

// List<CountryModel> listCountry = [];

class CountryModel {
  String? name;
  String? countryCode;

  CountryModel({
    this.name,
    this.countryCode,
  });

  CountryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    countryCode = json['country_code'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['country_code'] = countryCode;
    return json;
  }
}
