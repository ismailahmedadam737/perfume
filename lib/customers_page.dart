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

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('https://perfume-api-hr26.onrender.com/api/customers/all'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Customer Management", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  // Halkan waxaad ku dartay Table-ka
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("NAME")),
                          DataColumn(label: Text("PHONE")),
                          DataColumn(label: Text("EMAIL")),
                          DataColumn(label: Text("ADDRESS")),
                        ],
                        rows: _customers.map((c) => DataRow(cells: [
                          DataCell(Text(c['name']?.toString() ?? "-")),
                          DataCell(Text(c['phone']?.toString() ?? "-")),
                          DataCell(Text(c['email']?.toString() ?? "-")),
                          DataCell(Text(c['address']?.toString() ?? "-")),
                        ])).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}