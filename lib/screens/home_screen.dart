import 'package:flutter/material.dart';
import '../widgets/eating_window_progress_bar.dart';
import 'water_tracker_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Longlived')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Add more buttons/modules below
            ],
          ),
        ),
      ),
    );
  }
}
