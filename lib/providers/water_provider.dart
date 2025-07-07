// --------------------- WATER PROVIDER ---------------------
// lib/providers/water_provider.dart
import 'package:flutter/material.dart';
import '../models/water_entry.dart';
import '../db/database_helper.dart';

class WaterProvider with ChangeNotifier {
  List<WaterEntry> _entries = [];

  List<WaterEntry> get entries => _entries;

  Future<void> loadEntries() async {
    _entries = await DatabaseHelper.instance.getWaterEntries();
    notifyListeners();
  }

  Future<void> addEntry(WaterEntry entry) async {
    await DatabaseHelper.instance.insertWaterEntry(entry);
    await loadEntries();
  }

  Future<void> deleteEntry(int id) async {
    await DatabaseHelper.instance.deleteWaterEntry(id);
    await loadEntries();
  }

  Future<void> clearToday() async {
    final today = DateTime.now();
    final todayEntries = _entries.where((entry) =>
      entry.timestamp.year == today.year &&
      entry.timestamp.month == today.month &&
      entry.timestamp.day == today.day).toList();

    for (var entry in todayEntries) {
      await DatabaseHelper.instance.deleteWaterEntry(entry.id!);
    }

    await loadEntries();
  }

  double get todayTotalMl {
    final today = DateTime.now();
    return _entries
        .where((e) =>
            e.timestamp.year == today.year &&
            e.timestamp.month == today.month &&
            e.timestamp.day == today.day)
        .fold(0.0, (sum, e) => sum + e.amountMl);
  }

  bool canAddAmount(double amountMl) {
    const maxDailyIntake = 3000.0 * 5; // 5 bottles of 3L
    return todayTotalMl + amountMl <= maxDailyIntake;
  }

  static Future<double> getTodayTotalFromDB() async {
    final entries = await DatabaseHelper.instance.getWaterEntries();

    final todayDate = DateTime.now();
    final todayOnly = DateTime(todayDate.year, todayDate.month, todayDate.day);

    return entries
        .where((e) {
          final entryDate = DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day);
          return entryDate == todayOnly;
        })
        .fold<double>(0.0, (sum, e) => sum + e.amountMl);
  }
}
