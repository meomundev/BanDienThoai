import 'package:app_api/app/model/api.dart';
import 'package:app_api/app/model/category.dart';
import 'package:app_api/other/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/helper/category_helper.dart';

class CategoryAdd extends StatefulWidget {
  final bool isUpdate;
  final CategoryModel1? categoryModel;
  const CategoryAdd({super.key, this.isUpdate = false, this.categoryModel});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  String titleText = "";
  final DatabaseHelper _databaseService = DatabaseHelper();

  void pasteImageURL() async {
    // Lấy dữ liệu từ clipboard và gán vào TextEditingController
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    print('Thong tin hinh: ${clipboardData!.text}');
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        _imageController.text = clipboardData.text!;
      });
    }
  }

  void clearImageURL() {
    setState(() {
      _imageController.text = widget.categoryModel!.imageUrl.toString();
    });
  }

  Future<void> _onSave() async {
    final name = _nameController.text;
    final description = _descController.text;
    final imageurl = _imageController.text;
    CategoryModel1 categoryModel = CategoryModel1(
        name: name, description: description, imageUrl: imageurl);

    // Lưu trên API
    bool check = await APIRepository().addUpdateCategory(categoryModel, false);
    if (check == true) {
      print('Thêm category thành công');
      setState(() {});
      Navigator.pop(context);
    } else
      print('Thêm category không thành công');
  }

  Future<void> _onUpdate() async {
    final name = _nameController.text;
    final description = _descController.text;
    final imageurl = _imageController.text;
    CategoryModel1 categoryModel = CategoryModel1(
      id: widget.categoryModel!.id,
      name: name,
      description: description,
      imageUrl: imageurl,
    );
    // Cập nhật tên sql lite
    // await _databaseService.updateCategory(CategoryModel(
    //     name: name, desc: description, id: widget.categoryModel!.id));

    // Cập nhật lên API
    bool check = await APIRepository().addUpdateCategory(categoryModel, true);
    if (check == true) {
      print('Cập nhật category thành công');
      setState(() {});
      Navigator.pop(context);
    } else
      print('Cập nhật category không thành công');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.categoryModel != null && widget.isUpdate) {
      _nameController.text = widget.categoryModel!.name;
      _descController.text = widget.categoryModel!.description;
      _imageController.text = widget.categoryModel!.imageUrl.toString();
    }
    if (widget.isUpdate) {
      titleText = "Update Category";
    } else
      titleText = "Add New Category";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainAppWhite,
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 8,
              ),
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
                    child: _imageController.text.isEmpty
                        ? Center(
                            child: Text(
                              'Image',
                              style: TextStyle(
                                color: greyLightColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          )
                        : Image.network(
                            _imageController.text,
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
              SizedBox(height: 20.0),
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
              const SizedBox(height: 8.0),
              Text(
                'Name caterogy',
                style: TextStyle(color: orangeLight, fontSize: 18),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter name category',
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
              const SizedBox(height: 8),
              Text(
                'Description category',
                style: TextStyle(color: orangeLight, fontSize: 18),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: TextFormField(
                  maxLines: 5,
                  controller: _descController,
                  decoration: InputDecoration(
                    hintText: 'Enter description category',
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
              const SizedBox(height: 24),
              SizedBox(
                height: 45.0,
                child: ElevatedButton.icon(
                  onPressed: () {
                    widget.isUpdate ? _onUpdate() : _onSave();
                  },
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: blueDark,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
