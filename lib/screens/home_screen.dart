import 'package:flutter/material.dart';
import 'package:wellness_tracker_app/screens/body_tracker_screen.dart';
import 'package:wellness_tracker_app/screens/calorie_tracker_screen.dart';
import '../widgets/eating_window_progress_bar.dart';
import '../widgets/quote_of_the_day.dart';
import 'water_tracker_screen.dart';
import 'weight_tracker_screen.dart';

class HomeScreen extends StatelessWidget {
  final DateTime startDate = DateTime(2025, 6, 22);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final daysSince = today.difference(startDate).inDays + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Longlived', style: TextStyle (color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 125, 91, 183),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Center(
                child: Text(
                  "Hey Aayushi",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(height: 4),

              QuoteOfTheDay(dayIndex: daysSince),
              SizedBox(height: 6),

              // Days passed
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(text: 'Today: ', style: TextStyle(color: Colors.black)),
                    TextSpan(
                      text: _formatDate(today),
                      style: TextStyle(color: const Color.fromARGB(255, 183, 58, 116)),
                    ),
                    TextSpan(text: '  •  Day: ', style: TextStyle(color: Colors.black)),
                    TextSpan(
                      text: '$daysSince',
                      style: TextStyle(color: const Color.fromARGB(255, 183, 58, 116)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Eating Window Progress Bar
              EatingWindowProgressBar(),
              SizedBox(height: 30),

              // Navigation Buttons
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.local_drink),
                  label: Text("Water Tracker"),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WaterTrackerScreen()),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.monitor_weight),
                  label: Text("Weight Tracker"),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WeightTrackerScreen()),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.monitor_weight),
                  label: Text("Body Tracker"),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BodyTrackerScreen()),
                  ),
                ),
              ),   

              SizedBox(height: 20),

              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.monitor_weight),
                  label: Text("Calorie Tracker"),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CalorieTrackerScreen()),
                  ),
                ),
              ),  
              // Add more buttons/modules below
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${_monthName(date.month)} ${date.day}, ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
}
