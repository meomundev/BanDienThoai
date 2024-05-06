class OrderDetaileModel {
  int productId;
  String productName;
  String? imageUrl;
  int price;
  int count;
  int total;

  OrderDetaileModel({
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.price,
    required this.count,
    required this.total,
  });

  factory OrderDetaileModel.fromJson(Map<String, dynamic> json) =>
      OrderDetaileModel(
        productId: json["productID"],
        productName: json["productName"],
        imageUrl: json["imageURL"],
        price: json["price"],
        count: json["count"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "productID": productId,
        "productName": productName,
        "imageURL": imageUrl,
        "price": price,
        "count": count,
        "total": total,
      };
}
