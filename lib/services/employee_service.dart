import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployeeService {
  // ⚠️ Xusuusin: Koodhka wuxuu hadda si toos ah u isticmaalayaa Server-kaaga Render ee Cloud-ka
  static const String baseUrl = "https://perfume-api-hr26.onrender.com/api/employees";
  static const String salaryUrl = "https://perfume-api-hr26.onrender.com/api/salaries";

  // ============================================================
  // --- QAYBTA SHAQAALAHA (EMPLOYEE SECTION) ---
  // ============================================================

  // --- SOO SAARISTA DHAMAAN SHAQAALAHA (GET) ---
  static Future<List<dynamic>> getAllEmployees() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Laguma guulaysan soo saarista shaqaalaha");
      }
    } catch (e) {
      throw Exception("Cillad xidhiidh ayaa dhacday: $e");
    }
  }

  // --- DIIWAANGELINTA SHAQAALE CUSUB (POST) ---
  static Future<Map<String, dynamic>> createEmployee(Map<String, dynamic> data) async {
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
        throw Exception(errorData['error'] ?? "Laguma guulaysan kaydinta");
      }
    } catch (e) {
      throw Exception("Cillad ayaa dhacday: $e");
    }
  }

  // --- CUSUBAYSIINTA SHAQAALAHA (PUT) ---
  static Future<void> updateEmployee(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode != 200) {
        throw Exception("Cusubaysiinta waa lagu guuldareystay");
      }
    } catch (e) {
      throw Exception("Cillad ayaa dhacday: $e");
    }
  }

  // --- TIRTIRISTA SHAQAALAHA (DELETE) ---
  static Future<void> deleteEmployee(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode != 200) {
        throw Exception("Tirtirista waa lagu guuldareystay");
      }
    } catch (e) {
      throw Exception("Cillad ayaa dhacday: $e");
    }
  }

  // ============================================================
  // --- QAYBTA MUSHAHARKA (SALARY SECTION) ---
  // ============================================================

  // --- SOO SAARISTA MUSHAHARKA (GET) ---
  // Waxay soo celisaa liiska shaqaalaha iyo xogta mushaharkooda (Automatic Sync)
  static Future<List<dynamic>> getAllSalaries() async {
    try {
      final response = await http.get(Uri.parse(salaryUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // Backend-ka wuxuu soo celinayaa {success: true, data: []}
      } else {
        throw Exception("Soo saarista mushaharka waa lagu guuldareystay");
      }
    } catch (e) {
      throw Exception("Cillad xidhiidh ayaa dhacday: $e");
    }
  }

  // --- BIXINTA MUSHAHARKA (PUT) ---
  // Waxaa loo soo diraa: amount, status, payment_method, bonus, deduction, payment_date
  static Future<void> paySalary(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse("$salaryUrl/pay/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Bixinta mushaharka waa lagu guul darreystay");
      }
    } catch (e) {
      throw Exception("Cillad ayaa dhacday markii lacagta la bixinayay: $e");
    }
  }
}