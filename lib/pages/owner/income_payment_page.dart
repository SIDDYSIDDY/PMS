import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pms/components/bottom_nav_bar.dart';

class IncomePaymentPage extends StatefulWidget {
  const IncomePaymentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IncomePaymentPageState createState() => _IncomePaymentPageState();
}

class _IncomePaymentPageState extends State<IncomePaymentPage> {
  final TextEditingController _workerIdController = TextEditingController();
  final TextEditingController _paymentAmountController =
      TextEditingController();

  bool isLoading = true;
  List<Sale> salesData = [];
  List<Buy> buyData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await fetchSalesData();
      await fetchBuyData();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showToast("Error: $e");
    }
  }

  Future<void> fetchSalesData() async {
    final response = await http
        .get(Uri.parse('http://localhost/flutter/api/fetch_sales.php'));
    if (response.statusCode == 200) {
      try {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          salesData = jsonData.map((item) => Sale.fromJson(item)).toList();
        });
      } catch (e) {
        showToast("Error parsing sales data: $e");
      }
    } else {
      showToast("Failed to load sales data");
    }
  }

  Future<void> fetchBuyData() async {
    final response =
        await http.get(Uri.parse('http://localhost/flutter/api/fetch_buy.php'));
    if (response.statusCode == 200) {
      try {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          buyData = jsonData.map((item) => Buy.fromJson(item)).toList();
        });
      } catch (e) {
        showToast("Error parsing buy data: $e");
      }
    } else {
      showToast("Failed to load buy data");
    }
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  double calculateTotalSales() {
    double total = 0;
    for (var sale in salesData) {
      total += sale.totalAmount;
    }
    return total;
  }

  double calculateTotalBuys() {
    double total = 0;
    for (var buy in buyData) {
      total += buy.totalAmount;
    }
    return total;
  }

  double calculateIncome() {
    double totalIncome = calculateTotalSales() - calculateTotalBuys();
    return totalIncome;
  }

  Future<void> sendWorkerPayment() async {
    const String apiUrl =
        'http://localhost/flutter/api/save_worker_payment.php';

    try {
      int workerId = int.parse(_workerIdController.text);
      double paymentAmount = double.parse(_paymentAmountController.text);

      // Fetch current income
      double currentIncome = calculateIncome();

      // Validate payment amount against current income
      if (paymentAmount > currentIncome) {
        showToast("Payment amount exceeds available income");
        return;
      }

      // Create an instance of WorkerPayment
      WorkerPayment paymentData = WorkerPayment(
        workerId: workerId,
        paymentAmount: paymentAmount,
      );

      // Convert paymentData to JSON format
      Map<String, dynamic> data = paymentData.toJson();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        showToast("Payment data saved successfully!");
        // Clear text fields after successful submission
        _workerIdController.clear();
        _paymentAmountController.clear();
        // Optionally, fetch updated data after submission
        fetchData();
      } else {
        showToast("Failed to save payment data: ${response.statusCode}");
      }
    } catch (e) {
      showToast("Error sending payment data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income and Payments'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  const TabBar(
                    tabs: [
                      Tab(text: "Sales"),
                      Tab(text: "Buys"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SalesManagement(sales: salesData),
                        BuysManagement(buys: buyData),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      double income = calculateIncome();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Total Income'),
                          content: Text('Total Income: $income'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Calculate Income'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Worker Payment:',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextFormField(
                          controller: _workerIdController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Worker ID'),
                        ),
                        TextFormField(
                          controller: _paymentAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Payment Amount'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Validate inputs and submit data
                            sendWorkerPayment();
                          },
                          child: const Text('Submit Payment'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 5,
        onTap: (index) {},
      ),
    );
  }
}

class SalesManagement extends StatelessWidget {
  final List<Sale> sales;

  const SalesManagement({super.key, required this.sales});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Farm ID')),
              DataColumn(label: Text('Egg Count')),
              DataColumn(label: Text('Hen Count')),
              DataColumn(label: Text('Price per Egg')),
              DataColumn(label: Text('Price per Hen')),
              DataColumn(label: Text('Total Amount')),
              DataColumn(label: Text('Transaction Date')),
            ],
            rows: sales.map<DataRow>((sale) {
              return DataRow(
                cells: [
                  DataCell(Text(sale.id.toString())),
                  DataCell(Text(sale.farmId.toString())),
                  DataCell(Text(sale.eggCount.toString())),
                  DataCell(Text(sale.henCount.toString())),
                  DataCell(Text(sale.pricePerEgg.toString())),
                  DataCell(Text(sale.pricePerHen.toString())),
                  DataCell(Text(sale.totalAmount.toString())),
                  DataCell(Text(sale.transactionDate.toString())),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Text(
            'Total Sales: ${calculateTotalAmount(sales)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  double calculateTotalAmount(List<Sale> sales) {
    double total = 0;
    for (var sale in sales) {
      total += sale.totalAmount;
    }
    return total;
  }
}

class BuysManagement extends StatelessWidget {
  final List<Buy> buys;

  const BuysManagement({super.key, required this.buys});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Farm ID')),
              DataColumn(label: Text('Egg Count')),
              DataColumn(label: Text('Hen Count')),
              DataColumn(label: Text('Price per Egg')),
              DataColumn(label: Text('Price per Hen')),
              DataColumn(label: Text('Total Amount')),
              DataColumn(label: Text('Transaction Date')),
            ],
            rows: buys.map<DataRow>((buy) {
              return DataRow(
                cells: [
                  DataCell(Text(buy.id.toString())),
                  DataCell(Text(buy.farmId.toString())),
                  DataCell(Text(buy.eggCount.toString())),
                  DataCell(Text(buy.henCount.toString())),
                  DataCell(Text(buy.pricePerEgg.toString())),
                  DataCell(Text(buy.pricePerHen.toString())),
                  DataCell(Text(buy.totalAmount.toString())),
                  DataCell(Text(buy.transactionDate.toString())),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Text(
            'Total Buys: ${calculateTotalAmount(buys)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  double calculateTotalAmount(List<Buy> buys) {
    double total = 0;
    for (var buy in buys) {
      total += buy.totalAmount;
    }
    return total;
  }
}

class Sale {
  final int id;
  final int farmId;
  final int eggCount;
  final int henCount;
  final double pricePerEgg;
  final double pricePerHen;
  final double totalAmount;
  final String transactionDate;

  Sale({
    required this.id,
    required this.farmId,
    required this.eggCount,
    required this.henCount,
    required this.pricePerEgg,
    required this.pricePerHen,
    required this.totalAmount,
    required this.transactionDate,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      farmId: json['farm_id'],
      eggCount: json['egg_count'],
      henCount: json['hen_count'],
      pricePerEgg: double.tryParse(json['price_per_egg'].toString()) ?? 0.0,
      pricePerHen: double.tryParse(json['price_per_hen'].toString()) ?? 0.0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      transactionDate: json['transaction_date'],
    );
  }
}

class Buy {
  final int id;
  final int farmId;
  final int eggCount;
  final int henCount;
  final double pricePerEgg;
  final double pricePerHen;
  final double totalAmount;
  final String transactionDate;

  Buy({
    required this.id,
    required this.farmId,
    required this.eggCount,
    required this.henCount,
    required this.pricePerEgg,
    required this.pricePerHen,
    required this.totalAmount,
    required this.transactionDate,
  });

  factory Buy.fromJson(Map<String, dynamic> json) {
    return Buy(
      id: json['id'],
      farmId: json['farm_id'],
      eggCount: json['egg_count'],
      henCount: json['hen_count'],
      pricePerEgg: double.tryParse(json['price_per_egg'].toString()) ?? 0.0,
      pricePerHen: double.tryParse(json['price_per_hen'].toString()) ?? 0.0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      transactionDate: json['transaction_date'],
    );
  }
}

class WorkerPayment {
  final int workerId;
  final double paymentAmount;

  WorkerPayment({
    required this.workerId,
    required this.paymentAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'worker_id': workerId,
      'payment_amount': paymentAmount,
    };
  }
}
