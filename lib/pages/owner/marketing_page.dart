// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pms/models/sale.dart';
import 'package:pms/components/bottom_nav_bar.dart';

class MarketingPage extends StatefulWidget {
  const MarketingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MarketingPageState createState() => _MarketingPageState();
}

class _MarketingPageState extends State<MarketingPage> {
  List<Farm> farms = [];
  List<Egg> eggs = [];
  List<Hen> hens = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url =
        Uri.parse('http://localhost/flutter/api/fetch_farms_eggs_hens.php');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        farms = (jsonData['farms'] as List)
            .map((farm) => Farm(
                  id: farm['id'],
                  name: farm['name'],
                  location: farm['location'],
                ))
            .toList();

        eggs = (jsonData['eggs'] as List)
            .map((egg) => Egg(
                  farmId: egg['farm_id'],
                  count: int.parse(egg['total_count'].toString()),
                ))
            .toList();

        hens = (jsonData['hens'] as List)
            .map((hen) => Hen(
                  farmId: hen['farm_id'],
                  count: int.parse(hen['total_count'].toString()),
                ))
            .toList();

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showBuySellDialog(bool isSell, int farmId) {
    showDialog(
      context: context,
      builder: (context) => BuySellDialog(
        isSell: isSell,
        farmId: farmId,
        onTransactionSuccess: isSell ? sellEggsHens : buyEggsHens,
      ),
    );
  }

  Future<void> sellEggsHens(Sale sale) async {
    var url = Uri.parse('http://localhost/flutter/api/sell_eggs_hens.php');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(sale.toJson()), // Convert to JSON string here
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          setState(() {
            final farmEgg = eggs.firstWhere((egg) => egg.farmId == sale.farmId);
            final farmHen = hens.firstWhere((hen) => hen.farmId == sale.farmId);

            farmEgg.count -= sale.eggCount;
            farmHen.count -= sale.henCount;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Sell successful!')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Failed to sell.')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.statusCode}')));
      }
    } catch (e) {
      print("Error selling eggs/hens: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error selling.')));
    }
  }

  Future<void> buyEggsHens(Sale sale) async {
    var url = Uri.parse('http://localhost/flutter/api/buy_eggs_hens.php');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(sale.toJson()), // Convert to JSON string here
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          setState(() {
            final farmEgg = eggs.firstWhere((egg) => egg.farmId == sale.farmId);
            final farmHen = hens.firstWhere((hen) => hen.farmId == sale.farmId);

            farmEgg.count += sale.eggCount; // Add eggCount for buying
            farmHen.count += sale.henCount; // Add henCount for buying
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Buy successful!')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Failed to buy.')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.statusCode}')));
      }
    } catch (e) {
      print("Error buying eggs/hens: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error buying.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketing Page'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: farms.length,
              itemBuilder: (context, index) {
                final farm = farms[index];
                final eggCount = eggs
                    .where((egg) => egg.farmId == farm.id)
                    .fold(0, (prev, curr) => prev + curr.count);
                final henCount = hens
                    .where((hen) => hen.farmId == farm.id)
                    .fold(0, (prev, curr) => prev + curr.count);

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farm.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('Location: ${farm.location}'),
                        Text('Total Eggs: $eggCount'),
                        Text('Total Hens: $henCount'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  _showBuySellDialog(true, farm.id),
                              child: const Text('Sell'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () =>
                                  _showBuySellDialog(false, farm.id),
                              child: const Text('Buy'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Set current index for 'Selling' page
        onTap: (index) {
          // Handle navigation here if needed
        },
      ),
    );
  }
}

class BuySellDialog extends StatefulWidget {
  final bool isSell;
  final int farmId;
  final Function(Sale) onTransactionSuccess;

  const BuySellDialog({
    super.key,
    required this.isSell,
    required this.farmId,
    required this.onTransactionSuccess,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BuySellDialogState createState() => _BuySellDialogState();
}

class _BuySellDialogState extends State<BuySellDialog> {
  final formKey = GlobalKey<FormState>();
  int eggCount = 0;
  int henCount = 0;
  double pricePerEgg = 0.0;
  double pricePerHen = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isSell ? 'Sell Eggs/Hens' : 'Buy Eggs/Hens'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Egg Count'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                eggCount = int.parse(value!);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Hen Count'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                henCount = int.parse(value!);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Price per Egg'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                pricePerEgg = double.parse(value!);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Price per Hen'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                pricePerHen = double.parse(value!);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            formKey.currentState!.save();

            // Initialize totalAmount to 0.0 when buying
            double totalAmount = 0.0;
            if (widget.isSell) {
              totalAmount = (eggCount * pricePerEgg) + (henCount * pricePerHen);
            } // Buying does not involve price

            final sale = Sale(
              farmId: widget.farmId,
              eggCount: eggCount,
              henCount: henCount,
              totalAmount: totalAmount,
              transactionDate: DateTime.now().toString(),
              pricePerEgg: widget.isSell ? pricePerEgg : 0.0,
              pricePerHen: widget.isSell ? pricePerHen : 0.0,
            );

            widget.onTransactionSuccess(sale);
            Navigator.pop(context);
          },
          child: Text(widget.isSell ? 'Sell' : 'Buy'),
        ),
      ],
    );
  }
}

class Farm {
  final int id;
  final String name;
  final String location;

  Farm({
    required this.id,
    required this.name,
    required this.location,
  });
}

class Egg {
  final int farmId;
  int count;

  Egg({
    required this.farmId,
    required this.count,
  });
}

class Hen {
  final int farmId;
  int count;

  Hen({
    required this.farmId,
    required this.count,
  });
}
