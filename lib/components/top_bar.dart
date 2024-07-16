import 'package:flutter/material.dart';
import 'package:pms/pages/auth/login_page.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopBar({super.key, this.title = "PMS"});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            // Navigate to the login page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
