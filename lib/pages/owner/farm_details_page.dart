import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pms/models/farm.dart';
import 'package:pms/models/hen.dart';
import 'package:pms/models/egg.dart';
import 'package:pms/models/growth.dart';

class FarmDetailsPage extends StatefulWidget {
  final Farm farm;

  const FarmDetailsPage({super.key, required this.farm});

  @override
  // ignore: library_private_types_in_public_api
  _FarmDetailsPageState createState() => _FarmDetailsPageState();
}

class _FarmDetailsPageState extends State<FarmDetailsPage> {
  bool isLoading = true;
  List<Hen> hens = [];
  List<Egg> eggs = [];
  List<Growth> growthRecords = [];

  @override
  void initState() {
    super.initState();
    fetchFarmDetails();
  }

  Future<void> fetchFarmDetails() async {
    final farmId = widget.farm.id;

    try {
      final responseHens = await http.get(Uri.parse(
          'http://localhost/flutter/api/fetch_hens.php?farm_id=$farmId'));
      final responseEggs = await http.get(Uri.parse(
          'http://localhost/flutter/api/fetch_eggs.php?farm_id=$farmId'));
      final responseGrowth = await http.get(Uri.parse(
          'http://localhost/flutter/api/fetch_growth.php?farm_id=$farmId'));

      if (responseHens.statusCode == 200 &&
          responseEggs.statusCode == 200 &&
          responseGrowth.statusCode == 200) {
        setState(() {
          hens = (json.decode(responseHens.body)['hens'] as List)
              .map((i) => Hen.fromJson(i))
              .toList();
          eggs = (json.decode(responseEggs.body)['eggs'] as List)
              .map((i) => Egg.fromJson(i))
              .toList();
          growthRecords = (json.decode(responseGrowth.body)['growth'] as List)
              .map((i) => Growth.fromJson(i))
              .toList();
          isLoading = false;
        });
      } else {
        showToast("Failed to load farm details");
      }
    } catch (e) {
      showToast("Error: $e");
    }
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 3,
              child: Column(
                children: <Widget>[
                  const TabBar(
                    tabs: [
                      Tab(text: "Hens"),
                      Tab(text: "Eggs"),
                      Tab(text: "Growth"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        HensManagement(hens: hens),
                        EggsManagement(eggs: eggs),
                        GrowthManagement(growthRecords: growthRecords),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class HensManagement extends StatelessWidget {
  final List<Hen> hens;

  const HensManagement({super.key, required this.hens});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Age')),
          DataColumn(label: Text('Weight (kg)')),
        ],
        rows: hens.map<DataRow>((hen) {
          return DataRow(
            cells: [
              DataCell(Text(hen.id.toString())),
              DataCell(Text(hen.name)),
              DataCell(Text(hen.age.toString())),
              DataCell(Text(hen.weight.toString())),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class EggsManagement extends StatelessWidget {
  final List<Egg> eggs;

  const EggsManagement({super.key, required this.eggs});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Count')),
        ],
        rows: eggs.map<DataRow>((egg) {
          return DataRow(
            cells: [
              DataCell(Text(egg.id.toString())),
              DataCell(Text(egg.date.toIso8601String())),
              DataCell(Text(egg.count.toString())),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class GrowthManagement extends StatelessWidget {
  final List<Growth> growthRecords;

  const GrowthManagement({super.key, required this.growthRecords});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Hen ID')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Weight (kg)')),
        ],
        rows: growthRecords.map<DataRow>((growth) {
          return DataRow(
            cells: [
              DataCell(Text(growth.id.toString())),
              DataCell(Text(growth.henId.toString())),
              DataCell(Text(growth.date.toIso8601String())),
              DataCell(Text(growth.weight.toString())),
            ],
          );
        }).toList(),
      ),
    );
  }
}
