import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
  // Hubi in URL-ku uu yahay midka saxda ah ee API-gaaga
  static const String baseUrl = "https://perfume-api-hr26.onrender.com/api/customers";

  // --- SOO SAARISTA DHAMAAN MACAAMIISHA ---
  static Future<List<dynamic>> getCustomers() async {
    try {
      // Waan ku darnay '/all' si uu ula hadlo route-ka aan samaynay
      final response = await http.get(Uri.parse('$baseUrl/all'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // Waxaan soo saaraynaa liiska ku jira 'data'
        return responseData['data'] ?? []; 
      } else {
        throw Exception("Server-ku wuxuu soo celiyay qalad: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Cillad xidhiidh ayaa dhacday: $e");
    }
  }

  // --- DIIWAANGELINTA MACMIIL CUSUB ---
  static Future<Map<String, dynamic>> addCustomer(Map<String, dynamic> data) async {
    try {
      // Waan ku darnay '/add'
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['data']; // Soo celi macmiilka cusub ee la abuuray
      } else {
        throw Exception("Laguma guulaysan kaydinta");
      }
    } catch (e) {
      throw Exception("Cillad: $e");
    }
  }
}