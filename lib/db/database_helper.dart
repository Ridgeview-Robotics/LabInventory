import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item.dart';

class DatabaseHelper {
  static const _databaseName = 'inventory.db';
  static const _databaseVersion = 1;

  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        code TEXT PRIMARY KEY,
        name TEXT,
        type TEXT,
        status TEXT,
        usageHours INTEGER,
        damageNotes TEXT,
        location TEXT
      )
    ''');
  }

  Future<int> insertItem(Item item) async {
    final db = await database;
    return await db.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Item>> getAllItems() async {
    final db = await database;
    final maps = await db.query('items');
    return maps.map((map) => Item.fromMap(map)).toList();
  }

  Future<Item?> getItemByCode(String code) async {
    final db = await database;
    final maps = await db.query(
      'items',
      where: 'code = ?',
      whereArgs: [code],
    );

    if (maps.isNotEmpty) {
      return Item.fromMap(maps.first);
    } else {
      return null;
    }
  }


  Future<int> updateItem(Item item) async {
    final db = await database;
    return await db.update('items', item.toMap(),
        where: 'code = ?', whereArgs: [item.code]);
  }

  Future<int> deleteItem(String code) async {
    final db = await database;
    return await db.delete('items', where: 'code = ?', whereArgs: [code]);
  }
}
