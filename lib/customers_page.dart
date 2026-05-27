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
  
  // API URL-ka saxda ah (Hubi in backend-kaagu leeyahay /api/customers)
  final String apiUrl = "https://perfume-api-hr26.onrender.com/api/customers";

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  // API: Soo saarista xogta
  Future<void> _fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        setState(() {
          _customers = json.decode(response.body);
        });
      } else {
        debugPrint("Server error: ${response.statusCode}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Server Error: ${response.statusCode}")),
          );
        }
      }
    } catch (e) {
      debugPrint("Connection error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connection error: Fadlan hubi Internet-kaaga")),
        );
      }
    }
  }

  // API: Diiwaangelinta
  Future<void> _addCustomer() async {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": _nameController.text,
            "phone": _phoneController.text,
            "email": _emailController.text,
            "address": _addressController.text,
            "points": int.tryParse(_pointsController.text) ?? 0,
          }),
        );

        if (response.statusCode == 201) {
          _fetchCustomers(); // Dib u soo qabo xogta cusub
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
            const Text(
              "Customer Management",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
            const Text("Diiwaangeli oo maamul macaamiisha nidaamka", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
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
                          label: const Text("Save Customer", style: TextStyle(color: Colors.white, fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
                      horizontalMargin: 20,
                      columns: const [
                        DataColumn(label: Text("NAME", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))),
                        DataColumn(label: Text("PHONE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))),
                        DataColumn(label: Text("EMAIL", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))),
                        DataColumn(label: Text("ADDRESS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))),
                        DataColumn(label: Text("LOYALTY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))),
                      ],
                      rows: _customers.map((customer) {
                        return DataRow(cells: [
                          DataCell(Text(customer['name']?.toString() ?? '-')),
                          DataCell(Text(customer['phone']?.toString() ?? '-')),
                          DataCell(Text(customer['email']?.toString() ?? '-')),
                          DataCell(Text(customer['address']?.toString() ?? '-')),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${customer['points'] ?? 0} pts",
                                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
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
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: const Color(0xFFF5F6FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}