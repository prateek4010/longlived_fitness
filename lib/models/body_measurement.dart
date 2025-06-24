class BodyMeasurement {
  final int? id;
  final DateTime date;
  final double waist;
  final double chest;
  final double hips;
  final double thighs;
  final double arms;

  BodyMeasurement({
    this.id,
    required this.date,
    required this.waist,
    required this.chest,
    required this.hips,
    required this.thighs,
    required this.arms,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'waist': waist,
    'chest': chest,
    'hips': hips,
    'thighs': thighs,
    'arms': arms,
  };

  factory BodyMeasurement.fromMap(Map<String, dynamic> map) => BodyMeasurement(
    id: map['id'],
    date: DateTime.parse(map['date']),
    waist: map['waist'],
    chest: map['chest'],
    hips: map['hips'],
    thighs: map['thighs'],
    arms: map['arms'],
  );
}