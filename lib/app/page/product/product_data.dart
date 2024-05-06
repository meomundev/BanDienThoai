import 'package:app_api/app/model/api.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/app/model/product_viewmodel.dart';
import 'package:app_api/app/page/product/product_add.dart';
import 'package:app_api/mainpage.dart';
import 'package:app_api/other/color.dart';
import 'package:app_api/other/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductBuilder extends StatefulWidget {
  final int? brandId;
  const ProductBuilder({super.key, this.brandId});

  @override
  State<ProductBuilder> createState() => _ProductBuildertState();
}

class _ProductBuildertState extends State<ProductBuilder> {
  // final DatabaseProduct _databaseProduct = DatabaseProduct();

  Future<List<ProductModel>> _getProducts() async {
    if (widget.brandId != null) {
      // Lấy thông tin product từ SQL lite
      // return await _databaseProduct
      //     .findProductId(int.parse(widget.brandId.toString()));
      // Lấy thông tin product từ API
      return await APIRepository().getProduct(widget.brandId);
    }

    // Lấy thông tin product từ SQL lite
    //return await _databaseProduct.products();

    // Lấy thông tin product từ API
    return await APIRepository().getProduct(widget.brandId);
  }

  Future<void> _onDelete(int id) async {
    bool check = await APIRepository().deleteProduct(id);
    if (check == true) {
      setState(() {});
    } else {
      print('Xóa product không thành công');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLiked = false;
    return FutureBuilder<List<ProductModel>>(
      future: _getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          color: mainAppGrey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final itemPro = snapshot.data![index];
                return _buildCategory(itemPro,
                    context); // Replace with your updated buildProductCard method
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategory(ProductModel product, BuildContext context) {
    // Kiểm tra xem sản phẩm đã thích chưa
    return Card(
      elevation: 2, // Màu nền của card
      shadowColor: blueDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      surfaceTintColor: transparentColor,
      color: Colors.white,
      child: InkWell(
        // onTap: () {
        //   print('Bạn vừa nhấn vào category ${product.name} này!');
        // },
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
                      Consumer<ProductVM>(
                        builder: (context, value, child) {
                          bool isLiked = value.lstFavorite
                              .any((element) => element.id == product.id);
                          return Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                alignment: Alignment.center,
                                child: Image.network(
                                  product.img!,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              // Positioned(
                              //   top: 0,
                              //   left: -6,
                              //   child: IconButton(
                              //     onPressed: () {
                              //       print('Bạn vừa nhấn nút thả tym');
                              //       value.addOrRemoveFavorites(product);
                              //     },
                              //     icon: Icon(
                              //       isLiked
                              //           ? Icons.favorite
                              //           : Icons.favorite_border,
                              //       color: isLiked ? Colors.red : null,
                              //       size: 20,
                              //     ),
                              //   ),
                              // ),
                              // Các widget khác trong Stack
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name!, // Product title
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: orangeLight),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatCurrency(
                                      product.price!), // Current price
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: error,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            _onDelete(product.id!);
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: blueDark,
                          size: 20,
                        )),
                  ),
                  Consumer<ProductVM>(
                    builder: (context, value, child) => Positioned(
                      right: 0,
                      bottom: 35,
                      child: IconButton(
                          onPressed: () {
                            // setState(() {
                            //   // DatabaseProduct().deleteProduct(product.id!);
                            // });
                            print('Bạn vừa nhấn nút add');
                            value.add(product);
                          },
                          icon: Icon(
                            Icons.add_shopping_cart,
                            color: blueDark,
                            size: 20,
                          )),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => ProductAdd(
                                      isUpdate: true,
                                      productModel: product,
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                )
                                .then((_) => setState(() {}));
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: blueDark,
                          size: 20,
                        )),
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

void _onProductSelected(BuildContext context, int catID) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Mainpage(selectedCategory: catID),
    ),
  );
}
