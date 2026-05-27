import 'package:flutter/material.dart';
import 'package:perfume/services/supplier_service.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  // List of Suppliers
  List<dynamic> _suppliers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSuppliers(); // Soo aqri xogta marka page-ku bilowdo
  }

  // --- API FUNCTIONS ---

  Future<void> _fetchSuppliers() async {
    try {
      final data = await SupplierService.getSuppliers();
      setState(() {
        _suppliers = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError("Error loading suppliers: $e");
    }
  }

  Future<void> _addSupplier() async {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      try {
        final Map<String, dynamic> newSupplier = {
          'name': _nameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'balance': _balanceController.text.isEmpty ? "0.00" : _balanceController.text,
        };

        await SupplierService.addSupplier(newSupplier);
        _fetchSuppliers(); // Refresh list-ka
        _clearControllers();
        Navigator.pop(context);
      } catch (e) {
        _showError("Error adding supplier: $e");
      }
    }
  }

  Future<void> _updateSupplier(int id) async {
    try {
      final Map<String, dynamic> updatedData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'balance': _balanceController.text,
      };

      await SupplierService.updateSupplier(id, updatedData);
      _fetchSuppliers(); // Refresh list-ka
      _clearControllers();
      Navigator.pop(context);
    } catch (e) {
      _showError("Error updating supplier: $e");
    }
  }

  Future<void> _deleteSupplier(int id) async {
    try {
      await SupplierService.deleteSupplier(id);
      _fetchSuppliers(); // Refresh list-ka
    } catch (e) {
      _showError("Error deleting supplier: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearControllers() {
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _addressController.clear();
    _balanceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Suppliers Management", 
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text("Diiwaangeli shirkadaha aad alaabta ka iibsato", 
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _clearControllers();
                    _openSupplierModal(isEdit: false);
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Add New Supplier", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // --- SUPPLIER LIST OR EMPTY STATE ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator()) 
                  : (_suppliers.isEmpty 
                    ? _buildEmptyState() 
                    : _buildSupplierTable()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.local_shipping_outlined, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 20),
        const Text("Ma jiraan Supplier-ro la diiwaangaliyay", 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 10),
        const Text("Fadlan riix badhanka sare si aad u bilowdo diiwaangalinta.", 
          style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSupplierTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.05),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Row(
            children: const [
              Expanded(flex: 2, child: Text("SUPPLIER NAME", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))),
              Expanded(child: Text("PHONE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))),
              Expanded(child: Text("EMAIL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))),
              Expanded(child: Text("ADDRESS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))),
              Expanded(child: Text("BALANCE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))),
              SizedBox(width: 100),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: _suppliers.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final s = _suppliers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text(s['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600))),
                    Expanded(child: Text(s['phone'] ?? '')),
                    Expanded(child: Text(s['email'] ?? '', style: const TextStyle(color: Colors.blue, fontSize: 13))),
                    Expanded(child: Text(s['address'] ?? '')),
                    Expanded(child: Text("\$${s['balance']}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                            onPressed: () {
                              _nameController.text = s['name'].toString();
                              _phoneController.text = s['phone'].toString();
                              _emailController.text = s['email'].toString();
                              _addressController.text = s['address'].toString();
                              _balanceController.text = s['balance'].toString();
                              _openSupplierModal(isEdit: true, id: s['id']); // Waxaa la isticmaalaya ID halkii index laga isticmaali lahaa
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                            onPressed: () => _deleteSupplier(s['id']),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openSupplierModal({required bool isEdit, int? id}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEdit ? "Edit Supplier" : "New Supplier", 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                _buildField("Supplier Name", _nameController, Icons.person),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _buildField("Phone Number", _phoneController, Icons.phone)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildField("Balance (\$)", _balanceController, Icons.money, type: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 15),
                _buildField("Email Address", _emailController, Icons.email),
                const SizedBox(height: 15),
                _buildField("Business Address", _addressController, Icons.location_on),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () {
                        if (isEdit && id != null) {
                          _updateSupplier(id);
                        } else {
                          _addSupplier();
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                      child: Text(isEdit ? "Update Supplier" : "Save Supplier", style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon, {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: type,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: Colors.purple),
            hintText: "Enter $label",
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}