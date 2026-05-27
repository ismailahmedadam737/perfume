import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  final String historyApiUrl = 'http://localhost:5000/api/history';
  List<dynamic> todaySales = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  // Soo qaado xogta iibka ee maanta
  Future<void> _fetchHistory() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(historyApiUrl));
      if (response.statusCode == 200) {
        setState(() {
          todaySales = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  double get totalRevenue {
    return todaySales.fold(0, (sum, item) => sum + (double.tryParse(item['price'].toString()) ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: RefreshIndicator(
        onRefresh: _fetchHistory,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sales History",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
              ),
              const Text("Xogta iibka ee maanta la sameeyay", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 25),

              // Summary Cards
              Row(
                children: [
                  _buildSummaryCard("Total Revenue", "\$${totalRevenue.toStringAsFixed(2)}", Icons.payments_outlined, Colors.green),
                  const SizedBox(width: 20),
                  _buildSummaryCard("Items Sold", "${todaySales.length}", Icons.shopping_bag_outlined, Colors.blue),
                ],
              ),

              const SizedBox(height: 30),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : todaySales.isEmpty
                        ? const Center(child: Text("Maanta wax iib ah ma jiro."))
                        : ListView.separated(
                            itemCount: todaySales.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final item = todaySales[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.purple.withOpacity(0.1),
                                  child: const Icon(Icons.receipt_long, color: Colors.purple),
                                ),
                                title: Text(item['name'] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("Time: ${item['time']} | Qty: ${item['qty']}"),
                                trailing: Text(
                                  "\$${double.parse(item['price'].toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border(bottom: BorderSide(color: color, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}