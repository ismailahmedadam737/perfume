import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
  static const String baseUrl = "https://perfume-api-hr26.onrender.com/api/customers";

  static Future<List<dynamic>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // Waxaan hubinaynaa in 'data' uu jiro, haddii kale waxaan soo celinaynaa list madhan
        return jsonResponse['data'] ?? [];
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Cillad xidhiidh: $e");
    }
  }

  static Future<bool> addCustomer(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}