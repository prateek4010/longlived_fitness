class WeightEntry {
  final int? id;
  final DateTime date;
  final double weightKg;

  WeightEntry({this.id, required this.date, required this.weightKg});

  Map<String, Object> toMap() {
    final map = <String, Object>{
      'date': date.toIso8601String(),
      'weightKg': weightKg,
    };
    if (id != null) {
      map['id'] = id!; // Force unwrap because map expects Object
    }
    return map;
  }

  factory WeightEntry.fromMap(Map<String, dynamic> map) => WeightEntry(
    id: map['id'],
    date: DateTime.parse(map['date']),
    weightKg: map['weightKg'],
  );
}