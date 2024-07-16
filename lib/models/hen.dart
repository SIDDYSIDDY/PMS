class Hen {
  final int id;
  final int farmId;
  final String name;
  final int age;
  final double weight;

  Hen({
    required this.id,
    required this.farmId,
    required this.name,
    required this.age,
    required this.weight,
  });

  factory Hen.fromJson(Map<String, dynamic> json) {
    return Hen(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      farmId:
          json['farm_id'] is int ? json['farm_id'] : int.parse(json['farm_id']),
      name: json['name'] as String,
      age: json['age'] is int ? json['age'] : int.parse(json['age']),
      weight: json['weight'] is num
          ? (json['weight'] as num).toDouble()
          : double.parse(json['weight']),
    );
  }

  get count => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farm_id': farmId,
      'name': name,
      'age': age,
      'weight': weight,
    };
  }
}
