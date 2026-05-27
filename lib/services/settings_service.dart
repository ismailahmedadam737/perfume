import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class SettingsService {
  // ⚠️ Xusuusin: Koodhka wuxuu hadda si toos ah u isticmaalayaa Server-kaaga Render ee Cloud-ka
  static const String baseUrl = "https://perfume-api-hr26.onrender.com/api/settings";

  // 1. Soo qaado xogta (GET)
  static Future<Map<String, dynamic>?> fetchSettings() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        if (result['success'] == true && result['data'] != null) {
          return result['data'];
        }
      }
      return null;
    } catch (e) {
      print("Cillad ayaa dhacday xog keenista: $e");
      return null;
    }
  }

  // 2. Keydi ama Update garee xogta (POST)
  static Future<bool> saveSettings({
    required String shopName,
    required String currencyName,
    required String phone,
    required String webLink,
    required String social,
    required Uint8List? logoBytes,
    required bool isRegistered,
  }) async {
    try {
      // Sawirka Bytes-ka ah u beddel Base64 si loogu keydiyo PostgreSQL TEXT field
      String? logoBase64;
      if (logoBytes != null) {
        logoBase64 = base64Encode(logoBytes);
      }

      final Map<String, dynamic> body = {
        "shopName": shopName,
        "currencyName": currencyName,
        "phone": phone,
        "webLink": webLink,
        "social": social,
        "logoData": logoBase64,
        "isRegistered": isRegistered,
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      print("Cillad ayaa dhacday keydinta: $e");
      return false;
    }
  }
}