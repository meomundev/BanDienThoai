import 'package:app_api/app/model/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProduct {
  // Khai báo biến service để sử dụng cho truy vấn
  static final DatabaseProduct _databaseService = DatabaseProduct._internal();
  factory DatabaseProduct() => _databaseService;
  DatabaseProduct._internal();

  static Database? _databasePro;
  Future<Database> get database async {
    if (_databasePro != null) {
      return _databasePro!;
    }

    _databasePro = await _initDatabase();
    return _databasePro!;
    // Tạo db lần đầu nếu db đó chưa tạo
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'db_product.db');
    print(
        "Đường dẫn database: $databasePath"); // in đường dẫn chứa file database
    // Kiểm tra xem cơ sở dữ liệu đã tồn tại chưa
    bool checkDBExists = await databaseExists(path);

    // Mở hoặc tạo mới cơ sở dữ liệu
    Database database;
    if (!checkDBExists) {
      database = await openDatabase(path, version: 1, onCreate: _onCreate);
    } else {
      database = await openDatabase(path);
    }

    // Kiểm tra xem bảng Product đã tồn tại trong cơ sở dữ liệu hay không
    bool tableExists = await _checkIfTableExists(database, 'product');

    // Nếu bảng Product chưa tồn tại, tạo mới
    if (!tableExists) {
      await _createProductTable(database);
    }

    return database
        // ,
        // onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
        ;
  }

  Future<bool> databaseExists(String path) async {
    return databaseFactory.databaseExists(path);
  }

  Future<bool> _checkIfTableExists(Database database, String tableName) async {
    var res = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    return res.isNotEmpty;
  }

  Future<void> _createProductTable(Database database) async {
    await database.execute(
      'CREATE TABLE product(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price FLOAT, img TEXT, desc TEXT, catId INTEGER)',
    );
  }

  // Lệnh tạo table product
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE product(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price FLOAT, img TEXT, desc TEXT, catId INTEGER)',
    );
  }

  // Lệnh thêm row trong product
  Future<void> insertProduct(ProductModel productModel) async {
    final db = await _databaseService.database;

    await db.insert(
      'product',
      productModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Lệnh lấy danh sách product
  Future<List<ProductModel>> products() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('product');
    // print(maps);
    return List.generate(
        maps.length, (index) => ProductModel.fromMap(maps[index]));
  }

  // Lệnh lấy danh sách product theo catDd
  Future<List<ProductModel>> findProductId(int catId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'product', // Sửa 'pruduct' thành 'product'
      where: 'catId = ?', // Sử dụng tham số ràng buộc
      whereArgs: [catId], // Truyền giá trị của catId vào đây
    );
    // print(maps);
    return List.generate(
      maps.length,
      (index) => ProductModel.fromMap(maps[index]),
    );
  }

  // Lấy danh sách theo catId
  Future<ProductModel> findProductsByCatId(int catId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'product',
      where: 'catId = ?',
      whereArgs: [catId], // Đoạn này sẽ thay thế vào dấu ?
    );
    return ProductModel.fromMap(maps[0]);
  }

  // Lệnh cập nhật dữ liệu product
  Future<void> updateProduct(ProductModel pro) async {
    final db = await _databaseService.database;
    await db.update(
      'product',
      pro.toMap(),
      where: 'id = ?',
      whereArgs: [pro.id],
    );
  }

  // Lệnh xóa dữ liệu product
  Future<void> deleteProduct(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'product',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
