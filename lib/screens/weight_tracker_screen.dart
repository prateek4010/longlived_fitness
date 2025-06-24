// lib/screens/weight_tracker_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/weight_provider.dart';
import '../models/weight_entry.dart';
import 'package:intl/intl.dart';

class WeightTrackerScreen extends StatelessWidget {
  static const routeName = '/weight-tracker';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeightProvider>(context);
    final entries = provider.entries;

    return Scaffold(
      appBar: AppBar(title: Text("🏋️ Weight Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _showAddDialog(context),
              child: Text("Add Today's Weight"),
            ),
            SizedBox(height: 40),
            if (entries.isEmpty)
              Center(child: Text("No data yet."))
            else ...[
              Text("Weight Progress (kg)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              SizedBox(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0), // margin from left
                  child: LineChart(
                    LineChartData(
                      minY: entries.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b) - 1,
                      maxY: entries.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b) + 1,
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false), // no Y labels
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < entries.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    DateFormat('dd/MM').format(entries[index].date),
                                    style: TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return Text('');
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: entries.asMap().entries.map((e) =>
                            FlSpot(e.key.toDouble(), e.value.weightKg)).toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 2,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Enter Today's Weight (kg)"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final weight = double.tryParse(controller.text);
              if (weight != null) {
                final provider = Provider.of<WeightProvider>(context, listen: false);
                final today = DateTime.now();
                await provider.addOrUpdateWeight(
                  WeightEntry(
                    date: DateTime(today.year, today.month, today.day),
                    weightKg: weight,
                  ),
                );
                Navigator.of(ctx).pop();
              }
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }
}
