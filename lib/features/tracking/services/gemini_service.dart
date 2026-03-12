import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  // Agora ele puxa do arquivo secreto, seguro e blindado!
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<Map<String, int>?> analyzeMeal(String prompt) async {
    // Usamos o modelo flash porque é super rápido e perfeito para tarefas curtas
    final model = GenerativeModel(
      model: 'gemini-2.5-flash', // <-- O modelo mais rápido e atual!
      apiKey: _apiKey,
    );

    // O truque da Engenharia de Prompt: forçar a IA a cuspir SÓ o JSON!
    final structuredPrompt = '''
    Atue como um nutricionista. O usuário comeu o seguinte: "$prompt".
    Calcule as calorias e os macronutrientes aproximados.
    Retorne APENAS um JSON válido com esta estrutura exata (use números inteiros):
    {"kcal": 0, "protein": 0, "carbo": 0, "fat": 0}
    Não adicione crases, blocos de código, nem texto explicativo. Apenas o JSON puro.
    ''';

    try {
      final response = await model.generateContent([
        Content.text(structuredPrompt),
      ]);
      final text = response.text;

      if (text != null) {
        // Limpamos alguma sujeira (como as crases ```json) caso a IA seja teimosa
        final cleanText =
            text.replaceAll('```json', '').replaceAll('```', '').trim();
        final Map<String, dynamic> data = jsonDecode(cleanText);

        return {
          'kcal': data['kcal'] as int,
          'protein': data['protein'] as int,
          'carbo': data['carbo'] as int,
          'fat': data['fat'] as int,
        };
      }
    } catch (e) {
      print('Erro ao consultar o Gemini: $e');
    }
    return null; // Se der ruim, retorna nulo
  }

  Future<void> listarModelosDisponiveis() async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models?key=$_apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('====== MODELOS LIBERADOS PARA SUA CHAVE ======');
        for (var model in data['models']) {
          // Filtra só os que suportam gerar conteúdo de texto
          if (model['supportedGenerationMethods'] != null &&
              model['supportedGenerationMethods'].contains('generateContent')) {
            print(model['name']); // Vai imprimir algo como "models/gemini-..."
          }
        }
        print('=============================================');
      } else {
        print('Erro ao buscar modelos: ${response.body}');
      }
    } catch (e) {
      print('Erro no HTTP: $e');
    }
  }
}
