import 'package:app_api/app/page/product/product_add.dart';
import 'package:app_api/app/page/product/product_data.dart';
import 'package:app_api/other/color.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  final int? catID;
  const ProductList({super.key, this.catID});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  void _onItemTapped(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ProductBuilder(
          brandId: widget.catID,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => const ProductAdd(),
                  fullscreenDialog: true,
                ),
              )
              .then((_) => setState(() {}));
        },
        tooltip: 'Add New',
        backgroundColor: blueDark,
        child: Icon(
          Icons.add,
          color: mainAppWhite,
        ),
      ),
    );
  }
}
