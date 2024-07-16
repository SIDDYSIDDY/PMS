import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pms/components/bottom_nav_bar.dart';
import 'package:pms/models/farm.dart';
import 'farm_details_page.dart';

class FarmManagementPage extends StatefulWidget {
  const FarmManagementPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FarmManagementPageState createState() => _FarmManagementPageState();
}

class _FarmManagementPageState extends State<FarmManagementPage> {
  List<Farm> farms = [];
  String message = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  int _currentIndex = 1; // Default index for BottomNavBar

  final String apiUrl = "http://localhost/flutter/api/index.php";

  @override
  void initState() {
    super.initState();
    fetchFarms();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> fetchFarms() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          List<dynamic> data = responseData['data'];
          setState(() {
            farms = data.map((item) => Farm.fromJson(item)).toList();
          });
        } else {
          showToast("Failed to load farms");
        }
      } else {
        showToast("Failed to load farms");
      }
    } catch (e) {
      showToast("Error: $e");
    }
  }

  Future<void> addFarm() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String location = _locationController.text.trim();
      int ownerId = 3; // Your predefined ownerId

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": name,
            "location": location,
            "owner_id": ownerId, // Include ownerId in the request body
          }),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            showToast("Farm added successfully");
            fetchFarms();
            _nameController.clear();
            _locationController.clear();
          } else {
            showToast("Failed to add farm");
          }
        } else {
          showToast("Failed to add farm");
        }
      } catch (e) {
        showToast("Error: $e");
      }
    }
  }

  Future<void> deleteFarm(String name) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost/flutter/api/delete_farm.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          showToast("Farm deleted successfully");
          fetchFarms();
        } else {
          showToast("Failed to delete farm");
        }
      } else {
        showToast("Failed to delete farm");
      }
    } catch (e) {
      showToast("Error: $e");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.8),
      textColor: Colors.white,
    );
  }

  void navigateToFarmDetails(Farm farm) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FarmDetailsPage(farm: farm)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Management'),
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
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.agriculture),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: addFarm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Add Farm'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: farms.length,
              itemBuilder: (context, index) {
                final farm = farms[index];
                return Card(
                  child: ListTile(
                    title: Text(farm.name),
                    subtitle: Text(farm.location),
                    onTap: () {
                      navigateToFarmDetails(farm);
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteFarm(farm.name);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
