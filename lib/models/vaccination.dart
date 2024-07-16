class Vaccination {
  int id;
  int henId;
  int farmId;
  String vaccineName;
  String vaccinationDate;
  String? nextDueDate;

  Vaccination({
    required this.id,
    required this.henId,
    required this.farmId,
    required this.vaccineName,
    required this.vaccinationDate,
    this.nextDueDate,
  });

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['id'],
      henId: json['hen_id'],
      farmId: json['farm_id'],
      vaccineName: json['vaccine_name'],
      vaccinationDate: json['vaccination_date'],
      nextDueDate: json['next_due_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hen_id': henId,
      'farm_id': farmId,
      'vaccine_name': vaccineName,
      'vaccination_date': vaccinationDate,
      'next_due_date': nextDueDate,
    };
  }
}
