// lib/screens/water_tracker_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import '../models/water_entry.dart';

class WaterTrackerScreen extends StatefulWidget {
  static const routeName = '/water-tracker';

  @override
  _WaterTrackerScreenState createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  void _tryAddAmount(WaterProvider provider, double amount) async {
    if (provider.canAddAmount(amount)) {
      await provider.addEntry(WaterEntry(
        timestamp: DateTime.now(),
        amountMl: amount,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Limit reached. Not enough space for ${amount.toInt()}ml")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final waterProvider = Provider.of<WaterProvider>(context);

    final today = DateTime.now();
    final todayEntries = waterProvider.entries.where((e) =>
      e.timestamp.year == today.year &&
      e.timestamp.month == today.month &&
      e.timestamp.day == today.day).toList();

    final last2DaysTotals = List.generate(2, (i) {
      final day = today.subtract(Duration(days: i));
      return waterProvider.entries
        .where((e) =>
          e.timestamp.year == day.year &&
          e.timestamp.month == day.month &&
          e.timestamp.day == day.day)
        .fold(0.0, (dynamic sum, e) => (sum as double) + e.amountMl);
    });

    final weeklyTotal = waterProvider.entries.where((e) =>
      e.timestamp.isAfter(today.subtract(Duration(days: 6)))
    ).fold(0.0, (dynamic sum, e) => (sum as double) + e.amountMl);

    final bottles = (last2DaysTotals[0] / 3000).ceil();
    final maxBottles = 5;

    return Scaffold(
      appBar: AppBar(
        title: Text('💧 Water Tracker', style: TextStyle (color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 125, 91, 183),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                waterProvider.clearToday();
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),

          // Today Section
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Today", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Total: ",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        TextSpan(
                          text: "${(last2DaysTotals[0] / 1000).toStringAsFixed(2)} L",
                          style: TextStyle(fontSize: 20, color: Colors.deepOrange), // Change this color
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          SizedBox(height: 14),

          // Quick Add Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var amount in [100.0, 250.0, 500.0])
                  ElevatedButton(
                    onPressed: () => _tryAddAmount(waterProvider, amount),
                    child: Text("+${amount.toInt()} ml"),
                  ),
              ],
            ),
          ),

          SizedBox(height: 10),

          // Bottles Visual or Full Message
          bottles > maxBottles
            ? Text("Limit reached: You’ve filled all 5 bottles!", style: TextStyle(color: Colors.red))
            : SizedBox(
                height: 140,
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      bottles > maxBottles ? maxBottles : bottles,
                      (index) {
                        final isLast = index == bottles - 1;
                        final percentFilled = isLast ? (last2DaysTotals[0] % 3000) / 3000 : 1.0;
                        return _WaterBottleWidget(percentFilled: percentFilled);
                      },
                    ),
                  ),
                ),
              ),

          SizedBox(height: 10),

          // Show only today's entries in scroll view
          Expanded(
            child: todayEntries.isEmpty
              ? Center(child: Text("No entries yet."))
                : ListView.builder(
                  itemCount: todayEntries.length,
                  itemBuilder: (context, index) {
                    final entry = todayEntries[index];
                    return ListTile(
                      leading: Icon(Icons.water_drop),
                      title: Text('${entry.amountMl.toStringAsFixed(0)} ml'),
                      subtitle: Text(
                        '${entry.timestamp.hour}:${entry.timestamp.minute.toString().padLeft(2, '0')} on ${entry.timestamp.day}/${entry.timestamp.month}',
                      ),
                    );
                  },
                ),
          ),

          // Yesterday and Week Totals
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Yesterday's total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("${(last2DaysTotals[1] / 1000).toStringAsFixed(2)} L", style: TextStyle(fontSize: 18, color: Colors.deepOrange)),
                  SizedBox(height: 8),
                  Text("Week's total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("${(weeklyTotal / 1000).toStringAsFixed(2)} L", style: TextStyle(fontSize: 18, color: Colors.deepOrange)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterBottleWidget extends StatelessWidget {
  final double percentFilled; // value from 0.0 to 1.0

  const _WaterBottleWidget({required this.percentFilled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width / 6, // 5 bottles + spacing
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 100 * percentFilled,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text("3L", style: TextStyle(fontSize: 10, color: Colors.black54)),
            ),
          )
        ],
      ),
    );
  }
}
