import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// --- API SERVICES ---
class ApiService {
  static const String baseUrl = "http://localhost:5000/api";

  static Future<List<dynamic>> getData(String endpoint) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/$endpoint"));
      if (res.statusCode == 200) return jsonDecode(res.body)['data'];
    } catch (e) { print(e); }
    return [];
  }

  static Future<bool> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/$endpoint"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) { print(e); return false; }
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PurchasePage(),
  ));
}

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  // --- CONTROLLERS ---
  final TextEditingController _purchaseNameController = TextEditingController();
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(); 
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _depController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // --- DATA LISTS ---
  List<dynamic> _purchaseList = [];
  List<dynamic> _companyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();

    // Dhageystayaasha xisaabinta
    _qtyController.addListener(_calculateTotal);
    _priceController.addListener(_calculateTotal);
  }

  // Shaqada xisaabinta: Qty * Price
  void _calculateTotal() {
    double qty = double.tryParse(_qtyController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0;
    double total = qty * price;
    
    // Halkan natiijada ayaa lagu shubayaa total controller
    _totalController.text = total > 0 ? total.toStringAsFixed(2) : "";
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    final companies = await ApiService.getData("companies");
    final purchases = await ApiService.getData("purchases");
    setState(() {
      _companyList = companies;
      _purchaseList = purchases;
      _isLoading = false;
    });
  }

  // --- FUNCTIONS ---
  void _addCompany() async {
    if (_companyNameController.text.isNotEmpty) {
      final companyData = {
        'company_name': _companyNameController.text,
        'owner_name': _ownerNameController.text,
        'phone': _phoneController.text,
        'location': _locationController.text,
      };

      bool success = await ApiService.postData("companies", companyData);
      
      if (success) {
        _fetchInitialData();
        _companyNameController.clear();
        _ownerNameController.clear();
        _phoneController.clear();
        _locationController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Company registered successfully!")),
        );
      }
    }
  }

  void _addPurchase() async {
    if (_productNameController.text.isNotEmpty) {
      final purchaseData = {
        'company_name': _purchaseNameController.text,
        'product_name': _productNameController.text,
        'invoice_no': _invoiceController.text,
        'qty': _qtyController.text,
        'price': _priceController.text, 
        'total_price': _totalController.text,
        'department': _depController.text,
        'discount': _discountController.text,
      };

      bool success = await ApiService.postData("purchases", purchaseData);

      if (success) {
        _fetchInitialData();
        _productNameController.clear();
        _invoiceController.clear();
        _qtyController.clear();
        _priceController.clear();
        _totalController.clear();
        _depController.clear();
        _discountController.clear();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Purchase completed successfully!")),
        );
      }
    }
  }

  void _showCompanyCard(Map<String, dynamic> company) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 25, spreadRadius: 5)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.purple,
                child: Icon(Icons.business, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 15),
              Material(
                color: Colors.transparent,
                child: Text(company['company_name'] ?? company['company'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
              const Material(
                color: Colors.transparent,
                child: Text("Registered Entity", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              const Divider(height: 30),
              _infoRow(Icons.person, "Owner", company['owner_name'] ?? company['owner']),
              _infoRow(Icons.phone, "Phone", company['phone']),
              _infoRow(Icons.location_on, "Location", company['location']),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Close", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Icon(icon, color: Colors.purple, size: 20),
            const SizedBox(width: 10),
            Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
            Text(value, style: const TextStyle(fontSize: 14, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  void _showPurchaseForm(String companyName) {
    _purchaseNameController.text = companyName;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("New Purchase: $companyName", style: const TextStyle(fontSize: 18, color: Colors.purple)),
        content: SizedBox(
          width: 450,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInputField(_productNameController, "Product Name", Icons.inventory_2),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildInputField(_invoiceController, "Invoice #", Icons.numbers)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInputField(_qtyController, "Qty", Icons.add_box, type: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildInputField(_priceController, "Price Each", Icons.payments, type: TextInputType.number)),
                    const SizedBox(width: 10),
                    // Total Price waa ReadOnly si uusan u tirtirmin qofkana uusan u beddelin
                    Expanded(
                      child: TextField(
                        controller: _totalController,
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calculate, color: Colors.purple, size: 20),
                          hintText: "Total Price",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                   children: [
                     Expanded(child: _buildInputField(_discountController, "Discount", Icons.percent)),
                     const SizedBox(width: 10),
                     Expanded(child: _buildInputField(_depController, "Department", Icons.domain)),
                   ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addPurchase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Complete Purchase", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text("Company Management", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ActionChip(
              avatar: const Icon(Icons.grid_view_rounded, size: 18, color: Colors.white),
              label: const Text("View Items", style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.indigo,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ItemsListPage(items: _purchaseList)),
              ),
            ),
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.purple))
        : Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Register Company", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(height: 30),
                      _buildInputField(_companyNameController, "Company Name", Icons.business),
                      const SizedBox(height: 15),
                      _buildInputField(_ownerNameController, "Owner Name", Icons.person),
                      const SizedBox(height: 15),
                      _buildInputField(_phoneController, "Phone", Icons.phone),
                      const SizedBox(height: 15),
                      _buildInputField(_locationController, "Location", Icons.location_on),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _addCompany,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("Add New Company ", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Registered Companies", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(height: 30),
                    Expanded(
                      child: _companyList.isEmpty
                          ? const Center(child: Text("No companies yet."))
                          : ListView.builder(
                              itemCount: _companyList.length,
                              itemBuilder: (context, index) {
                                final company = _companyList[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    onTap: () => _showCompanyCard(company),
                                    leading: const CircleAvatar(child: Icon(Icons.business)),
                                    title: Text(company['company_name'] ?? "No Name", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(company['owner_name'] ?? "No Owner"),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                                      onPressed: () => _showPurchaseForm(company['company_name']),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController ctrl, String hint, IconData icon, {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.purple, size: 20),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}

// --- VIEW ALL ITEMS PAGE ---
class ItemsListPage extends StatelessWidget {
  final List<dynamic> items;
  const ItemsListPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text("Perfume Inventory Dashboard"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.indigo, Colors.purple]),
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?auto=format&fit=crop&q=80&w=800'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome to our", style: TextStyle(color: Colors.white70, fontSize: 22)),
                      Text("Perfume Store", style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: items.isEmpty
                ? const Center(child: Text("No perfumes recorded yet."))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ItemCard(item: item);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final dynamic item;
  const ItemCard({super.key, required this.item});

  void _showItemPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: Colors.amber, size: 40),
              const SizedBox(height: 10),
              Material(
                color: Colors.transparent,
                child: Text(item['product_name'] ?? "Unknown", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
              ),
              const Divider(height: 30),
              _row("Vendor", item['company_name'] ?? "Unknown"),
              _row("Invoice ID", "#${item['invoice_no']}"),
              _row("Quantity", "${item['qty']} Units"),
              _row("Price Each", "\$${item['price'] ?? '0'}"), 
              _row("Department", item['department'] ?? "N/A"),
              _row("Discount", "${item['discount']}%"),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
                child: _row("Total Payable", "\$${item['total_price']}"),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        onTap: () => _showItemPopUp(context),
        leading: const Icon(Icons.bubble_chart, color: Colors.indigo),
        title: Text(item['product_name'] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${item['company_name']} | ${item['created_at']?.toString().split('T')[0] ?? ''}"),
        trailing: Text("\$${item['total_price']}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}