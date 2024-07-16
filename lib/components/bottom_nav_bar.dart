import 'package:flutter/material.dart';
import 'package:pms/pages/owner/health_welfare_page.dart';
import 'package:pms/pages/owner/marketing_page.dart';
import 'package:pms/pages/owner/worker_management_page.dart';
import 'package:pms/pages/owner/farm_management_page.dart';
import 'package:pms/pages/owner/owner_dashboard.dart';
import 'package:pms/pages/owner/income_payment_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int? ownerId;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.ownerId,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == 0) {
      // Navigate to home page
      if (ownerId == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OwnerDashboard(ownerId: 3),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OwnerDashboard(ownerId: 3),
          ),
        );
      }
    } else {
      // Navigate to other pages
      switch (index) {
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MarketingPage(),
            ),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HealthWelfarePage(),
            ),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FarmManagementPage(),
            ),
          );
          break;
        case 4:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WorkerManagementPage(),
            ),
          );
          break;
        case 5:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const IncomePaymentPage(), // Replace with your Income and Payment page
            ),
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        _onItemTapped(context, index);
        onTap(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.deepPurple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Selling',
          backgroundColor: Colors.deepPurple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.health_and_safety),
          label: 'Health',
          backgroundColor: Colors.deepPurple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.agriculture),
          label: 'Farm',
          backgroundColor: Colors.deepPurple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Workers',
          backgroundColor: Colors.deepPurple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Income',
          backgroundColor: Colors.deepPurple,
        ),
      ],
      unselectedItemColor: Colors.grey,
    );
  }
}
