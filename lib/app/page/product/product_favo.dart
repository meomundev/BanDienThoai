import 'package:app_api/app/data/helper/product_helper.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/app/model/product_viewmodel.dart';
import 'package:app_api/other/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFavorite extends StatefulWidget {
  ProductFavorite({super.key});

  @override
  State<ProductFavorite> createState() => _ProductFavoriteState();
}

class _ProductFavoriteState extends State<ProductFavorite> {
  final DatabaseProduct _databaseProduct = DatabaseProduct();

  Future<List<ProductModel>> _getProductsFavor() async {
    return await _databaseProduct.products();
  }

  List<ProductModel> itemlst = [];
  ProductModel productModel1 = new ProductModel(
      catId: 1,
      desc: 'Đẹp',
      id: 1,
      img: 'null',
      name: 'Iphone 15',
      price: 150000,
      quantity: 5);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm yêu thích'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProductVM>(
              builder: (context, value, child) => Scaffold(
                body: SafeArea(
                  child: Scaffold(
                    body: ListView.builder(
                        itemCount: value.lstFavorite.length,
                        itemBuilder: (context, index) {
                          return _buildFavorite(
                              value.lstFavorite[index], context);
                        }),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFavorite(ProductModel product, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners for the card
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 120,
                        child: product.img != 'null' &&
                                product.img!
                                    .isNotEmpty // Kiểm tra xem product.img có khác null và không rỗng không
                            ? Image.network(
                                product.img!, // Hình ảnh sản phẩm

                                fit: BoxFit.contain,
                              )
                            : const Icon(Icons
                                .image), // Nếu không có hình ảnh, hiển thị icon mặc định
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name!, // Product title
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatCurrency(
                                      product.price!), // Current price
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .red, // or Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Consumer<ProductVM>(
                    builder: (context, value, child) => Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                          onPressed: () {
                            value.removeFavorite(product);
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
