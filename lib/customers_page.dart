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
  // URL-ka saxda ah ee API-gaaga
  final String apiUrl = "https://perfume-api-hr26.onrender.com/api/customers";

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  // API: Soo saarista xogta
  Future<void> _fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/all'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Xallinta Type Error: Haddii ay tahay List ama Map 'data'
          _customers = (data is List) ? data : (data['data'] ?? []);
        });
      }
    } catch (e) {
      debugPrint("Error fetching: $e");
    }
  }

  // API: Diiwaangelinta
  Future<void> _addCustomer() async {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('$apiUrl/add'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": _nameController.text,
            "phone": _phoneController.text,
            "email": _emailController.text,
            "address": _addressController.text,
            "points": int.tryParse(_pointsController.text) ?? 0,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          _fetchCustomers();
          _clearControllers();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Macmiilka waa la diiwaangeliyey!")),
            );
          }
        }
      } catch (e) {
        debugPrint("Error adding: $e");
      }
    }
  }

  void _clearControllers() {
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _addressController.clear();
    _pointsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Customer Management", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            const Text("Diiwaangeli oo maamul macaamiisha nidaamka", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),

            // Form-ka
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildTextField(_nameController, "Full Name", Icons.person_outline),
                      const SizedBox(width: 15),
                      _buildTextField(_phoneController, "Phone Number", Icons.phone_android_outlined),
                      const SizedBox(width: 15),
                      _buildTextField(_emailController, "Email Address", Icons.email_outlined),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildTextField(_addressController, "Address", Icons.location_on_outlined),
                      const SizedBox(width: 15),
                      _buildTextField(_pointsController, "Loyalty Points", Icons.star_outline),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _addCustomer,
                          icon: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
                          label: const Text("Save Customer", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Table-ka
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("NAME")),
                      DataColumn(label: Text("PHONE")),
                      DataColumn(label: Text("EMAIL")),
                      DataColumn(label: Text("ADDRESS")),
                      DataColumn(label: Text("LOYALTY")),
                    ],
                    rows: _customers.map((customer) {
                      return DataRow(cells: [
                        DataCell(Text(customer['name']?.toString() ?? "-")),
                        DataCell(Text(customer['phone']?.toString() ?? "-")),
                        DataCell(Text(customer['email']?.toString() ?? "-")),
                        DataCell(Text(customer['address']?.toString() ?? "-")),
                        DataCell(Text("${customer['points'] ?? 0} pts")),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.pinkAccent, size: 20),
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF5F6FA),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}