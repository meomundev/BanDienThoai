import 'dart:convert';

import 'package:app_api/app/model/category.dart';
import 'package:app_api/app/model/order.dart';
import 'package:app_api/app/model/orderDetail.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/app/model/register.dart';
import 'package:app_api/app/model/sharepre.dart';
import 'package:app_api/app/model/user.dart';
import 'package:dio/dio.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "https://huflit.id.vn:4321";
  String? authToken; // Biến toàn cục để lưu trữ token
  late User user; // Biến toàn cục để lưu trữ thông tin người dùng

  API() {
    _dio.options.baseUrl = "$baseUrl/api";
  }

  Dio get sendRequest => _dio;
}

class APIRepository {
  API api = API();
  // Hàm kiểm tra và tải thông tin người dùng từ bộ nhớ đệm

  Map<String, dynamic> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
  }

  // Đăng ký tài khoản
  Future<String> register(Signup user) async {
    try {
      final body = FormData.fromMap({
        "numberID": user.numberID,
        "accountID": user.accountID,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "imageURL": user.imageUrl,
        "birthDay": user.birthDay,
        "gender": user.gender,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "password": user.password,
        "confirmPassword": user.confirmPassword
      });
      Response res = await api.sendRequest.post('/Student/signUp',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        print("ok");

        return "ok";
      } else {
        print("fail");
        return "signup fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  // Đăng nhập
  Future<String> login(String accountID, String password) async {
    try {
      final body =
          FormData.fromMap({'AccountID': accountID, 'Password': password});
      Response res = await api.sendRequest.post('/Auth/login',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        final tokenData = res.data['data']['token'];
        print("ok login");

        api.authToken = tokenData;
        return tokenData;
      } else {
        return "login fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  // Lấy thông tin user
  Future<User> current(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Auth/current', options: Options(headers: header(token)));
      return User.fromJson(res.data);
    } catch (ex) {
      rethrow;
    }
  }

  // Đổi mật khẩu
  Future<bool> changePassword(String oldPass, String newPassowrd) async {
    try {
      String token = await getToken();
      String path = '/Auth/ChangePassword';
      print(oldPass + " " + newPassowrd);
      final body = FormData.fromMap(
        {
          "OldPassword": oldPass,
          "NewPassword": newPassowrd,
        },
      );
      Response res = await api.sendRequest.put(path.toString(),
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("Đổi mật khẩu thành công");
        return true;
      } else {
        print("Đổi mật khẩu không thành công: ${res.statusMessage}");
        return false;
      }
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  // Quên mật khẩu
  Future<bool> forgotPassword(
      String accountID, String numberID, String newPassowrd) async {
    try {
      String token = await getToken();
      final body = FormData.fromMap({
        "accountID": accountID,
        "numberID": numberID,
        "newPass": newPassowrd
      });
      Response res = await api.sendRequest.put('/Auth/forgetPass',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("Đặt lại password thành công");
        return true;
      } else {
        print("Đặt lại password không thành công");
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  // Thêm or cập nhật category
  Future<bool> addUpdateCategory(
      CategoryModel1 categoryModel, bool isUpdate) async {
    try {
      User user = await getUser();
      String token = await getToken();
      String path = isUpdate ? '/updateCategory' : '/addCategory';

      // Tạo dữ liệu yêu cầu
      FormData body;
      if (!isUpdate) {
        body = FormData.fromMap({
          'Name': categoryModel.name,
          'Description': categoryModel.description,
          'ImageURL': categoryModel.imageUrl,
          'AccountID': user.accountId
        });
      } else {
        body = FormData.fromMap({
          'id': categoryModel.id,
          'Name': categoryModel.name,
          'Description': categoryModel.description,
          'ImageURL': categoryModel.imageUrl,
          'AccountID': user.accountId
        });
      }

      if (user.accountId.isNotEmpty) {
        print(body);
        // Gửi yêu cầu API
        Response res = isUpdate
            ? await api.sendRequest.put(
                path,
                options: Options(headers: header(token)),
                data: body,
              )
            : await api.sendRequest.post(
                path,
                options: Options(headers: header(token)),
                data: body,
              );

        // Xử lý phản hồi
        if (res.statusCode == 200) {
          print("Category ${isUpdate ? 'updated' : 'added'} successfully");
          return true;
        } else {
          print(
              "Failed to ${isUpdate ? 'update' : 'add'} category: ${res.statusCode}");
          return false;
        }
      } else {
        print("Unable to execute category data");
        return false;
      }
    } catch (ex) {
      print('Error: $ex');
      return false;
    }
  }

  // Lấy danh sách category
  Future<List<CategoryModel1>> getCategory() async {
    try {
      var path = '/Category/getList';
      User user =
          await getUser(); // Kiểm tra và tải thông tin người dùng từ bộ nhớ đệm
      String token = await getToken();
      // Xây dựng URL với các tham số query
      var uri = Uri.parse(path).replace(queryParameters: {
        'accountID': user.accountId,
      });

      // Gửi yêu cầu API
      Response res = await api.sendRequest
          .get(uri.toString(), options: Options(headers: header(token)));
      // Kiểm tra mã phản hồi
      if (res.statusCode == 200) {
        // Xử lý và trả về dữ liệu
        return List<CategoryModel1>.from(
            res.data.map((item) => CategoryModel1.fromJson(item)));
      } else {
        // Nếu có lỗi, ném ra ngoại lệ
        throw Exception('Failed to load categories: ${res.statusCode}');
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  // Xóa category
  Future<bool> deleteCategory(int idCategory) async {
    try {
      var path = '/removeCategory';
      User user = await getUser();
      String token = await getToken();

      if (user.accountId.isNotEmpty) {
        // Xây dựng URL với các tham số query
        FormData body = FormData.fromMap({
          'categoryID': idCategory,
          'accountID': user.accountId,
        });

        print(body);

        // Gửi yêu cầu API
        Response res = await api.sendRequest.delete(
          path,
          options: Options(headers: header(token)),
          data: body,
        );

        // Xử lý phản hồi
        if (res.statusCode == 200) {
          print("Delete category successfully");
          return true;
        } else {
          print("Failed to delete category: ${res.statusCode}");
          return false;
        }
      } else {
        print("Account Id không được tìm thấy!");
        return false;
      }
    } catch (ex) {
      print('Lỗi: $ex');
      rethrow;
    }
  }

  // API Thêm product
  // Thêm or cập nhật category
  Future<bool> addUpdateProduct(
      ProductModel productModel, bool isUpdate) async {
    try {
      User user = await getUser();
      String token = await getToken();
      String path = isUpdate ? '/updateProduct' : '/addProduct';

      // Tạo dữ liệu yêu cầu
      FormData body;
      if (!isUpdate) {
        body = FormData.fromMap({
          'Name': productModel.name,
          'Description': productModel.desc,
          'ImageURL': productModel.img,
          'Price': productModel.price,
          'CategoryID': productModel.catId
        });
      } else {
        body = FormData.fromMap({
          'id': productModel.id,
          'Name': productModel.name,
          'Description': productModel.desc,
          'ImageURL': productModel.img,
          'Price': productModel.price,
          'CategoryID': productModel.catId,
          'AccountID': user.accountId
        });
      }

      if (user.accountId.isNotEmpty) {
        print(body);
        // Gửi yêu cầu API
        Response res = isUpdate
            ? await api.sendRequest.put(
                path,
                options: Options(headers: header(token)),
                data: body,
              )
            : await api.sendRequest.post(
                path,
                options: Options(headers: header(token)),
                data: body,
              );

        // Xử lý phản hồi
        if (res.statusCode == 200) {
          print("Product ${isUpdate ? 'updated' : 'added'} successfully");
          return true;
        } else {
          print(
              "Failed to ${isUpdate ? 'update' : 'add'} product: ${res.statusCode}");
          return false;
        }
      } else {
        print("Unable to execute product data");
        return false;
      }
    } catch (ex) {
      print('Error: $ex');
      return false;
    }
  }

  // Lấy danh sách product
  Future<List<ProductModel>> getProduct(int? categoryID) async {
    try {
      User user =
          await getUser(); // Kiểm tra và tải thông tin người dùng từ bộ nhớ đệm

      String token = await getToken();
      var path = categoryID == null
          ? '/Product/getList?accountID=${user.accountId}'
          : '/Product/getListByCatId?categoryID=${categoryID}&accountID=${user.accountId}';
      // Xây dựng URL với các tham số query
      // var uri = categoryID == null
      //     ? Uri.parse(path)
      //         .replace(queryParameters: {'accountID': user.accountId})
      //     : Uri.parse(path).replace(
      //         queryParameters: {
      //           'categoryID': categoryID,
      //           'accountID': user.accountId
      //         },
      //       );

      // Gửi yêu cầu API
      Response res = await api.sendRequest
          .get(path.toString(), options: Options(headers: header(token)));
      // Kiểm tra mã phản hồi
      if (res.statusCode == 200) {
        // Xử lý và trả về dữ liệu
        return List<ProductModel>.from(
            res.data.map((item) => ProductModel.fromJson1(item)));
      } else {
        // Nếu có lỗi, ném ra ngoại lệ
        throw Exception('Failed to load products: ${res.statusCode}');
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  // Xóa product
  Future<bool> deleteProduct(int idProduct) async {
    try {
      print(idProduct);
      var path = '/removeProduct';
      User user = await getUser();
      String token = await getToken();

      if (user.accountId.isNotEmpty) {
        // Xây dựng URL với các tham số query
        FormData body = FormData.fromMap({
          'productID': idProduct,
          'accountID': user.accountId,
        });

        print(body);

        // Gửi yêu cầu API
        Response res = await api.sendRequest.delete(
          path,
          options: Options(headers: header(token)),
          data: body,
        );

        // Xử lý phản hồi
        if (res.statusCode == 200) {
          print("Delete product successfully");
          return true;
        } else {
          print("Failed to delete product: ${res.statusCode}");
          return false;
        }
      } else {
        print("Account Id không được tìm thấy!");
        return false;
      }
    } catch (ex) {
      print('Lỗi: $ex');
      rethrow;
    }
  }

  // Thêm danh sách hóa đơn
  Future<bool> addBill(List<ProductModel> lstPro) async {
    try {
      var path = '/Order/addBill';
      // Kiểm tra và tải thông tin người dùng từ bộ nhớ đệm
      String token = await getToken();
      // Xây dựng URL với các tham số query
      // Chuyển đổi danh sách sản phẩm thành chuỗi JSON
      List<Map<String, dynamic>> productList = lstPro
          .map(
              (product) => {"productID": product.id, "count": product.quantity})
          .toList();
      // Gửi yêu cầu API
      Response res = await api.sendRequest.post(
        path,
        data: jsonEncode(productList),
        options: Options(headers: header(token)),
      );
      // Kiểm tra mã phản hồi
      if (res.statusCode == 200) {
        // Xử lý và trả về dữ liệu
        return true;
      } else {
        // Nếu có lỗi, ném ra ngoại lệ
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  // Lấy danh sách hóa đơn
  Future<List<OrderModel>> getBill() async {
    try {
      var path = '/Bill/getHistory';
      // User user =
      //     await getUser(); // Kiểm tra và tải thông tin người dùng từ bộ nhớ đệm
      String token = await getToken();
      // Xây dựng URL với các tham số query
      var uri = Uri.parse(path);
      print(uri);
      // Gửi yêu cầu API
      Response res = await api.sendRequest
          .get(uri.toString(), options: Options(headers: header(token)));
      // Kiểm tra mã phản hồi
      if (res.statusCode == 200) {
        // Xử lý và trả về dữ liệu
        return List<OrderModel>.from(
            res.data.map((item) => OrderModel.fromJson(item)));
      } else {
        // Nếu có lỗi, ném ra ngoại lệ
        throw Exception('Failed to load order : ${res.statusCode}');
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  // Lấy thông tin chi tiết hóa đơn
  // Lấy danh sách hóa đơn
  Future<List<OrderDetaileModel>> getDetaileBill(String billID) async {
    try {
      var path = '/Bill/getByID';
      // User user =
      //     await getUser(); // Kiểm tra và tải thông tin người dùng từ bộ nhớ đệm
      String token = await getToken();
      var uri = Uri.parse(path).replace(queryParameters: {
        'billID': billID,
      });
      // Build the URL with query parameters
      print(billID);
      // Gửi yêu cầu API
      Response res = await api.sendRequest
          .post(uri.toString(), options: Options(headers: header(token)));
      // Kiểm tra mã phản hồi
      if (res.statusCode == 200) {
        // Xử lý và trả về dữ liệu
        print('Lấy thông tin hóa đơn $billID thành công!');
        return List<OrderDetaileModel>.from(
            res.data.map((item) => OrderDetaileModel.fromJson(item)));
      } else {
        // Nếu có lỗi, ném ra ngoại lệ
        throw Exception('Failed to load order : ${res.statusCode}');
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  // Xóa thông tin hóa đơn
  Future<bool> deleteBill(String billID) async {
    try {
      var path = '/Bill/remove';
      User user = await getUser();
      String token = await getToken();

      if (user.accountId.isNotEmpty) {
        // Xây dựng URL với các tham số query
        var uri = Uri.parse(path).replace(queryParameters: {
          'billID': billID,
        });

        // Gửi yêu cầu API
        Response res = await api.sendRequest.delete(
          uri.toString(),
          options: Options(headers: header(token)),
        );

        // Xử lý phản hồi
        if (res.statusCode == 200) {
          print("Delete bill successfully");
          return true;
        } else {
          print("Failed to delete bill: ${res.statusCode}");
          return false;
        }
      } else {
        return false;
      }
    } catch (ex) {
      print('Lỗi: $ex');
      rethrow;
    }
  }
}
