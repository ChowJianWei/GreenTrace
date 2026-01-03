import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:4000';

  Future<List<Map<String, dynamic>>> fetchBins() async {
    final uri = Uri.parse('$baseUrl/api/bins');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(data['bins'] ?? []);
    }
    throw Exception('Failed to load bins');
  }

  Future<Map<String, dynamic>> classifyWaste(String base64Image) async {
    final uri = Uri.parse('$baseUrl/api/classify');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'imageBase64': base64Image}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to classify waste');
  }
}
