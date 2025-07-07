import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    return _database ??= await _initDB('inventory.db');
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT UNIQUE,
        name TEXT,
        type TEXT,
        status TEXT,
        usageHours INTEGER,
        damageNotes TEXT
      )
    ''');
  }

  Future<int> insertItem(Item item) async {
    final db = await instance.database;
    return await db.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Item?> getItemByCode(String code) async {
    final db = await instance.database;
    final maps = await db.query(
      'items',
      where: 'code = ?',
      whereArgs: [code],
    );
    if (maps.isNotEmpty) return Item.fromMap(maps.first);
    return null;
  }

  Future<List<Item>> getAllItems() async {
    final db = await instance.database;
    final maps = await db.query('items');
    return maps.map((e) => Item.fromMap(e)).toList();
  }

  Future<int> updateItem(Item item) async {
    final db = await instance.database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await instance.database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
