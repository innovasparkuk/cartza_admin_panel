import 'dart:convert';
import 'package:http/http.dart' as http;

class HuggingFaceAI {
  static const String _model =
      'https://api-inference.huggingface.co/models/gpt2';

  // Token runtime par pass hoga
  static const String _apiKey =
  String.fromEnvironment('HF_TOKEN', defaultValue: '');

  Future<String> generate(String prompt) async {
    if (_apiKey.isEmpty) {
      return _fallbackResponse();
    }

    try {
      final res = await http
          .post(
        Uri.parse(_model),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "inputs": prompt,
          "parameters": {
            "max_new_tokens": 250,
            "temperature": 0.7,
            "return_full_text": false
          }
        }),
      )
          .timeout(const Duration(seconds: 60));

      if (res.statusCode != 200) {
        throw Exception('HF API error');
      }

      final data = jsonDecode(res.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['generated_text'] ?? 'No output from AI';
      }

      return 'No response from AI';
    } catch (_) {
      return _fallbackResponse();
    }
  }

  String _fallbackResponse() {
    return '''
AI service is unavailable.

Here are general ecommerce best practices:

Pricing:
Keep prices competitive and avoid over discounting.

Inventory:
Maintain 20 to 30 days of stock for fast movers.

Marketing:
Focus on performance ads and remarketing.

Retry later for AI powered insights.
''';
  }

  Future<String> productAnalysis({
    required String name,
    required String category,
    required double price,
    required int stock,
  }) {
    return generate("""
Analyze the following product and give business recommendations.

Name: $name
Category: $category
Price: $price
Stock: $stock
""");
  }

  Future<String> salesAnalysis() {
    return generate("Analyze ecommerce sales and suggest improvements.");
  }

  Future<String> marketingPlan() {
    return generate("Create a 60 day ecommerce marketing plan.");
  }

  Future<String> customerInsights() {
    return generate("Provide ecommerce customer retention insights.");
  }

  Future<String> inventoryPlan() {
    return generate("Suggest inventory optimization strategies.");
  }
}
