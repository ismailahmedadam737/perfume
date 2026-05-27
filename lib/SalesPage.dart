import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../services/product_service.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  static const String baseUrl = 'https://perfume-api-hr26.onrender.com/api/sales';
  static const Color primaryDark = Color(0xFF1E1E2D);
  static const Color backgroundColor = Color(0xFFF4F7FA);

  List<dynamic> products = [];
  List<dynamic> soldItems = [];
  List<dynamic> generalExpenses = [];
  bool isLoading = true;
  String? selectedPerfume;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // --- 1. RASIIDKA (UNIT PRICE IYO AMOUNT OO DHIMIS LA'AAN AH) ---
  Future<void> _printReceipt(dynamic item) async {
    final pdf = pw.Document();
    
    double discountVal = double.tryParse(item['discount'].toString()) ?? 0.0;
    double finalTotal = double.tryParse(item['total_amount'].toString()) ?? 0.0;
    int qty = int.tryParse(item['quantity'].toString()) ?? 1;

    double unitPrice = (finalTotal + discountVal) / qty;
    double amountBeforeDiscount = qty * unitPrice;

    pdf.addPage(
  pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                "PERFUME STORE", 
                style: pw.TextStyle(
                  fontSize: 14, 
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueAccent,
                ),
              ),
            ),
            pw.Center(child: pw.Text("Tel: 063-7758927 // 063-4869775 Zaad: 510624", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
            pw.Center(child: pw.Text("Hargeisa, Somaliland", style: const pw.TextStyle(fontSize: 7))),
            pw.SizedBox(height: 5),
            pw.Divider(thickness: 0.5),
            
            // INVOICE - Red Color
            pw.Center(
              child: pw.Text(
                "INVOICE", 
                style: pw.TextStyle(
                  fontSize: 8, 
                  fontWeight: pw.FontWeight.bold, 
                  color: PdfColors.red,
                ),
              ),
            ),
            
            pw.SizedBox(height: 2),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                // Invoice No - Red Color (Sidii aad hore u codsatay)
                pw.Text(
                  "No: ${item['invoice_no']}", 
                  style: pw.TextStyle(
                    fontSize: 7, 
                    fontWeight: pw.FontWeight.bold, 
                    color: PdfColors.red,
                  ),
                ),
                pw.Text("Date: ${DateTime.now().toString().split(' ')[0]}", style: const pw.TextStyle(fontSize: 7)),
              ],
            ),
            pw.SizedBox(height: 8),
            
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _pCell("No", true),
                    _pCell("Item", true),
                    _pCell("Qty", true),
                    _pCell("Unit Price", true), 
                    _pCell("Amount", true),     
                  ],
                ),
                pw.TableRow(
                  children: [
                    _pCell("1", false),
                    _pCell("${item['product_name']}", false),
                    _pCell("$qty", false),
                    _pCell("\$${unitPrice.toStringAsFixed(2)}", false),
                    _pCell("\$${amountBeforeDiscount.toStringAsFixed(2)}", false),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Subtotal: \$${amountBeforeDiscount.toStringAsFixed(2)}", 
                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.normal)),
                  pw.Text("Discount: -\$${discountVal.toStringAsFixed(2)}", 
                    style: pw.TextStyle(fontSize: 8, color: PdfColors.red)),
                  pw.SizedBox(height: 2),
                  pw.Container(width: 50, height: 0.5, color: PdfColors.black),
                  pw.SizedBox(height: 2),
                  pw.Text("Grand Total: \$${finalTotal.toStringAsFixed(2)}", 
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
            
            pw.SizedBox(height: 20),
            pw.Center(child: pw.Text("Waad ku mahadsantahay macmiil", style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic))),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _pCell(String text, bool isHeader) => pw.Padding(
    padding: const pw.EdgeInsets.all(3),
    child: pw.Text(text, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 6, fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal)),
  );

  // --- 2. FUNCTIONS (LOAD & SAVE) ---
  Future<void> _loadAllData() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final responses = await Future.wait([
        http.get(Uri.parse('$baseUrl/products')),
        http.get(Uri.parse('$baseUrl/sales')),
        ProductService.fetchKharashyada(),
      ]);
      setState(() {
        products = jsonDecode((responses[0] as http.Response).body);
        soldItems = jsonDecode((responses[1] as http.Response).body);
        generalExpenses = responses[2] as List<dynamic>;
        isLoading = false;
      });
    } catch (e) { if (mounted) setState(() => isLoading = false); }
  }

  Future<void> _addSaleToDb(Map<String, dynamic> data) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/sales'), 
          headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
      if (res.statusCode == 201 || res.statusCode == 200) _loadAllData();
    } catch (e) {}
  }

  // --- 3. UI DASHBOARD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryDark,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _showSalesForm,
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          _buildHeaderSummary(),
          Expanded(child: Row(children: [_buildPromoCard(), _buildSalesList()])),
        ],
      ),
    );
  }

  Widget _buildHeaderSummary() {
    final double income = soldItems.fold(0.0, (sum, item) => sum + (double.tryParse(item['total_amount'].toString()) ?? 0.0));
    final double exp = generalExpenses.fold(0.0, (sum, item) => sum + (double.tryParse(item['amount'].toString()) ?? 0.0));
    return Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [primaryDark, Color(0xFF2D2D44)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _summaryTile("Income", "\$${income.toStringAsFixed(2)}", Colors.white),
        _summaryTile("Expenses", "-\$${exp.toStringAsFixed(2)}", Colors.redAccent),
        _summaryTile("Profit", "+\$${(income - exp).toStringAsFixed(2)}", Colors.greenAccent),
      ]),
    );
  }

  Widget _summaryTile(String t, String v, Color c) => Column(children: [
    Text(t, style: const TextStyle(color: Colors.white70, fontSize: 13)),
    const SizedBox(height: 5),
    Text(v, style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.bold))
  ]);

  Widget _buildPromoCard() => Expanded(flex: 2, child: Padding(
    padding: const EdgeInsets.all(25.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1594035910387-fea47794261f?q=80&w=1000&auto=format&fit=crop'), fit: BoxFit.cover)
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(begin: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent])
        ),
        padding: const EdgeInsets.all(20),
        child: const Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Text("Cadarada Ugu Wanaagsan", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold))),
          Center(child: Text("Ugu kaalay meheradeena ", style: TextStyle(color: Colors.white70, fontSize: 14)))
        ]),
      ),
    ),
  ));

  Widget _buildSalesList() => Expanded(flex: 3, child: Padding(
    padding: const EdgeInsets.only(top: 25, right: 25, bottom: 25),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Diiwaanka Iibka", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryDark)),
      const SizedBox(height: 20),
      Expanded(child: soldItems.isEmpty ? const Center(child: Text("Ma jirto alaab la iibiyey.")) : ListView.builder(
        itemCount: soldItems.length,
        itemBuilder: (context, index) => _buildSaleItemCard(soldItems[index])
      ))
    ]),
  ));

  Widget _buildSaleItemCard(dynamic item) => Card(
    elevation: 0.5, margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: const Icon(Icons.local_mall_outlined, color: primaryDark),
      title: Text(item['product_name'] ?? "Product", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text("No: ${item['invoice_no']}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
      trailing: Wrap(spacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: [
        Text("\$${item['total_amount']}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.print, color: Colors.blue, size: 20), onPressed: () => _printReceipt(item))
      ]),
    ),
  );

  // --- 4. FORM-KA IIBKA ---
  void _showSalesForm() {
    // Automatic Number Generation: Waxay ka bilaabanaysaa 49119
    int nextNumber = 49119 + soldItems.length;
    
    final invC = TextEditingController(text: nextNumber.toString());
    final qtyC = TextEditingController(text: "1");
    final discountC = TextEditingController(text: "0");
    final priceC = TextEditingController();

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => AlertDialog(
      title: const Text("Iib Cusub"),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: invC, 
          readOnly: true, // Gacanta laguma bedeli karo
          decoration: const InputDecoration(labelText: "No:", labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
        ),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "Dooro Cadarka"),
          items: products.map((p) => DropdownMenuItem(value: p['name'] as String, child: Text(p['name']))).toList(),
          onChanged: (val) {
            setS(() {
              selectedPerfume = val;
              var p = products.firstWhere((e) => e['name'] == val);
              priceC.text = p['sellPrice'].toString();
            });
          },
        ),
        TextField(controller: qtyC, decoration: const InputDecoration(labelText: "Quantity"), keyboardType: TextInputType.number),
        TextField(controller: priceC, decoration: const InputDecoration(labelText: "Unit Price (\$)")),
        TextField(controller: discountC, decoration: const InputDecoration(labelText: "Discount (\$)"), keyboardType: TextInputType.number),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Ka noqo")),
        ElevatedButton(onPressed: () {
          double uPrice = double.tryParse(priceC.text) ?? 0.0;
          int qty = int.tryParse(qtyC.text) ?? 1;
          double disc = double.tryParse(discountC.text) ?? 0.0;
          
          double total = (uPrice * qty) - disc;

          _addSaleToDb({
            "invoice_no": invC.text, // Lambarka automatic-ga ah
            "product_name": selectedPerfume,
            "quantity": qty,
            "discount": disc,
            "total_amount": total,
            "payment_method": "Cash",
            "sale_date": DateTime.now().toIso8601String()
          });
          Navigator.pop(ctx);
        }, child: const Text("Xaqiiji")),
      ],
    )));
  }
}