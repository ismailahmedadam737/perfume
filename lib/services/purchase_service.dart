import 'dart:convert';
import 'package:http/http.dart' as http;

class PurchaseService {
  // ⚠️ Xusuusin: Koodhka wuxuu hadda si toos ah u isticmaalayaa Server-kaaga Render ee Cloud-ka
  static const String baseUrl = "https://perfume-api-hr26.onrender.com/api/purchases";

  // 1. Soo aqrinta dhamaan iibka (Read)
  Future<List<dynamic>> fetchPurchases() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // Maadaama backend-ku uu soo celinayo { success: true, data: [...] }
      } else {
        throw Exception("Ma la soo saari karo xogta iibka");
      }
    } catch (e) {
      print("Error Fetching Purchases: $e");
      return [];
    }
  }

  // 2. Galinta iib cusub (Create)
  Future<bool> savePurchase(Map<String, dynamic> purchaseData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "company_name": purchaseData['company_name'],
          "product_name": purchaseData['product_name'],
          "invoice_no": purchaseData['invoice_no'],
          "qty": int.parse(purchaseData['qty'].toString()),
          "total_price": double.parse(purchaseData['total_price'].toString()),
          "department": purchaseData['department'],
          "discount": double.parse(purchaseData['discount'].toString()),
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Error Saving Purchase: $e");
      return false;
    }
  }

  // 3. Cusboonaysiinta iibka (Update)
  Future<bool> updatePurchase(int id, Map<String, dynamic> purchaseData) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(purchaseData),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error Updating Purchase: $e");
      return false;
    }
  }

  // 4. Tirtirista iibka (Delete)
  Future<bool> deletePurchase(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      return response.statusCode == 200;
    } catch (e) {
      print("Error Deleting Purchase: $e");
      return false;
    }
  }
}