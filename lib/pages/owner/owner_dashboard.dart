import 'package:flutter/material.dart';
import 'package:pms/components/bottom_nav_bar.dart';
import 'package:pms/components/top_bar.dart'; // Import the TopBar widget

class OwnerDashboard extends StatefulWidget {
  final int ownerId;

  const OwnerDashboard({super.key, required this.ownerId});

  @override
  // ignore: library_private_types_in_public_api
  _OwnerDashboardState createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  int _currentIndex = 2; // Default to the 'Home' tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const TopBar(title: 'PMS'), // Use the TopBar widget with PMS title
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Farm Management
            Card(
              color: Colors.blue,
              child: ListTile(
                title: const Text('Farm Management'),
                subtitle: const Text('Manage farms'),
                leading: const Icon(Icons.landscape, color: Colors.white),
                trailing: const Icon(Icons.arrow_forward, color: Colors.white),
                onTap: () {
                  // Handle tap to navigate to farm management page
                },
              ),
            ),
            const SizedBox(height: 20.0),

            // Poultry Management
            Card(
              color: Colors.green,
              child: ListTile(
                title: const Text('Poultry Management'),
                subtitle: const Text('Manage poultry'),
                leading: const Icon(Icons.pets, color: Colors.white),
                trailing: const Icon(Icons.arrow_forward, color: Colors.white),
                onTap: () {
                  // Handle tap to navigate to poultry management page
                },
              ),
            ),
            const SizedBox(height: 20.0),

            // Health and Vaccination Management
            Card(
              color: Colors.orange,
              child: ListTile(
                title: const Text('Health and Vaccination Management'),
                subtitle: const Text('Manage health and vaccinations'),
                leading: const Icon(Icons.local_hospital, color: Colors.white),
                trailing: const Icon(Icons.arrow_forward, color: Colors.white),
                onTap: () {
                  // Handle tap to navigate to health and vaccination management page
                },
              ),
            ),
            const SizedBox(height: 20.0),

            // Income Management
            Card(
              color: Colors.purple,
              child: ListTile(
                title: const Text('Income Management'),
                subtitle: const Text('Manage income'),
                leading: const Icon(Icons.attach_money, color: Colors.white),
                trailing: const Icon(Icons.arrow_forward, color: Colors.white),
                onTap: () {
                  // Handle tap to navigate to income management page
                },
              ),
            ),
            const SizedBox(height: 20.0),
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
        ownerId: widget.ownerId, // Pass ownerId to BottomNavBar
      ),
    );
  }
}
