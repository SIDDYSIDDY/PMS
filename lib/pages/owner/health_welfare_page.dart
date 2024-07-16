import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pms/components/bottom_nav_bar.dart';
import 'package:pms/models/get_farm.dart';

class HealthWelfarePage extends StatefulWidget {
  const HealthWelfarePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HealthWelfarePageState createState() => _HealthWelfarePageState();
}

class _HealthWelfarePageState extends State<HealthWelfarePage> {
  late List<GetFarm> farms;
  int _currentIndex = 1; // Initialize with the default index

  final int userId = 1; // Replace with actual user ID
  late String farmsUrl;

  @override
  void initState() {
    super.initState();
    farms = [];
    farmsUrl =
        "http://localhost/flutter/api/get_farms_data.php?user_id=$userId";
    fetchFarmsData();
  }

  Future<void> fetchFarmsData() async {
    try {
      final response = await http.get(Uri.parse(farmsUrl));

      if (response.statusCode == 200) {
        setState(() {
          // Decode JSON response
          var data = jsonDecode(response.body);

          if (data['status'] == 'success') {
            // Handle farms data
            farms = (data['data'] as List)
                .map((item) => GetFarm.fromJson(item))
                .toList();
          } else {
            showToast(
                "Failed to load data: ${data['message'] ?? 'Unknown error'}");
          }
        });
      } else {
        // Log the response for debugging
        showToast("Failed to load data");
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

  Widget buildDataTable(
      String title, List<Map<String, String>> data, List<String> columns) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: columns
                .map((column) => DataColumn(label: Text(column)))
                .toList(),
            rows: data.map((row) {
              return DataRow(
                cells: columns.map((column) {
                  return DataCell(Text(row[column] ?? ''));
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health & Welfare'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Farms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (farms.isEmpty) const Text('No farms available'),
            if (farms.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: farms.length,
                itemBuilder: (context, index) {
                  final farm = farms[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ExpansionTile(
                      title: Text(farm.farmName),
                      subtitle: Text(farm.farmLocation),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildDataTable(
                            'Vaccinations',
                            farm.vaccinations
                                .map((vaccine) => {
                                      'Vaccine Name': vaccine.vaccineName,
                                      'Hen ID': vaccine.henId.toString(),
                                      'Date': vaccine.vaccinationDate,
                                      'Next Due Date':
                                          vaccine.nextDueDate ?? 'N/A'
                                    })
                                .toList(),
                            ['Vaccine Name', 'Hen ID', 'Date', 'Next Due Date'],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildDataTable(
                            'Health Records',
                            farm.healthRecords
                                .map((record) => {
                                      'Description': record.description,
                                      'Hen ID': record.henId.toString(),
                                      'Date': record.date
                                    })
                                .toList(),
                            ['Description', 'Hen ID', 'Date'],
                          ),
                        ),
                      ],
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
            // Handle navigation logic here if needed
          });
        },
      ),
    );
  }
}
