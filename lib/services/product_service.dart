import 'dart:convert';
import 'package:http/http.dart' as http;

// Kani waa adeeggaagii kharashka (Waxaa lagu daray Delete)
class ProductService {
  // ⚠️ Xusuusin: Koodhka wuxuu hadda si toos ah u isticmaalayaa Server-kaaga Render ee Cloud-ka
  static const String baseUrl = 'https://perfume-api-hr26.onrender.com/api/kharash';

  static Future<bool> postKharash(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<dynamic>> fetchKharashyada() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // --- QAYBTA CUSUB: TIRTIRISTA KHARASHKA ---
  static Future<bool> deleteKharash(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      // Haddii server-ku soo celiyo 200 (OK) ama 204 (No Content)
      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      print("Error deleting expense: $e");
      return false;
    }
  }
}

// Kani waa adeegga cusub ee Warbixinta Guud (General Report)
class GeneralTransactionService {
  // ⚠️ Xusuusin: Koodhka wuxuu hadda si toos ah u isticmaalayaa Server-kaaga Render ee Cloud-ka
  static const String baseUrl = 'https://perfume-api-hr26.onrender.com/api/general';

  // Inaad soo akhriso stats-ka iyo dhamaan transactions-ka
  static Future<Map<String, dynamic>?> fetchGeneralReport() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/report'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Error fetching report: $e");
      return null;
    }
  }

  // Inaad ku darto iib cusub ama kharash dhinaca report-ka ah
  static Future<bool> postGeneralTransaction(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}