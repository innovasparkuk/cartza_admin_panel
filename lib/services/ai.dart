
import 'dart:convert';
import 'package:http/http.dart' as http;

class HuggingFaceAI {
  static const String _apiKey = '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';
  static const String _model = 'https://api-inference.huggingface.co/models/gpt2';
  Future<String> generate(String prompt) async {
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

      print('HF Response code: ${res.statusCode}');
      print('HF Response body: ${res.body}');

      if (res.statusCode != 200) {
        throw Exception('HF API error');
      }

      final data = jsonDecode(res.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['generated_text'] ?? 'No output from AI';
      }

      return 'No response from AI';
    } catch (e) {
      print('HF Exception: $e');
      return '''
## AI Service Temporarily Unavailable

Below are **standard ecommerce recommendations** based on best practices:

### Pricing
- Keep pricing competitive within your category
- Avoid frequent discounts; use time-limited offers

### Inventory
- Maintain stock for 20–30 days for fast-moving products
- Reduce exposure on slow-moving items

### Marketing
- Focus on performance ads and remarketing
- Highlight value propositions clearly

### Next Actions
- Retry AI insights later for deeper analysis
''';
    }
  }

  Future<String> productAnalysis({
    required String name,
    required String category,
    required double price,
    required int stock,
  }) {
    return generate("""
You are an experienced ecommerce business analyst.

Analyze the product below and provide actionable business recommendations.

Product Name: $name
Category: $category
Price: $price
Stock Level: $stock

Respond in sections:
- Pricing Recommendation
- Demand Outlook
- Inventory Strategy
- Marketing Focus
- Profit Optimization
""");
  }

  Future<String> salesAnalysis() {
    return generate("""
You are a senior ecommerce sales analyst.

Analyze ecommerce sales performance and suggest improvements with actionable insights.
""");
  }

  Future<String> marketingPlan() {
    return generate("""
You are a digital marketing strategist.

Create a professional ecommerce marketing plan for the next 60 days.
""");
  }

  Future<String> customerInsights() {
    return generate("""
You are a CRM and retention expert.

Provide actionable customer behavior insights for ecommerce growth.
""");
  }

  Future<String> inventoryPlan() {
    return generate("""
You are a supply chain optimization expert.

Suggest inventory optimization strategies for ecommerce operations.
""");
  }
}
