import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
  // ⚠️ Xusuusin: Haddii aad Emulator isticmaalayso, isticmaal "http://10.0.2.2:5000/api/customers"
  static const String baseUrl = "http://localhost:5000/api/customers";

  // --- SOO SAARISTA DHAMAAN MACAAMIISHA (GET) ---
  static Future<List<dynamic>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Laguma guulaysan soo saarista macaamiisha: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Cillad xidhiidh ayaa dhacday: $e");
    }
  }

  // --- DIIWAANGELINTA MACMIIL CUSUB (POST) ---
  static Future<Map<String, dynamic>> addCustomer(Map<String, dynamic> data) async {
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
        throw Exception(errorData['error'] ?? "Laguma guulaysan kaydinta macmiilka");
      }
    } catch (e) {
      throw Exception("Cillad ayaa dhacday markii macmiilka la kaydinayay: $e");
    }
  }

  // --- CUSUBAYSIINTA MACMIILKA (PUT) ---
  static Future<void> updateCustomer(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? "Laguma guulaysan cusubaysiinta");
      }
    } catch (e) {
      throw Exception("Cillad ayaa dhacday: $e");
    }
  }

  // --- TIRTIRISTA MACMIILKA (DELETE) ---
  static Future<void> deleteCustomer(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/$id"),
      );

      if (response.statusCode != 200) {
        throw Exception("Laguma guulaysan in la tirtiro macmiilka");
      }
    } catch (e) {
      throw Exception("Cillad ayaa dhacday: $e");
    }
  }
}