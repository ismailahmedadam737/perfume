import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/product_service.dart';

class GeneralReportPage extends StatefulWidget {
  const GeneralReportPage({super.key});

  @override
  State<GeneralReportPage> createState() => _GeneralReportPageState();
}

class _GeneralReportPageState extends State<GeneralReportPage> {
  static const String baseUrl = 'http://localhost:5000/api';
  List<dynamic> products = [];
  List<dynamic> soldItems = [];
  List<dynamic> generalExpenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      final pRes = await http.get(Uri.parse('$baseUrl/products'));
      final sRes = await http.get(Uri.parse('$baseUrl/sales'));
      final gExpenses = await ProductService.fetchKharashyada();

      if (pRes.statusCode == 200 && sRes.statusCode == 200) {
        setState(() {
          products = jsonDecode(pRes.body);
          soldItems = jsonDecode(sRes.body);
          generalExpenses = gExpenses;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // --- FUNCTION-KA DAABACAADDA OO LA HABEEYEY ---
  Future<void> _printReport(double income, double expenses, double profit) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage( // Waxaan u bedelay MultiPage si hadii liisku dheeraado uu bog kale u gudbo
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text("PERFUME STORE", style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                  pw.SizedBox(height: 8),
                  pw.Text("Tel: 063-7758927 // 063-4869775 Zaad: 510624", style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  pw.Text("Hargeisa-Somaliland", style: pw.TextStyle(fontSize: 13, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Divider(thickness: 2, color: PdfColors.blue900),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: pw.BoxDecoration(color: PdfColors.grey200, borderRadius: pw.BorderRadius.circular(5)),
                child: pw.Text("WARBIXINTA GUUD EE GANACSIGA", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400), borderRadius: pw.BorderRadius.circular(8)),
              child: pw.Column(
                children: [
                  _pdfRow("Iibka Guud:", "\$${income.toStringAsFixed(2)}"),
                  pw.Divider(color: PdfColors.grey200),
                  _pdfRow("Kharashka Guud:", "\$${expenses.toStringAsFixed(2)}"),
                  pw.Divider(color: PdfColors.grey200),
                  _pdfRow("Macaashka Safiga ah:", "\$${profit.toStringAsFixed(2)}"),
                ],
              ),
            ),
            pw.SizedBox(height: 30),
            
            // --- QEYBTA IIBKA (Dhaqdhaqaaqyadii u dambeeyay) ---
            pw.Text("Iibka u dambeeyay:", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
            pw.SizedBox(height: 10),
            ...soldItems.take(10).map((item) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 5),
              child: _pdfBullet("${item['product_name']}: +\$${item['total_amount']}", PdfColors.green800)
            )),

            pw.SizedBox(height: 20),

            // --- QEYBTA KHARASHAADKA ---
            pw.Text("Kharashaadka u dambeeyay:", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
            pw.SizedBox(height: 10),
            ...generalExpenses.take(10).map((item) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 5),
              child: _pdfBullet("${item['title'] ?? 'Kharash'}: -\$${item['amount']}", PdfColors.red800)
            )),

            pw.SizedBox(height: 40),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(width: 150, child: pw.Divider(thickness: 1, color: PdfColors.black)),
                    pw.SizedBox(height: 5),
                    pw.Text("Manager Signature", style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text("STAMP", style: pw.TextStyle(color: PdfColors.grey400, fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text("Official Stamp", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save(), name: 'Warbixinta_Perfume_Store');
  }

  pw.Widget _pdfBullet(String text, PdfColor color) {
    return pw.Row(children: [
      pw.Container(width: 6, height: 6, decoration: pw.BoxDecoration(color: color, shape: pw.BoxShape.circle)),
      pw.SizedBox(width: 10),
      pw.Text(text, style: pw.TextStyle(fontSize: 13, color: color)),
    ]);
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 6), child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
      pw.Text(value, style: const pw.TextStyle(fontSize: 14)),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    double totalIncome = soldItems.fold(0.0, (sum, item) => sum + (double.tryParse(item['total_amount'].toString()) ?? 0.0));
    double productCosts = soldItems.fold(0.0, (sum, item) {
      final product = products.firstWhere((p) => p['name'] == item['product_name'], orElse: () => null);
      double buyPrice = product != null ? double.tryParse(product['buyPrice']?.toString() ?? '0.0') ?? 0.0 : 0.0;
      return sum + (buyPrice * (int.tryParse(item['quantity']?.toString() ?? '1') ?? 1));
    });
    double otherExpenses = generalExpenses.fold(0.0, (sum, item) => sum + (double.tryParse(item['amount'].toString()) ?? 0.0));
    double totalExpenses = productCosts + otherExpenses;
    double netProfit = totalIncome - totalExpenses;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Warbixinta Guud", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B1B2F))),
                        Text("Kormeerka guud ee ganacsigaaga maanta", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _printReport(totalIncome, totalExpenses, netProfit),
                      icon: const Icon(Icons.print, size: 18),
                      label: const Text("Download Report"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    _buildStatCard("Iibka Guud", "\$${totalIncome.toStringAsFixed(2)}", Icons.trending_up, Colors.green),
                    const SizedBox(width: 20),
                    _buildStatCard("Kharashka", "\$${totalExpenses.toStringAsFixed(2)}", Icons.trending_down, Colors.redAccent),
                    const SizedBox(width: 20),
                    _buildStatCard("Macaashka", "\$${netProfit.toStringAsFixed(2)}", Icons.account_balance_wallet, Colors.blueAccent),
                    const SizedBox(width: 20),
                    _buildStatCard("Alaabta", "${products.length}", Icons.inventory, Colors.purple),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 350, padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Kobaca Iibka (Toddobadan)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Spacer(),
                            Center(child: Icon(Icons.bar_chart, size: 100, color: Colors.indigoAccent)),
                            Center(child: Text("Xogta halkan ayay ka muuqan doontaa", style: TextStyle(color: Colors.grey))),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 350, padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Dhaqdhaqaaqyadii U dambeeyay", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Divider(height: 30),
                            Expanded(
                              child: ListView(
                                children: [
                                  ...soldItems.map((item) => _buildRecentItem(item['product_name'], "+\$${item['total_amount']}", Colors.green)),
                                  ...generalExpenses.map((item) => _buildRecentItem(item['title'] ?? 'Kharash', "-\$${item['amount']}", Colors.red)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border(bottom: BorderSide(color: color, width: 4))),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: color, size: 28)),
          const SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ])
        ]),
      ),
    );
  }

  Widget _buildRecentItem(String title, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            CircleAvatar(radius: 4, backgroundColor: color),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 14)),
          ]),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}