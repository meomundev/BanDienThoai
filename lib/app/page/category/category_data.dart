import 'package:app_api/app/model/api.dart';
import 'package:app_api/app/model/category.dart';
import 'package:app_api/mainpage.dart';
import 'package:app_api/other/color.dart';
import 'package:flutter/material.dart';

import 'category_add.dart';

class CategoryBuilder extends StatefulWidget {
  const CategoryBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryBuilder> createState() => _CategoryBuilderState();
}

class _CategoryBuilderState extends State<CategoryBuilder> {
  Future<List<CategoryModel1>> _getCategorys() async {
    return await APIRepository().getCategory();
  }

  Future<void> _onDelete(int id) async {
    bool check = await APIRepository().deleteCategory(id);
    if (check == true) {
      setState(() {});
    } else {
      print('Xóa không thành công');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModel1>>(
      future: _getCategorys(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          color: mainAppGrey,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                CategoryModel1 itemCat = snapshot.data![index];
                return _buildCategory(itemCat, context);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategory(CategoryModel1 breed, BuildContext context) {
    return Card(
      elevation: 2, // Màu nền của card
      shadowColor: blueDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      surfaceTintColor: transparentColor,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          print('Bạn vừa chọn danh mục ${breed.id}');
          _onCategorySelected(context, breed.id!);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: breed.imageUrl != null
                        ? Image.network(
                            breed.imageUrl!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image,
                                size: 40,
                                color: greyLightColor,
                              );
                            },
                          )
                        : Icon(
                            Icons.image,
                            size: 50,
                            color: greyLightColor,
                          ),
                  ),
                ],
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      breed.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: mainAppBlack,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      breed.description,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: greyColorForText,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  _onDelete(breed.id!);
                },
                icon: Icon(
                  Icons.delete,
                  color: blueDark,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => CategoryAdd(
                            isUpdate: true,
                            categoryModel: breed,
                          ),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => setState(() {}));
                },
                icon: Icon(
                  Icons.edit,
                  color: blueDark,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _onCategorySelected(BuildContext context, int catID) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Mainpage(selectedCategory: catID),
    ),
  );
}
