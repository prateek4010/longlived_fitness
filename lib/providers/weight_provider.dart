import 'package:flutter/material.dart';
import '../models/weight_entry.dart';
import '../db/database_helper.dart';

class WeightProvider with ChangeNotifier {
  List<WeightEntry> _entries = [];

  List<WeightEntry> get entries => _entries;

  Future<void> loadEntries() async {
    _entries = await DatabaseHelper.instance.getWeightEntries();
    notifyListeners();
  }

  Future<void> addOrUpdateWeight(WeightEntry entry) async {
    await DatabaseHelper.instance.insertOrUpdateWeightEntry(entry);
    await loadEntries();
  }
}