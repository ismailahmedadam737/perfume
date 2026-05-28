import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
  // URL-ka guud (saldhigga)
  static const String baseUrl = "https://perfume-api-hr26.onrender.com/api/customers";

  // --- 1. SOO SAARISTA MACAAMIISHA (GET) ---
  static Future<List<dynamic>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Halkan waxaan ku xallinaynaa Type Error-ka (haddii uu yahay Map ama List)
        return (data is List) ? data : (data['data'] ?? []);
      } else {
        throw Exception("Server-ka wuxuu soo celiyay: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Cillad xidhiidh: $e");
    }
  }

  // --- 2. DIIWAANGELINTA MACMIIL CUSUB (POST) ---
  static Future<Map<String, dynamic>> addCustomer(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'), // Endpoint-ka saxda ah ee loo adeegsado add
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Laguma guulaysan kaydinta");
      }
    } catch (e) {
      throw Exception("Cillad: $e");
    }
  }

  // --- 3. CUSUBAYSIINTA (PUT) ---
  static Future<void> updateCustomer(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/update/$id"), // Endpoint-ka saxda ah (tusaale ahaan)
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception("Laguma guulaysan cusubaysiinta");
      }
    } catch (e) {
      throw Exception("Cillad: $e");
    }
  }

  // --- 4. TIRTIRISTA (DELETE) ---
  static Future<void> deleteCustomer(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/delete/$id"), // Endpoint-ka saxda ah (tusaale ahaan)
      );

      if (response.statusCode != 200) {
        throw Exception("Laguma guulaysan in la tirtiro");
      }
    } catch (e) {
      throw Exception("Cillad: $e");
    }
  }
}