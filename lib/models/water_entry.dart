class WaterEntry {
  final int? id;
  final DateTime timestamp;
  final double amountMl;

  WaterEntry({this.id, required this.timestamp, required this.amountMl});

  Map<String, dynamic> toMap() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'amount_ml': amountMl,
      };

  factory WaterEntry.fromMap(Map<String, dynamic> map) => WaterEntry(
        id: map['id'],
        timestamp: DateTime.parse(map['timestamp']),
        amountMl: map['amount_ml'],
      );
}