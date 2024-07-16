import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl package to format the date
import 'package:pms/pages/worker/components/bottom_nav_bar.dart';
import 'package:pms/pages/worker/components/top_bar.dart'; // Import the TopBar widget

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key, required this.workerId});

  final int workerId;

  @override
  // ignore: library_private_types_in_public_api
  _WorkerDashboardState createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  int _currentIndex = 0;
  late String _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateFormat('MMMM d, yyyy')
        .format(DateTime.now()); // Format current date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const TopBar(title: 'PMS'), // Use the TopBar widget with PMS title
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Welcome to the Worker Dashboard',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              'Today\'s Date: $_currentDate',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            const Text(
              'This dashboard allows you to manage various aspects of poultry management:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              '- Add eggs: Record new egg entries into the system.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Add poultry: Log new poultry additions or updates.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Add vaccinations: Track vaccinations administered to poultry.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Add health records: Maintain health records for poultry.',
              style: TextStyle(fontSize: 16),
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
