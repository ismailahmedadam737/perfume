import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  // ⚠️ Xusuusin: Koodhka wuxuu hadda si toos ah u isticmaalayaa Server-kaaga Render ee Cloud-ka
  static const String baseUrl = 'https://perfume-api-hr26.onrender.com/api/users';

  // 1. LOGIN: Hadda waxaan isticmaalaynaa POST request maadaama aad API-ga ku dartay
  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      print("🚀 Iskuday Login: $email");

      final response = await http.post(
        Uri.parse('$baseUrl/login'), // Waxaan ku daray /login
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      print("📡 Status Code: ${response.statusCode}");
      print("📡 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Haddii login-ku sax yahay, server-ku wuxuu soo celinayaa user object
        return jsonDecode(response.body);
      } else {
        // Haddii uu yahay 401 (Khaldan) ama 500 (Error)
        return null;
      }
    } catch (e) {
      print("❌ Error Login: $e");
      return null;
    }
  }

  // 2. FETCH USERS: Sidii hore
  static Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 3. ADD USER: Sidii hore
  static Future<bool> addUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 4. DELETE USER: Sidii hore
  static Future<bool> deleteUser(dynamic id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}