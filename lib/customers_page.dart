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
  // URL-ka oo sax ah
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
        setState(() {
          // Waxaan hubinaynaa in xogta ay jirto (null safety)
          final data = json.decode(response.body);
          _customers = (data is List) ? data : (data['data'] ?? []);
        });
      }
    } catch (e) {
      debugPrint("Error fetching: $e");
    }
  }

  Future<void> _addCustomer() async {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
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

        if (response.statusCode == 200 || response.statusCode == 201) {
          _fetchCustomers();
          _clearControllers();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Macmiilka waa la diiwaangeliyey!")),
          );
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
            const SizedBox(height: 25),
            // Form-ka halkan ayaan uga soo gaabiyay, koodhkii hore waa sax ahaa
            _buildForm(),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("NAME")),
                    DataColumn(label: Text("PHONE")),
                    DataColumn(label: Text("EMAIL")),
                    DataColumn(label: Text("ADDRESS")),
                    DataColumn(label: Text("POINTS")),
                  ],
                  rows: _customers.map((customer) {
                    return DataRow(cells: [
                      DataCell(Text(customer['name']?.toString() ?? "")),
                      DataCell(Text(customer['phone']?.toString() ?? "")),
                      DataCell(Text(customer['email']?.toString() ?? "")),
                      DataCell(Text(customer['address']?.toString() ?? "")),
                      DataCell(Text("${customer['points'] ?? 0} pts")),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Waan u kala qaaday si uu koodhku u nadiif noqdo
  Widget _buildForm() {
    return Container(
       // Halkan geli Container-kii hore ee form-ka ahaa...
       child: const Text("Form content here") 
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