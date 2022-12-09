// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ShippingModel {
  String? address;
  String? city;
  String? country;
  String? phone_number;
  ShippingModel({
    this.address,
    this.city,
    this.country,
    this.phone_number,
  });

  ShippingModel copyWith({
    String? address,
    String? city,
    String? country,
    String? phone_number,
  }) {
    return ShippingModel(
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      phone_number: phone_number ?? this.phone_number,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'city': city,
      'country': country,
      'phone_number': phone_number,
    };
  }

  factory ShippingModel.fromMap(Map<String, dynamic> map) {
    return ShippingModel(
      address: map['address'] != null ? map['address'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      phone_number:
          map['phone_number'] != null ? map['phone_number'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShippingModel.fromJson(String source) =>
      ShippingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ShippingModel(address: $address, city: $city, country: $country, phone_number: $phone_number)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShippingModel &&
        other.address == address &&
        other.city == city &&
        other.country == country &&
        other.phone_number == phone_number;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        city.hashCode ^
        country.hashCode ^
        phone_number.hashCode;
  }
}
