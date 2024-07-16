import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pms/pages/worker/components/bottom_nav_bar.dart';

class EggManagementPage extends StatefulWidget {
  const EggManagementPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EggManagementPageState createState() => _EggManagementPageState();
}

class _EggManagementPageState extends State<EggManagementPage> {
  String message = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _farmIdController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  int _currentIndex = 1;

  @override
  void dispose() {
    _farmIdController.dispose();
    _countController.dispose();
    super.dispose();
  }

  Future<void> addEgg() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost/flutter/api/eggs.php'),
          body: jsonEncode({
            'farm_id': _farmIdController.text,
            'count': _countController.text,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final dynamic jsonResponse = jsonDecode(response.body);

          if (jsonResponse['status'] == 'success') {
            setState(() {
              message = 'New egg entry added successfully';
              _farmIdController.clear();
              _countController.clear();
            });
          } else {
            throw Exception('Failed to add egg: ${jsonResponse['message']}');
          }
        } else {
          throw Exception('Failed to add egg: ${response.statusCode}');
        }
      } catch (error) {
        setState(() {
          message = 'Error: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Egg Management',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Form(
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
                    controller: _countController,
                    decoration: const InputDecoration(labelText: 'Count'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the count';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: addEgg,
                    child: const Text('Add Egg'),
                  ),
                ],
              ),
            ),
          ],
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
