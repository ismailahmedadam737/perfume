import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _pointsController = TextEditingController();

  List<dynamic> _customers = [];
  bool _isLoading = true;
  final String baseUrl = "https://perfume-api-hr26.onrender.com/api/customers";

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _customers = (data is List) ? data : (data['data'] ?? []);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addCustomer() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "email": _emailController.text,
          "address": _addressController.text,
          "points": int.tryParse(_pointsController.text) ?? 0,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        _fetchCustomers();
      }
    } catch (e) {
      debugPrint("Error adding: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text("Customer Management", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                // Form-ka waxaa ku jira meel la gelin karo
                Expanded(
                  child: ListView(
                    children: [
                      DataTable(
                        columns: const [
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Phone")),
                          DataColumn(label: Text("Points")),
                        ],
                        rows: _customers.map((c) => DataRow(cells: [
                          DataCell(Text(c['name']?.toString() ?? "-")),
                          DataCell(Text(c['phone']?.toString() ?? "-")),
                          DataCell(Text(c['points']?.toString() ?? "0")),
                        ])).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}