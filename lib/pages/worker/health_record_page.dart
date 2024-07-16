import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pms/pages/worker/components/bottom_nav_bar.dart';

// HealthRecord model class
class HealthRecord {
  final int id;
  final int henId;
  final int farmId;
  final String date;
  final String description;

  HealthRecord({
    required this.id,
    required this.henId,
    required this.farmId,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'henId': henId,
      'farmId': farmId,
      'date': date,
      'description': description,
    };
  }
}

class HealthRecordPage extends StatefulWidget {
  const HealthRecordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HealthRecordPageState createState() => _HealthRecordPageState();
}

class _HealthRecordPageState extends State<HealthRecordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _henIdController = TextEditingController();
  final TextEditingController _farmIdController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final Dio _dio = Dio(); // Create a Dio instance

  Future<void> _submitHealthRecordData() async {
    if (_formKey.currentState!.validate()) {
      HealthRecord healthRecord = HealthRecord(
        id: 0, // This will be ignored by the server
        henId: int.parse(_henIdController.text),
        farmId: int.parse(_farmIdController.text),
        date: _dateController.text,
        description: _descriptionController.text,
      );

      const url =
          'http://localhost/flutter/api/submit_health_record.php'; // Replace with your actual endpoint URL

      try {
        final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
          data: healthRecord.toJson(),
        );

        // Handle response

        if (response.statusCode == 200) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Health record data submitted successfully!'),
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit health record data.'),
            ),
          );
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while submitting data.'),
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
        title: const Text('Health Records'),
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
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  await _selectDate(_dateController);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitHealthRecordData,
                child: const Text('Submit Health Record Data'),
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
