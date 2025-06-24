import 'package:flutter/material.dart';
import '../models/body_measurement.dart';
import '../db/database_helper.dart';

class BodyProvider with ChangeNotifier {
  List<BodyMeasurement> _measurements = [];

  List<BodyMeasurement> get measurements => _measurements;

  Future<void> loadMeasurements() async {
    _measurements = await DatabaseHelper.instance.getBodyMeasurements();
    notifyListeners();
  }

  Future<void> addMeasurement(BodyMeasurement entry) async {
    await DatabaseHelper.instance.insertBodyMeasurement(entry);
    await loadMeasurements();
  }

  Future<void> clearToday() async {
  final today = DateTime.now();
  final formatted = DateTime(today.year, today.month, today.day);
  final db = await DatabaseHelper.instance.database;

  await db.delete(
    'body_measurements',
    where: 'date = ?',
    whereArgs: [formatted.toIso8601String()],
  );

  await loadMeasurements();
}
}