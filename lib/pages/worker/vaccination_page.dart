import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pms/models/vaccination.dart';
import 'package:pms/pages/worker/components/bottom_nav_bar.dart';

class VaccinationPage extends StatefulWidget {
  const VaccinationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VaccinationPageState createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _henIdController = TextEditingController();
  final TextEditingController _farmIdController = TextEditingController();
  final TextEditingController _vaccineNameController = TextEditingController();
  final TextEditingController _vaccinationDateController =
      TextEditingController();
  final TextEditingController _nextDueDateController = TextEditingController();

  Future<void> _submitVaccinationData() async {
    if (_formKey.currentState!.validate()) {
      Vaccination vaccination = Vaccination(
        id: 0,
        henId: int.parse(_henIdController.text),
        farmId: int.parse(_farmIdController.text),
        vaccineName: _vaccineNameController.text,
        vaccinationDate: _vaccinationDateController.text,
        nextDueDate: _nextDueDateController.text.isNotEmpty
            ? _nextDueDateController.text
            : null,
      );

      final response = await http.post(
        Uri.parse(
            'http://localhost/flutter/api/vaccinations.php'), // Use your server's IP address
        headers: {'Content-Type': 'application/json'},
        body: json.encode(vaccination.toJson()),
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vaccination data submitted successfully!'),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit vaccination data.'),
          ),
        );
      }
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccination Records'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _henIdController,
                decoration: const InputDecoration(labelText: 'Hen ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the hen ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _farmIdController,
                decoration: const InputDecoration(labelText: 'Farm ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the farm ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vaccineNameController,
                decoration: const InputDecoration(labelText: 'Vaccine Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the vaccine name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vaccinationDateController,
                decoration:
                    const InputDecoration(labelText: 'Vaccination Date'),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  await _selectDate(_vaccinationDateController);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a vaccination date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nextDueDateController,
                decoration: const InputDecoration(
                    labelText: 'Next Due Date (optional)'),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  await _selectDate(_nextDueDateController);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitVaccinationData,
                child: const Text('Submit Vaccination Data'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex:
            4, // Adjust index as needed for health records in your navigation
        onTap: (index) {
          // Handle navigation actions based on index if needed
        },
      ),
    );
  }
}
