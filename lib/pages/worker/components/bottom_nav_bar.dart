import 'package:flutter/material.dart';
import 'package:pms/pages/worker/worker_dashboard.dart';
import 'package:pms/pages/worker/eggs_management_page.dart';
import 'package:pms/pages/worker/hen_management_page.dart';
import 'package:pms/pages/worker/vaccination_page.dart';
import 'package:pms/pages/worker/health_record_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int? workerId; // Make workerId optional

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.workerId, // Optional workerId parameter
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WorkerDashboard(
              workerId: 1, // Pass workerId here (could be null)
            ),
          ),
        );
        onTap(0);
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EggManagementPage(),
          ),
        );
        onTap(1);
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HenManagementPage(),
          ),
        );
        onTap(2);
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HealthRecordPage(),
          ),
        );
        onTap(3);
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const VaccinationPage(),
          ),
        );
        onTap(4);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.deepPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              _onItemTapped(context, 0);
              onTap(0);
            },
          ),
          IconButton(
            icon: const Icon(Icons.inventory),
            onPressed: () {
              _onItemTapped(context, 1);
              onTap(1);
            },
          ),
          IconButton(
            icon: const Icon(Icons.assignment),
            onPressed: () {
              _onItemTapped(context, 2);
              onTap(2);
            },
          ),
          IconButton(
            icon: const Icon(Icons.healing),
            onPressed: () {
              _onItemTapped(context, 3);
              onTap(3);
            },
          ),
          IconButton(
            icon: const Icon(Icons.local_hospital),
            onPressed: () {
              _onItemTapped(context, 4);
              onTap(4);
            },
          ),
        ],
      ),
    );
  }
}
