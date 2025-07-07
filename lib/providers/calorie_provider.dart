import 'package:flutter/material.dart';
import '../models/calorie_entry.dart';
import '../db/database_helper.dart';

class CalorieProvider with ChangeNotifier {
  List<CalorieEntry> _entries = [];

  List<CalorieEntry> get entries => _entries;

  Future<void> loadEntries() async {
    _entries = await DatabaseHelper.instance.getCalorieEntries();
    notifyListeners();
  }

  Future<void> addEntry(CalorieEntry entry) async {
    await DatabaseHelper.instance.insertCalorieEntry(entry);
    await loadEntries();
  }

  List<CalorieEntry> get todayEntries {
    final now = DateTime.now();
    return _entries.where((e) =>
      e.timestamp.year == now.year &&
      e.timestamp.month == now.month &&
      e.timestamp.day == now.day
    ).toList();
  }

  double get todayTotalCalories => todayEntries.fold(0.0, (sum, e) => sum + e.calories);

  List<MapEntry<String, double>> get last7DaysData {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: i));
      final total = _entries.where((e) =>
        e.timestamp.year == date.year &&
        e.timestamp.month == date.month &&
        e.timestamp.day == date.day
      ).fold<double>(0.0, (sum, e) => sum + e.calories);
      return MapEntry("${date.month}/${date.day}", total);
    }).reversed.toList();
  }
}