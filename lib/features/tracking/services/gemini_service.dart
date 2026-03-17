import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Import removido: package:flutter_dotenv/flutter_dotenv.dart
// Import removido: package:google_generative_ai/google_generative_ai.dart

class GeminiService {
  // URL oficial da Cloud Function (Backend Proxy para proteger a API Key do Gemini)
  static const String _functionUrl = 'https://analyzemeal-6wp5xpjb3a-uc.a.run.app';

  Future<Map<String, int>?> analyzeMeal(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      ).timeout(const Duration(seconds: 15)); // Timeout pra não travar a UI pra sempre

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return {
          'kcal': data['kcal'] as int,
          'protein': data['protein'] as int,
          'carbo': data['carbo'] as int,
          'fat': data['fat'] as int,
        };
      } else {
        debugPrint('Erro no servidor do Firebase: ${response.statusCode}');
        throw Exception('server_error');
      }
    } catch (e) {
      debugPrint('Erro ao consultar o Proxy do Gemini: $e');
      if (e is SocketException || e is HttpException || e.toString().contains('TimeoutException')) {
        throw Exception('network_error');
      }
      throw Exception('parse_error');
    }
  }

}
