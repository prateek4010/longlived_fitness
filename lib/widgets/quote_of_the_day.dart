// lib/widgets/quote_of_the_day.dart
import 'package:flutter/material.dart';
import '../models/quotes.dart';

class QuoteOfTheDay extends StatelessWidget {
  final int dayIndex;

  QuoteOfTheDay({required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    final index = (dayIndex - 1) % dailyQuotes.length;
    final quote = dailyQuotes[index];

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '"$quote"',
            style: TextStyle(
              fontSize: 16,
              color: Colors.deepPurple.shade700,
              fontStyle: FontStyle.italic
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
