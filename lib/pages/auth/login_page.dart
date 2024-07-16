import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'register_page.dart';
import '../owner/owner_dashboard.dart';
import '../worker/worker_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // Editing controllers
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your email";
          }
          return null;
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Email',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            iconColor: const Color.fromARGB(255, 139, 96, 116)));

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password is required";
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            login();
          }
        },
        color: Colors.blue,
        child: const Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
        toolbarHeight: 80, // Aligns the title in the center
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(36.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/hen_logo.jpg', // Ensure you have this image in your assets folder
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 20),
                emailField,
                const SizedBox(height: 20),
                passwordField,
                const SizedBox(height: 20),
                loginButton,
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(onTap: () {}),
                      ),
                    );
                  },
                  child: const Text('Create an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Inside your login function in LoginPageState class
  void login() async {
    String url = "http://localhost/flutter/api/login.php";
    Map<String, dynamic> data = {
      "email": emailEditingController.text,
      "password": passwordEditingController.text
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          Fluttertoast.showToast(msg: "Login successful");

          if (result['role'] == 'owner') {
            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OwnerDashboard(ownerId: result['user_id']),
              ),
            );
          } else if (result['role'] == 'worker') {
            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WorkerDashboard(workerId: result['user_id']),
              ),
            );
          } else {
            Fluttertoast.showToast(msg: "Unknown role received from server");
          }
        } else {
          Fluttertoast.showToast(msg: result['message']);
        }
      } else {
        Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}
