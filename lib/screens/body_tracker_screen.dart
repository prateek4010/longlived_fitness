import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/body_provider.dart';
import '../models/body_measurement.dart';

class BodyTrackerScreen extends StatelessWidget {
  static const routeName = '/body-tracker';

  final TextEditingController waistController = TextEditingController();
  final TextEditingController chestController = TextEditingController();
  final TextEditingController hipsController = TextEditingController();
  final TextEditingController thighsController = TextEditingController();
  final TextEditingController armsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BodyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Body Tracker', style: TextStyle (color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 125, 91, 183),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14),
            Center(
              child: ElevatedButton(
                onPressed: () => _showAddDialog(context),
                child: Text("Add Today's Measurements"),
              ),
            ),
            SizedBox(height: 20),
            provider.measurements.isEmpty
                ? Text("No measurements yet.")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: provider.measurements.length,
                    itemBuilder: (ctx, i) {
                      final entry = provider.measurements[i];
                      return Card(
                        child: ListTile(
                          title: Text("${entry.date.toLocal().toIso8601String().substring(0, 10)}"),
                          subtitle: Text(
                            "Waist: ${entry.waist} cm\nChest: ${entry.chest} cm\nHips: ${entry.hips} cm\nThighs: ${entry.thighs} cm\nArms: ${entry.arms} cm",
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Enter Measurements (cm)"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildField("Waist", waistController),
              _buildField("Chest", chestController),
              _buildField("Hips", hipsController),
              _buildField("Thighs", thighsController),
              _buildField("Arms", armsController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final provider = Provider.of<BodyProvider>(context, listen: false);
              final today = DateTime.now();
              await provider.addMeasurement(
                BodyMeasurement(
                  date: DateTime(today.year, today.month, today.day),
                  waist: double.tryParse(waistController.text) ?? 0,
                  chest: double.tryParse(chestController.text) ?? 0,
                  hips: double.tryParse(hipsController.text) ?? 0,
                  thighs: double.tryParse(thighsController.text) ?? 0,
                  arms: double.tryParse(armsController.text) ?? 0,
                ),
              );
              Navigator.of(ctx).pop();
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
