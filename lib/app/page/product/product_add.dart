import 'package:app_api/app/data/helper/category_helper.dart';
import 'package:app_api/app/data/helper/product_helper.dart';
import 'package:app_api/app/model/api.dart';
import 'package:app_api/app/model/category.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/other/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Import NumberFormat from intl package

class ProductAdd extends StatefulWidget {
  final bool isUpdate;
  final ProductModel? productModel;
  const ProductAdd({super.key, this.isUpdate = false, this.productModel});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final DatabaseHelper _databaseCategory = DatabaseHelper();
  final DatabaseProduct _databaseProduct = DatabaseProduct();

  String titleText = '';
  final TextEditingController productName = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController? productType = TextEditingController();
  TextEditingController imageUrl = TextEditingController();

  int priceText = 0;
  CategoryModel1? selectedCategory;

  final currencyFormat = NumberFormat("#,##0", "vi_VN");
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageUrl.text = pickedFile.path;
      });
    }
  }

  List<CategoryModel1> categories = []; // Danh sách loại sản phẩm

  Future<void> _loadCategories() async {
    try {
      // Lấy danh sách category từ SQL lite
      // List<CategoryModel> loadedCategories =
      //     await _databaseCategory.categories();
      // setState(() {
      //   categories = loadedCategories;
      // });

      // Lấy danh sách category từ API
      List<CategoryModel1> loadedCategories =
          await APIRepository().getCategory();
      setState(() {
        categories = loadedCategories;
      });
    } catch (error) {
      print('Error loading categories: $error');
      // Xử lý lỗi tải dữ liệu
    }
  }

  Future<void> _onSave() async {
    final name = productName.text;
    final price1 = int.tryParse(price.text);
    final image = imageUrl.text;
    final catID = int.tryParse(productType!.text);
    final desSription = description.text;

    // Thêm dữ liệu vào sql lite
    // await _databaseProduct.insertProduct(ProductModel(
    //     name: name,
    //     price: price1,
    //     img: image,
    //     catId: catID,
    //     desc: desSription));
    ProductModel productModel = ProductModel(
        name: name, price: price1, img: image, catId: catID, desc: desSription);
    bool check = await APIRepository().addUpdateProduct(productModel, false);
    if (check == true) {
      print('Thêm product thành công');
      setState(() {});
      Navigator.pop(context);
    } else
      print('Thêm product không thành công');
  }

  Future<void> _onUpdate() async {
    // Cập nhật từ SQL lite
    // await _databaseProduct.updateProduct(ProductModel(
    //     catId: int.parse(productType!.text),
    //     img: imageUrl.text,
    //     price: int.parse(price.text),
    //     name: productName.text,
    //     desc: description.text,
    //     id: widget.productModel!.id));
    // Cập nhật từ API
    bool check = await APIRepository().addUpdateProduct(
        ProductModel(
            catId: int.parse(productType!.text),
            img: imageUrl.text,
            price: int.parse(price.text),
            name: productName.text,
            desc: description.text,
            id: widget.productModel!.id),
        true);
    if (check == true) {
      print('Cập nhật product thành công');
      Navigator.pop(context);
    } else {
      print('Cập nhật product không thành công');
    }
  }

  void pasteImageURL() async {
    // Lấy dữ liệu từ clipboard và gán vào TextEditingController
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    print('Thong tin hinh: ${clipboardData!.text}');
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        imageUrl.text = clipboardData.text!;
      });
    }
  }

  void clearImageURL() {
    setState(() {
      imageUrl.text = widget.productModel!.img.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.productModel != null && widget.isUpdate) {
      productName.text = widget.productModel!.name.toString();
      price.text = widget.productModel!.price.toString();
      description.text = widget.productModel!.desc.toString();
      productType!.text = widget.productModel!.catId.toString();

      imageUrl.text = widget.productModel!.img.toString();
      priceText = widget.productModel!.price!;
    }
    if (widget.isUpdate) {
      titleText = "Update product ${productName.text}";
    } else {
      titleText = "Add new product";
    }

    _loadCategories().then((_) {
      if (widget.isUpdate && widget.productModel != null) {
        setState(() {
          selectedCategory = categories.firstWhere(
            (category) => category.id == widget.productModel!.catId,
          ) as CategoryModel1?;
        });
      }
    }); // Gọi hàm tải dữ liệu khi màn hình được khởi tạo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleText,
          style: TextStyle(
            color: orangeLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: blueDark,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: mainAppWhite,
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 260,
                    height: 260.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: blueDark, style: BorderStyle.solid, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: imageUrl.text.isEmpty
                        ? Center(
                            child: Text(
                              'image',
                              style: TextStyle(
                                color: greyLightColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          )
                        : Image.network(
                            imageUrl.text,
                            fit: BoxFit.contain,
                          ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.paste),
                      onPressed: pasteImageURL,
                      tooltip: 'Dán đường link ảnh',
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.clear_rounded),
                      onPressed: clearImageURL,
                      tooltip: 'Xóa hình ảnh',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: blueDark,
                      margin: EdgeInsets.only(right: 10),
                    ),
                  ),
                  Text(
                    'Infomation',
                    style: TextStyle(
                        fontSize: 24,
                        color: blueDark,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: blueDark,
                      margin: EdgeInsets.only(left: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                'Name product',
                style: TextStyle(color: orangeLight, fontSize: 18),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: TextFormField(
                  controller: productName,
                  decoration: InputDecoration(
                    hintText: 'Enter name product',
                    hintStyle: TextStyle(color: greyLightColor, fontSize: 14),
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueDark, width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueDark, width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: error, width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    errorStyle: TextStyle(
                      color: error,
                    ),
                  ),
                  style: TextStyle(color: blueDark),
                  cursorColor: blueDark,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                initialValue: formatPrice(priceText),
                decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: TextStyle(
                        color: greyLightColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueDark, width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueDark, width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                    suffixIcon: Icon(Icons.monetization_on),
                    hintText: 'Price',
                    hintStyle: TextStyle(color: greyLightColor, fontSize: 14)),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _CurrencyTextInputFormatter(),
                ],
                onChanged: (value) {
                  // Chuyển đổi giá trị nhận được sang kiểu double
                  final intValue = int.tryParse(value.replaceAll('.', ''));
                  print(intValue!);
                  setState(() {
                    // Cập nhật price với giá trị double, sử dụng ?? để xử lý trường hợp null
                    price.text = intValue.toString() ??
                        '0'; // Mặc định là 0.0 nếu không thể parse
                  });
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Description product',
                style: TextStyle(color: orangeLight, fontSize: 18),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: TextFormField(
                  maxLines: 3,
                  controller: description,
                  decoration: InputDecoration(
                    hintText: 'Enter description product',
                    hintStyle: TextStyle(color: greyLightColor, fontSize: 14),
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueDark, width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueDark, width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: error, width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    errorStyle: TextStyle(
                      color: error,
                    ),
                  ),
                  style: TextStyle(color: blueDark),
                  cursorColor: blueDark,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select product type',
                style: TextStyle(color: orangeLight, fontSize: 18),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<CategoryModel1>(
                value: selectedCategory,
                onChanged: (CategoryModel1? value) {
                  setState(() {
                    selectedCategory = value!;
                    productType!.text = selectedCategory!.id.toString();
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<CategoryModel1>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                decoration: InputDecoration(
                  // labelText: 'Select product type',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: blueDark, width: 1.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: blueDark, width: 1.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  suffixIcon: Icon(Icons.category),
                  hintText: 'Select product type',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  ProductModel productModel1 = ProductModel(
                      name: productName.text,
                      catId: selectedCategory!.id,
                      desc: description.text,
                      img: imageUrl.text,
                      price: int.parse(price.text),
                      id: widget.isUpdate ? widget.productModel!.id : null);
                  print(productModel1);
                  widget.isUpdate ? _onUpdate() : _onSave();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: blueDark,
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  !widget.isUpdate ? 'Add product' : 'Update  product',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatPrice(int value) {
  final formatter = NumberFormat("#,###", "vi_VN");
  return formatter.format(value);
}

class _CurrencyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    int value = int.parse(newValue.text.replaceAll(',', ''));
    final formatter = NumberFormat("#,###", "vi_VN");
    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
