class Egg {
  final int id;
  final int farmId;
  final DateTime date;
  final int count;

  Egg({
    required this.id,
    required this.farmId,
    required this.date,
    required this.count,
  });

  factory Egg.fromJson(Map<String, dynamic> json) {
    return Egg(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      farmId:
          json['farm_id'] is int ? json['farm_id'] : int.parse(json['farm_id']),
      date: DateTime.parse(json['date']),
      count: json['count'] is int ? json['count'] : int.parse(json['count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farm_id': farmId,
      'date': date.toIso8601String(),
      'count': count,
    };
  }
}
