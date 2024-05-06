import 'package:app_api/app/model/category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _databaseService = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseService;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // Khởi tạo db
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
    bool tableExists = await _checkIfTableExists(database, 'category');

    // Nếu bảng Product chưa tồn tại, tạo mới
    if (!tableExists) {
      await _createTable(database);
    }

    return database;
    // ,
    // onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
  }

  Future<bool> databaseExists(String path) async {
    return databaseFactory.databaseExists(path);
  }

  Future<bool> _checkIfTableExists(Database database, String tableName) async {
    var res = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    return res.isNotEmpty;
  }

  Future<void> _createTable(Database database) async {
    await database.execute(
      'CREATE TABLE category(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, desc TEXT)',
    );
  }

  // Lệnh tạo table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE category(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, desc TEXT)',
    );
  }

  // Lệnh thêm row trong category
  Future<void> insertCategory(CategoryModel categoryModel) async {
    final db = await _databaseService.database;

    await db.insert(
      'category',
      categoryModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Lệnh lấy danh sách category
  Future<List<CategoryModel>> categories() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('category');
    return List.generate(
        maps.length, (index) => CategoryModel.fromMap(maps[index]));
  }

  // Lệnh lấy danh sách category theo id
  Future<CategoryModel> category(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('category', where: 'id = ?', whereArgs: [id]);
    return CategoryModel.fromMap(maps[0]);
  }

  // Lệnh cập nhật dữ liệu category
  Future<void> updateCategory(CategoryModel cate) async {
    final db = await _databaseService.database;
    await db.update(
      'category',
      cate.toMap(),
      where: 'id = ?',
      whereArgs: [cate.id],
    );
  }

  // Lệnh xóa dữ liệu category
  Future<void> deleteCategory(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
