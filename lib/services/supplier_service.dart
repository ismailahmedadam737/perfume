import 'dart:convert';
import 'package:http/http.dart' as http;

class SupplierService {
  // ⚠️ Xusuusin: Koodhka wuxuu hadda si toos ah u isticmaalayaa Server-kaaga Render ee Cloud-ka
  static const String baseUrl = "https://perfume-api-hr26.onrender.com/api/suppliers";

  // --- GET ALL SUPPLIERS ---
  static Future<List<dynamic>> getSuppliers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Laguma guulaysan soo saarista xogta: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Cillad ayaa dhacday: $e");
    }
  }

  // --- ADD SUPPLIER ---
  static Future<Map<String, dynamic>> addSupplier(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? "Laguma guulaysan in la diiwaangeliyo");
      }
    } catch (e) {
      throw Exception("Cillad ayaa dhacday: $e");
    }
  }

  // --- UPDATE SUPPLIER ---
  static Future<void> updateSupplier(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? "Laguma guulaysan in la cusubaysiiyo");
      }
    } catch (e) {
      throw Exception("Cillad ayaa dhacday: $e");
    }
  }

  // --- DELETE SUPPLIER ---
  static Future<void> deleteSupplier(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/$id"),
      );

      if (response.statusCode != 200) {
        throw Exception("Laguma guulaysan in la tirtiro xogta");
      }
    } catch (e) {
      throw Exception("Cillad ayaa dhacday: $e");
    }
  }
}