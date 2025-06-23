// lib/db/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/water_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wellness_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE water_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        amount_ml REAL NOT NULL
      )
    ''');
  }

  Future<void> insertWaterEntry(WaterEntry entry) async {
    final db = await instance.database;
    await db.insert('water_entries', entry.toMap());
  }

  Future<List<WaterEntry>> getWaterEntries() async {
    final db = await instance.database;
    final result = await db.query('water_entries', orderBy: 'timestamp DESC');
    return result.map((map) => WaterEntry.fromMap(map)).toList();
  }

  Future<void> deleteWaterEntry(int id) async {
    final db = await instance.database;
    await db.delete('water_entries', where: 'id = ?', whereArgs: [id]);
  }
}