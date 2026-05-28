import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _pointsController = TextEditingController();

  List<dynamic> _customers = [];
  bool _isLoading = true; // Waxaan ku darnay Loading state
  final String apiUrl = "https://perfume-api-hr26.onrender.com/api/customers";

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$apiUrl/all'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _customers = responseData['data'] ?? [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) // Cilad saarid: Haddi uu cawlan yahay, muuji loading
          : Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Customer Management", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),
                  // ... (Halkan geli qaybta Form-kaaga)
                  Expanded(
                    child: _customers.isEmpty 
                      ? const Center(child: Text("Xog lama helin"))
                      : SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text("NAME")),
                              DataColumn(label: Text("PHONE")),
                              DataColumn(label: Text("EMAIL")),
                            ],
                            rows: _customers.map((c) => DataRow(cells: [
                              DataCell(Text(c['name']?.toString() ?? "")),
                              DataCell(Text(c['phone']?.toString() ?? "")),
                              DataCell(Text(c['email']?.toString() ?? "")),
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