
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000";


  static Future<void> updateProductStock(String id, int stock) async {
    await http.put(
      Uri.parse('$baseUrl/products/$id/stock'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'stockQuantity': stock}),
    );
  }

  static Future<Map<String, dynamic>> _makeRequest({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/$endpoint');
      final headers = {'Content-Type': 'application/json'};

      print('🌐 API: $method $url');

      http.Response response;

      switch (method) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: json.encode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: json.encode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception('Invalid method: $method');
      }

      print('📡 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('🔥 API Error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Check server connection'
      };
    }
  }

   static Future<List<dynamic>> getProducts() async {
    try {
      final response = await _makeRequest(endpoint: 'products');
      if (response['success'] == true) {
        return response['products'] ?? [];
      }
      return [];
    } catch (e) {
      print('❌ getProducts error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> addProduct(Map<String, dynamic> product) async {
    return await _makeRequest(
      endpoint: 'products',
      method: 'POST',
      body: product,
    );
  }

  static Future<Map<String, dynamic>> updateProduct(String id, Map<String, dynamic> data) async {
    return await _makeRequest(
      endpoint: 'products/$id',
      method: 'PUT',
      body: data,
    );
  }

  static Future<Map<String, dynamic>> deleteProduct(String id) async {
    return await _makeRequest(
      endpoint: 'products/$id',
      method: 'DELETE',
    );
  }


  static Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _makeRequest(endpoint: 'stats');
      return response['stats'] ?? {
        'totalProducts': 0,
        'totalUsers': 0,
        'totalOrders': 0,
        'revenue': 0,
      };
    } catch (e) {
      print('❌ getStats error: $e');
      return {
        'totalProducts': 0,
        'totalUsers': 0,
        'totalOrders': 0,
        'revenue': 0,
      };
    }
  }


  static Future<Map<String, dynamic>> testConnection() async {
    return await _makeRequest(endpoint: 'test-db');
  }

  static Future<Map<String, dynamic>> addSampleData() async {
    return await _makeRequest(endpoint: 'seed');
  }

  static Future<bool> isServerRunning() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}