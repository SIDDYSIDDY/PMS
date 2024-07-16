import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pms/components/bottom_nav_bar.dart';
import 'package:pms/models/worker.dart'; // Import your Worker model

class WorkerManagementPage extends StatefulWidget {
  const WorkerManagementPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WorkerManagementPageState createState() => _WorkerManagementPageState();
}

class _WorkerManagementPageState extends State<WorkerManagementPage> {
  List<Worker> workers = [];
  String message = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchWorkers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> fetchWorkers() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost/flutter/api/workers.php'));

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          setState(() {
            workers = (jsonResponse['data'] as List<dynamic>)
                .map((model) => Worker.fromJson(model))
                .toList();
          });
        } else {
          throw Exception('Failed to load workers');
        }
      } else {
        throw Exception('Failed to load workers');
      }
    } catch (error) {
      setState(() {
        message = 'Error: $error';
      });
    }
  }

  Future<void> deleteWorker(String email) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost/flutter/api/delete_worker.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          setState(() {
            message = 'Worker deleted successfully';
          });
          fetchWorkers(); // Refresh the list of workers after deletion
        } else {
          throw Exception(
              'Failed to delete worker: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to delete worker: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        message = 'Error: $error';
      });
    }
  }

  Future<void> addWorker() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost/flutter/api/workers.php'),
          body: jsonEncode({
            'name': _nameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'address': _addressController.text,
            'password': _passwordController.text,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final dynamic jsonResponse = jsonDecode(response.body);

          if (jsonResponse['status'] == 'success') {
            setState(() {
              message = 'New worker added successfully';
              _nameController.clear();
              _emailController.clear();
              _phoneController.clear();
              _addressController.clear();
              _passwordController.clear();
            });
            fetchWorkers(); // Refresh the list of workers after addition
          } else {
            throw Exception('Failed to add worker: ${jsonResponse['message']}');
          }
        } else {
          throw Exception('Failed to add worker: ${response.statusCode}');
        }
      } catch (error) {
        setState(() {
          message = 'Error: $error';
        });
      }
    }
  }

  Future<void> editWorker(Worker worker) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost/flutter/api/workers.php'),
        body: jsonEncode({
          'id': worker.id,
          'name': worker.name,
          'email': worker.email,
          'phone': worker.phone,
          'address': worker.address,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          setState(() {
            message = 'Worker updated successfully';
          });
          fetchWorkers(); // Refresh the list of workers after editing
        } else {
          throw Exception(
              'Failed to update worker: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to update worker: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        message = 'Error: $error';
      });
    }
  }

  void showEditWorkerDialog(Worker worker) {
    _nameController.text = worker.name;
    _emailController.text = worker.email;
    _phoneController.text = worker.phone;
    _addressController.text = worker.address;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Worker'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  editWorker(Worker(
                    id: worker.id,
                    name: _nameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    password: '',
                  ));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Management'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: addWorker,
                    child: const Text('Add Worker'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: workers.length,
              itemBuilder: (context, index) {
                final worker = workers[index];
                return Card(
                  child: ListTile(
                    title: Text(worker.name),
                    subtitle: Text(worker.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showEditWorkerDialog(worker);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteWorker(worker.email);
                          },
                        ),
                      ],
                    ),
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
          });
        },
      ),
    );
  }
}
