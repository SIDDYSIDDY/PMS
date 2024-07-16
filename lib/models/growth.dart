class Growth {
  final int id;
  final int henId;
  final DateTime date;
  final double weight;

  Growth({
    required this.id,
    required this.henId,
    required this.date,
    required this.weight,
  });

  factory Growth.fromJson(Map<String, dynamic> json) {
    return Growth(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      henId: json['hen_id'] is int ? json['hen_id'] : int.parse(json['hen_id']),
      date: DateTime.parse(json['date']),
      weight: json['weight'] is num
          ? (json['weight'] as num).toDouble()
          : double.parse(json['weight']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hen_id': henId,
      'date': date.toIso8601String(),
      'weight': weight,
    };
  }
}
