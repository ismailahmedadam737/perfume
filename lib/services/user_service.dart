import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'https://perfume-api-hr26.onrender.com/api/users';

  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Waxaan hubinaynaa in xogta ay tahay Map
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  static Future<Object?> fetchUsers() async {}
}