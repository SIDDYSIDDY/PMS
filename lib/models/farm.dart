class Farm {
  final int id;
  final String name;
  final String location;
  final int? ownerId; // Make ownerId nullable

  Farm({
    required this.id,
    required this.name,
    required this.location,
    this.ownerId, // Make ownerId optional in the constructor
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      ownerId: json['owner_id'], // Include ownerId in the fromJson factory
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'name': name,
      'location': location,
    };

    // Conditionally include ownerId in the toJson method
    if (ownerId != null) {
      json['owner_id'] = ownerId;
    } else {
      json['owner_id'] = 3; // Set ownerId to 3 by default if null
    }

    return json;
  }
}
