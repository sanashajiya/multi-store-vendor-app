import 'dart:convert';

class Category {
  final String id;
  final String name;
  final String image;
  final String banner;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.banner,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'banner': banner,
    };
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      banner: map['banner'] ?? '',
    );
  }


  // ✅ Fix: This should accept a Map, not a String
  // factory Category.fromJson(Map<String, dynamic> json) => Category.fromMap(json);
}
