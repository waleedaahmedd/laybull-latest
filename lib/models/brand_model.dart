import 'dart:convert';

class Brand {
  String name;
  String image;
  bool isSelected;
  int? id;

  Brand({
    required this.name,
    required this.image,
    required this.isSelected,
    this.id,
  });

  Brand copyWith({
    String? name,
    String? image,
    bool? isSelected,
    int? id,
  }) {
    return Brand(
      name: name ?? this.name,
      image: image ?? this.image,
      isSelected: isSelected ?? this.isSelected,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'isSelected': isSelected,
      'id': id,
    };
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      isSelected: map['isSelected'] ?? false,
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Brand.fromJson(String source) => Brand.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Brand(name: $name, image: $image, isSelected: $isSelected, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Brand &&
        other.name == name &&
        other.image == image &&
        other.isSelected == isSelected &&
        other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^ image.hashCode ^ isSelected.hashCode ^ id.hashCode;
  }
}

// // List<Brand> brands = [];

// List<Brand> brands = [
//   Brand(
//     id: 1,
//     name: "Adidas",
//     isSelected: false,
//     image: "assets/1.jpg",
//   ),
//   Brand(
//     id: 2,
//     name: "Anti Social Social Club",
//     isSelected: false,
//     image: "assets/2.jpg",
//   ),
//   Brand(
//     id: 3,
//     name: "Bape",
//     isSelected: false,
//     image: "assets/3.jpg",
//   ),
//   Brand(
//     id: 4,
//     name: "Bearbrick",
//     isSelected: false,
//     image: "assets/4.jpg",
//   ),
//   Brand(
//     id: 5,
//     name: "Cactus Jack",
//     isSelected: false,
//     image: "assets/5.jpg",
//   ),
//   Brand(
//     id: 6,
//     name: "Dior",
//     isSelected: false,
//     image: "assets/6.jpg",
//   ),
//   Brand(
//     id: 7,
//     name: "Fear of God",
//     isSelected: false,
//     image: "assets/7.jpg",
//   ),
//   Brand(
//     id: 8,
//     name: "Jordan",
//     isSelected: false,
//     image: "assets/8.jpg",
//   ),
//   Brand(
//     id: 9,
//     name: "Off-White",
//     isSelected: false,
//     image: "assets/9.jpg",
//   ),
//   Brand(
//     id: 10,
//     name: "Sacai",
//     isSelected: false,
//     image: "assets/10.jpg",
//   ),
//   Brand(
//     id: 12,
//     name: "Louis Vuitton",
//     isSelected: false,
//     image: "assets/11.jpg",
//   ),
//   Brand(
//     id: 13,
//     name: "Nike",
//     isSelected: false,
//     image: "assets/12.jpg",
//   ),
//   Brand(
//     id: 14,
//     name: "Supreme",
//     isSelected: false,
//     image: "assets/13.jpg",
//   ),
//   Brand(
//     id: 14,
//     name: "Yeezy",
//     isSelected: false,
//     image: "assets/14.jpg",
//   ),
// ];
