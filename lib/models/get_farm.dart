import '../models/vaccination.dart';
import '../models/health_record.dart';

class GetFarm {
  int farmId;
  String farmName;
  String farmLocation;
  List<Vaccination> vaccinations;
  List<HealthRecord> healthRecords;

  GetFarm({
    required this.farmId,
    required this.farmName,
    required this.farmLocation,
    required this.vaccinations,
    required this.healthRecords,
  });

  factory GetFarm.fromJson(Map<String, dynamic> json) {
    return GetFarm(
      farmId: json['farm_id'],
      farmName: json['farm_name'],
      farmLocation: json['farm_location'],
      vaccinations: (json['vaccinations'] as List)
          .map((v) => Vaccination.fromJson(v))
          .toList(),
      healthRecords: (json['health_records'] as List)
          .map((hr) => HealthRecord.fromJson(hr))
          .toList(),
    );
  }
}
