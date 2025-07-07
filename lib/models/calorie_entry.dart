class CalorieEntry {
  final String food;
  final double calories;
  final DateTime timestamp;

  CalorieEntry({required this.food, required this.calories, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'food': food,
      'calories': calories,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CalorieEntry.fromMap(Map<String, dynamic> map) {
    return CalorieEntry(
      food: map['food'] ?? '',
      calories: (map['calories'] ?? 0).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}