// lib/screens/calorie_tracker_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_calories.dart';
import '../models/calorie_entry.dart';
import '../providers/calorie_provider.dart';
import '../widgets/calorie_bar_chart.dart';


class CalorieTrackerScreen extends StatefulWidget {
  static const routeName = '/calorie-tracker';
  @override
  _CalorieTrackerScreenState createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  String? selectedFood;
  double grams = 100;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalorieProvider>(context);
    final todayEntries = provider.todayEntries;
    final totalToday = todayEntries.fold<double>(0.0, (sum, e) => sum + e.calories);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracker', style: TextStyle (color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 125, 91, 183),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Center( child:
              DropdownButton<String>(
                hint: Text("Select Food"),
                value: selectedFood,
                onChanged: (value) => setState(() => selectedFood = value),
                items: foodCalories.keys
                    .map((food) => DropdownMenuItem(
                          child: Text(food),
                          value: food,
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Quantity Input
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text("Quantity: ", style: TextStyle(fontSize: 16)),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (val) => setState(() => grams = double.tryParse(val) ?? 100),
                          decoration: InputDecoration(hintText: '100'),
                        ),
                      ),
                    ],
                  ),
                ),

                // Add Button
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: selectedFood == null
                        ? null
                        : () async {
                            final calPer100g = foodCalories[selectedFood!]!;
                            final cal = (grams / 100) * calPer100g;
                            await provider.addEntry(CalorieEntry(
                              food: selectedFood!,
                              calories: cal,
                              timestamp: DateTime.now(),
                            ));
                          },
                    child: Text("Add"),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),
            
            Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  children: [
                    TextSpan(text: "Today's Total: "),
                    TextSpan(
                      text: "${totalToday.toStringAsFixed(1)} Kcal",
                      style: TextStyle(color: Colors.deepOrange), // <- only value colored
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Column(
                children: [
                  // Scrollable food entry list
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: todayEntries.length,
                            itemBuilder: (context, index) {
                              final e = todayEntries[index];
                              return Dismissible(
                                key: Key(e.timestamp.toIso8601String()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20),
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                                onDismissed: (direction) async {
                                  await Provider.of<CalorieProvider>(context, listen: false).deleteEntry(e);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${e.food} removed')),
                                  );
                                },
                                child: ListTile(
                                  title: Text(e.food),
                                  subtitle: Text(
                                    "${e.calories.toStringAsFixed(1)} kcal at ${TimeOfDay.fromDateTime(e.timestamp).format(context)}",
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Spacer
                  const SizedBox(height: 16),

                  // Label
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Last 7 Days',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Bar Chart (Always visible)
                  SizedBox(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CalorieBarChart(), // ⬅️ your bar chart widget
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}