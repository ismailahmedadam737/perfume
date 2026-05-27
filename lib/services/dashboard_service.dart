import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  // ⚠️ Xasuusin: Haddii aad Emulator isticmaalayso, isticmaal "http://10.0.2.2:5000/api/dashboard/stats"
  static const String baseUrl = "http://localhost:5000/api/dashboard/stats";

  /// Function-kan wuxuu soo celinayaa dhammaan tirsiga (counts) ee:
  /// products, employees, customers, iyo settings.
  static Future<Map<String, dynamic>> fetchDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['success'] == true) {
          // Waxaan soo celinaynaa 'data' oo ay ku jiraan: products, employees, customers, settings
          return responseData['data'];
        } else {
          throw Exception("Backend-ku ma soo celin xog sax ah");
        }
      } else {
        throw Exception("Laguma guulaysan soo saarista xogta dashboard-ka: ${response.statusCode}");
      }
    } catch (e) {
      print("Dashboard Error: $e");
      // Waxaan soo celinaynaa xog eber ah haddii ay cillad dhacdo si aanu UI-gu u "crash"-garayn
      return {
        "products": 0,
        "employees": 0,
        "customers": 0,
        "settings": 0
      };
    }
  }
}