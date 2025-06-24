import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/water_entry.dart';
import '../models/weight_entry.dart';
import '../models/body_measurement.dart';

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

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE water_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        amount_ml REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE weight_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        weightKg REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE body_measurements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        waist REAL NOT NULL,
        chest REAL NOT NULL,
        hips REAL NOT NULL,
        thighs REAL NOT NULL,
        arms REAL NOT NULL
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

  Future<void> insertOrUpdateWeightEntry(WeightEntry entry) async {
    final db = await database;
    final today = DateTime(entry.date.year, entry.date.month, entry.date.day);

    final existing = await db.query(
      'weight_entries',
      where: 'date = ?',
      whereArgs: [today.toIso8601String()],
    );

    if (existing.isEmpty) {
      await db.insert('weight_entries', entry.toMap());
    } else {
      await db.update(
        'weight_entries',
        entry.toMap(),
        where: 'date = ?',
        whereArgs: [today.toIso8601String()],
      );
    }
  }

  Future<List<WeightEntry>> getWeightEntries() async {
    final db = await database;
    final result = await db.query('weight_entries', orderBy: 'date ASC');
    return result.map((e) => WeightEntry.fromMap(e)).toList();
  }

  // Insert body measurement
  Future<void> insertBodyMeasurement(BodyMeasurement entry) async {
    final db = await instance.database;
    await db.insert('body_measurements', entry.toMap());
  }

  // Get all body measurements
  Future<List<BodyMeasurement>> getBodyMeasurements() async {
    final db = await instance.database;
    final result = await db.query('body_measurements', orderBy: 'date DESC');
    return result.map((map) => BodyMeasurement.fromMap(map)).toList();
  }
}