// worker.dart

class Worker {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String password; // Add password field

  Worker({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.password, // Initialize password in the constructor
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      password: json['password'], // Assign password from JSON
    );
  }
}
