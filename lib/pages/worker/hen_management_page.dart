import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pms/pages/worker/components/bottom_nav_bar.dart';

class HenManagementPage extends StatefulWidget {
  const HenManagementPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HenManagementPageState createState() => _HenManagementPageState();
}

class _HenManagementPageState extends State<HenManagementPage> {
  List<Farm> farms = []; // To store available farms
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _farmIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchFarms(); // Fetch available farms on page load
  }

  @override
  void dispose() {
    _farmIdController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> fetchFarms() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/flutter/api/get_farms_data.php'),
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          setState(() {
            farms = (jsonResponse['data'] as List<dynamic>)
                .map((model) => Farm.fromJson(model))
                .toList();
          });
        } else {
          // Handle if farms fetch is not successful
        }
      } else {
        // Handle if response status code is not 200
      }
    } catch (error) {
      // Handle general error
    }
  }

  int convertMonthsToYears(int months) {
    return (months / 12).floor();
  }

  Future<void> addHen() async {
    if (_formKey.currentState!.validate()) {
      try {
        int ageInMonths = int.parse(_ageController.text);
        int ageInYears = convertMonthsToYears(ageInMonths);

        final response = await http.post(
          Uri.parse('http://localhost/flutter/api/hensadd.php'),
          body: jsonEncode({
            'farm_id': _farmIdController.text,
            'name': _nameController.text,
            'age': ageInYears.toString(),
            'weight': _weightController.text,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final dynamic jsonResponse = jsonDecode(response.body);

          if (jsonResponse['status'] == 'success') {
            setState(() {
              _farmIdController.clear();
              _nameController.clear();
              _ageController.clear();
              _weightController.clear();
            });
          } else {
            // Handle if adding hen is not successful
          }
        } else {
          // Handle if response status code is not 200
        }
      } catch (error) {
        // Handle general error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Poultry Management',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _farmIdController,
                decoration: const InputDecoration(labelText: 'Farm ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a farm ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age (in months)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the weight';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: addHen,
                child: const Text('Add Hen'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Handle navigation logic here if needed
          });
        },
      ),
    );
  }
}

class Farm {
  final int id;
  final String name;

  Farm({
    required this.id,
    required this.name,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      name: json['name'],
    );
  }
}

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
      id: json['id'],
      farmId: json['farm_id'],
      name: json['name'],
      age: json['age'],
      weight: double.parse(json['weight'].toString()),
    );
  }
}
