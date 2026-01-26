import 'dart:convert';
import 'package:http/http.dart' as http;

class PublicAIProxy {

  static const String _endpoint =
      'https://llm-proxy-production.up.railway.app/v1/chat/completions';

  Future<String> _callAI(String system, String user) async {
    try {
      final res = await http
          .post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {"role": "system", "content": system},
            {"role": "user", "content": user}
          ],
          "temperature": 0.6
        }),
      )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode != 200) {
        throw Exception('AI server error');
      }

      final data = jsonDecode(res.body);
      return data['choices'][0]['message']['content'];
    } catch (e) {
      return '''
## AI Service Temporarily Unavailable

Below are **standard ecommerce recommendations** based on best practices:

### Pricing
- Keep pricing competitive within your category
- Avoid frequent price drops, use time-limited offers

### Inventory
- Maintain stock for 20–30 days for fast-moving products
- Reduce exposure on slow-moving items

### Marketing
- Focus on performance ads and remarketing
- Highlight value propositions clearly

### Next Action
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
    return _callAI(
        "You are an experienced ecommerce business analyst.",
        """
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
"""
    );
  }

  Future<String> salesAnalysis() {
    return _callAI(
        "You are a senior ecommerce sales analyst.",
        "Analyze ecommerce sales performance and suggest improvements."
    );
  }

  Future<String> marketingPlan() {
    return _callAI(
        "You are a digital marketing strategist.",
        "Create a professional ecommerce marketing plan for the next 60 days."
    );
  }

  Future<String> customerInsights() {
    return _callAI(
        "You are a CRM and retention expert.",
        "Provide actionable customer behavior insights for ecommerce growth."
    );
  }

  Future<String> inventoryPlan() {
    return _callAI(
        "You are a supply chain optimization expert.",
        "Suggest inventory optimization strategies for ecommerce operations."
    );
  }
}
