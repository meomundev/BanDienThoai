import 'dart:convert';

class ProductModel {
  int? id;
  String? name;
  int? price;
  String? img;
  String? desc;
  int? catId;
  String? categoryName;
  int? quantity;
  bool? isLike;
  //constructor
  ProductModel(
      {this.id,
      this.name,
      this.price,
      this.img,
      this.desc,
      this.catId,
      this.categoryName,
      this.quantity = 1,
      this.isLike = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'img': img,
      'desc': desc,
      'catId': catId
    };
  }

  // Dành cho SQL lite
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      price: map['price']?.toInt() ?? 0,
      img: map['img'] ?? '',
      desc: map['desc'] ?? '',
      catId: map['catId']?.toInt() ?? 0,
    );
  }
  // Dành cho API
  factory ProductModel.fromJson1(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        desc: json["description"],
        img: json["imageURL"],
        price: json["price"],
        catId: json["categoryID"],
        categoryName: json["categoryName"],
      );

  String toJson() => json.encode(toMap());
  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
  @override
  String toString() =>
      'ProductModel(id: $id, name: $name,price:$price,img:$img ,desc: $desc,catId:$catId)';
}
