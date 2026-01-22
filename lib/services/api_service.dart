import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ⚠️ CHANGE THIS BASE URL IF NEEDED
  static const String baseUrl = "http://localhost:5000";
  // Android Emulator → http://10.0.2.2:5000

  /* ================= LOGIN ================= */
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/doctor/login"),
      headers: const {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["token"]);
      return true;
    }
    return false;
  }

  /* ================= GET TOKEN ================= */
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /* ================= BOOK APPOINTMENT ================= */
  static Future<String> bookAppointment(
      String patientName, String date, String time) async {
    final token = await getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/doctor/appointments"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "patientName": patientName,
        "date": date,
        "time": time,
      }),
    );

    final data = jsonDecode(response.body);
    return data["message"];
  }

  /* ================= VIEW APPOINTMENTS ================= */
  static Future<List<dynamic>> getAppointments() async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/doctor/appointments"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load appointments");
    }
  }
}
