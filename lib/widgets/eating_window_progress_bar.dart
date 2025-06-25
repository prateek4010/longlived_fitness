// lib/widgets/eating_window_progress_bar.dart
import 'dart:async';
import 'package:flutter/material.dart';

class EatingWindowProgressBar extends StatefulWidget {
  const EatingWindowProgressBar({Key? key}) : super(key: key);

  @override
  _EatingWindowProgressBarState createState() => _EatingWindowProgressBarState();
}

class _EatingWindowProgressBarState extends State<EatingWindowProgressBar> {
  late Timer _timer;
  late DateTime _now;

  final int startHour = 10; // 10 AM
  final int endHour = 22;   // 10 PM

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final start = DateTime(_now.year, _now.month, _now.day, startHour);
    final end = DateTime(_now.year, _now.month, _now.day, endHour);

    final totalMinutes = end.difference(start).inMinutes.toDouble();

    double progress;
    String timeMessage;

    if (_now.isBefore(start)) {
      progress = 0.0;
      final diff = start.difference(_now);
      timeMessage = "Starts in ${diff.inHours}h ${diff.inMinutes % 60}m";
    } else if (_now.isAfter(end)) {
      progress = 1.0;
      timeMessage = "Ended";
    } else {
      final elapsedMinutes = _now.difference(start).inMinutes.toDouble();
      progress = elapsedMinutes / totalMinutes;
      final remaining = end.difference(_now);
      timeMessage = "Ends in ${remaining.inHours}h ${remaining.inMinutes % 60}m ${remaining.inSeconds % 60}s";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Eating Window (10 AM - 10 PM)", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          color: Color.fromARGB(255, 0, 150, 102),
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${(progress * 100).clamp(0.0, 100.0).toStringAsFixed(1)}%", style: TextStyle(fontSize: 12)),
            Text(timeMessage, style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
